#Requires -Version 5.1
<#
.SYNOPSIS
  Test af sync-skills.ps1's brugerspejl (~\.claude\skills) i en syntetisk mappe under %TEMP% - roerer intet rigtigt.
.DESCRIPTION
  Scenarier: foerste spejl, idempotens (-Check OK), -Check fanger afvigelse/manglende fil, en personlig skill og en
  junction med samme navn roeres aldrig, en fjernet skill ryddes fra brugerspejlet, fremmede mapper (fx synced)
  roeres aldrig. Exitkode = antal fejl.
.EXAMPLE
  & "AI OS\tools\test-sync-skills.ps1"
#>
$ErrorActionPreference = 'Stop'
$script = Join-Path $PSScriptRoot 'sync-skills.ps1'
$t = Join-Path $env:TEMP ("sync-skills-test-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
$fejl = @()
function Skriv($sti, $tekst) { New-Item -ItemType Directory -Force -Path (Split-Path -Parent $sti) | Out-Null; [IO.File]::WriteAllText($sti, $tekst) }
function Koer([string[]]$ekstra) {
  $ud = & powershell -NoProfile -ExecutionPolicy Bypass -File $script -Root $repo -BrugerSkills $bruger @ekstra *>&1
  return @{ Kode = $LASTEXITCODE; Ud = ($ud | Out-String) }
}
function Forvent($navn, $betingelse, $tekst) { if (-not $betingelse) { $script:fejl += "$navn - $tekst" } }

try {
  $repo = Join-Path $t 'repo'; $bruger = Join-Path $t 'hjem\.claude\skills'; $andet = Join-Path $t 'andet'
  Skriv "$repo\.agents\skills\aflever\SKILL.md" "---`nname: aflever`n---`nA`n"
  Skriv "$repo\.agents\skills\aflever\ref\noter.md" "noter`n"
  Skriv "$repo\.agents\skills\pause\SKILL.md" "---`nname: pause`n---`nP`n"
  Skriv "$repo\.agents\skills\personlig\SKILL.md" "AI OS-udgave`n"
  Skriv "$repo\.agents\skills\linket\SKILL.md" "AI OS-udgave`n"
  Skriv "$bruger\personlig\SKILL.md" "JSTs egen`n"                       # personlig skill med samme navn
  Skriv "$bruger\synced\x\SKILL.md" "konto-skill`n"                       # fremmed mappe
  Skriv "$andet\SKILL.md" "bag junction`n"
  New-Item -ItemType Junction -Path "$bruger\linket" -Target $andet | Out-Null
  # 'linket' staar paa styringslisten (fx en tidligere AI OS-mappe, som nogen har erstattet med et link): saa er det
  # KUN link-tjekket, der beskytter filen bag junctionen - ellers maaler scenariet intet (mutation 26-11-2026).
  Skriv "$bruger\.ai-os-skills" "linket`r`n"

  # 1) Foerste spejl
  $r = Koer @()
  Forvent '1-kode' ($r.Kode -eq 0) "foerste koersel exit $($r.Kode): $($r.Ud)"
  Forvent '1-aflever' ((Test-Path "$bruger\aflever\SKILL.md") -and (Test-Path "$bruger\aflever\ref\noter.md")) 'aflever (inkl. undermappe) ikke spejlet'
  Forvent '1-pause' (Test-Path "$bruger\pause\SKILL.md") 'pause ikke spejlet'
  Forvent '1-personlig' ((Get-Content "$bruger\personlig\SKILL.md") -eq 'JSTs egen') 'personlig skill med samme navn blev overskrevet'
  Forvent '1-junction' ((Get-Content "$andet\SKILL.md") -eq 'bag junction') 'filen bag en junction blev overskrevet'
  Forvent '1-synced' (Test-Path "$bruger\synced\x\SKILL.md") 'fremmed mappe (synced) blev roert'
  $liste = @(Get-Content "$bruger\.ai-os-skills")
  Forvent '1-liste' (-not (Compare-Object $liste @('aflever', 'pause'))) "styringslisten er [$($liste -join ',')], ventet [aflever,pause]"
  Forvent '1-repo-spejl' (Test-Path "$repo\.claude\skills\aflever\SKILL.md") 'repo-spejlet .claude\skills blev ikke skrevet'

  # 2) -Check melder sammenstoedene (personlig, linket), men ingen fildrift for de styrede
  $r = Koer @('-Check')
  Forvent '2-sammenstoed' ($r.Ud -match 'personlig findes allerede' -and $r.Ud -match 'linket findes allerede') 'sammenstoed blev ikke meldt'
  Forvent '2-ingen-fildrift' ($r.Ud -notmatch 'aflever\\SKILL\.md (afviger|mangler)') 'styret skill meldt som drift lige efter spejling'

  # 3) Uden sammenstoed er -Check groen (exit 0)
  Remove-Item -Recurse -Force "$repo\.agents\skills\personlig", "$repo\.agents\skills\linket", "$repo\.claude\skills\personlig", "$repo\.claude\skills\linket"
  $r = Koer @('-Check')
  Forvent '3-groen' ($r.Kode -eq 0) "-Check ikke groen uden sammenstoed (exit $($r.Kode)): $($r.Ud)"

  # 4) -Check fanger afvigelse og manglende fil i brugerspejlet
  Skriv "$bruger\aflever\SKILL.md" "haandrettet`n"
  Remove-Item "$bruger\pause\SKILL.md"
  $r = Koer @('-Check')
  Forvent '4-kode' ($r.Kode -eq 1) "-Check gav exit $($r.Kode) ved drift"
  Forvent '4-afviger' ($r.Ud -match 'aflever\\SKILL\.md afviger') 'afvigende fil ikke meldt'
  Forvent '4-mangler' ($r.Ud -match 'pause\\SKILL\.md mangler i brugerspejlet') 'manglende fil ikke meldt'
  $r = Koer @()
  Forvent '4-rettet' ((Get-Content "$bruger\aflever\SKILL.md")[-1] -eq 'A' -and (Test-Path "$bruger\pause\SKILL.md")) 'drift blev ikke rettet'

  # 5) En skill fjernet fra kilden ryddes fra brugerspejlet - fremmede mapper og personlig skill bestaar
  Remove-Item -Recurse -Force "$repo\.agents\skills\pause"
  $r = Koer @()
  Forvent '5-ryddet' (-not (Test-Path "$bruger\pause")) 'fjernet skill ligger stadig i brugerspejlet'
  Forvent '5-fremmed' ((Test-Path "$bruger\synced\x\SKILL.md") -and (Test-Path "$bruger\personlig\SKILL.md") -and (Test-Path "$andet\SKILL.md")) 'en fremmed mappe forsvandt'
  Forvent '5-liste' (-not (Compare-Object @(Get-Content "$bruger\.ai-os-skills") @('aflever'))) 'styringslisten ikke opdateret'

  # 6) -UdenBruger roerer ikke brugerspejlet
  Skriv "$bruger\aflever\SKILL.md" "roer ikke`n"
  $r = Koer @('-UdenBruger')
  Forvent '6-uden' ((Get-Content "$bruger\aflever\SKILL.md") -eq 'roer ikke') '-UdenBruger skrev alligevel i brugerspejlet'
}
finally {
  if (Test-Path "$t\hjem\.claude\skills\linket") { cmd /c rmdir "$t\hjem\.claude\skills\linket" }
  if (Test-Path $t) { Remove-Item -LiteralPath $t -Recurse -Force }
}
if ($fejl) { $fejl | ForEach-Object { Write-Output "FEJL: $_" }; exit $fejl.Count }
Write-Output 'OK: sync-skills brugerspejl (6 scenarier: spejl, sammenstoed, groen Check, drift, oprydning, -UdenBruger).'
exit 0
