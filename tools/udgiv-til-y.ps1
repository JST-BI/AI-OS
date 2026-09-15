<#
.SYNOPSIS
  "Udgiv": ajourfoer kollegernes delte kopier paa Y: fra JSTs arbejdskopier (OneDrive) og GitHub.
.DESCRIPTION
  1) Y:\AI OS  <- filkopi af <OneDrive>\AI OS (robocopy /E /XO: kun nyere filer, intet slettes).
     Udelader .git, .claude\worktrees, .codex-tmp, .obsidian\workspace.json, node_modules og alt personligt.
  2) Y:\AI SOSU\<repo> <- git pull --ff-only origin main i hver klon med remote. Lokale aendringer paa Y:
     stashes foerst (rapporteres), saa intet overskrives i blinde. Kloner uden remote fast-forwardes
     fra OneDrive-klonen, og et repo der mangler paa Y: klones derud.
  2b) Filer git ikke foelger (gitignoreret Input/Output m.m.) kopieres OneDrive -> Y:, naar de mangler
     eller er nyere. Ogsaa persondata - JSTs beslutning 2026-09-15.
  3) Rapporterer filer der KUN findes paa Y: - de skal hentes ind i OneDrive.
  Y:-kopierne er kollegernes arbejdsgrundlag: DATAKONTROLCENTER paa Y: og Z8050 m.fl. paa Y: roeres IKKE.
  Koeres af agenten paa kodeordet "Udgiv" (se AI OS\CLAUDE.md) eller manuelt.

  FORAELDEDE FILER: robocopy /XO sletter aldrig noget - det er bevidst. Men en FLYTNING i kilden
  ser ud som en ren tilfoejelse, saa den flyttede fil bliver liggende BEGGE steder paa Y:.
  Det skete 2026-09-05, da 11 agenter flyttede til agents-inaktive\: Y:\AI OS\agents\ viste
  19 filer, mens CLAUDE.md samme sted sagde 8 aktive. Scriptet rapporterer nu altid saadanne
  filer; det sletter dem kun med -RyddForaeldede.
.PARAMETER RyddForaeldede
  Slet de filer under Y:\AI OS der ikke laengere findes i kilden. Uden flaget rapporteres de kun.
  Roerer aldrig noget uden for Y:\AI OS, og aldrig repo-kopierne under Y:\AI SOSU.
.EXAMPLE
  & "<OneDrive>\AI OS\tools\udgiv-til-y.ps1"
  & "<OneDrive>\AI OS\tools\udgiv-til-y.ps1" -KunAIOS
  & "<OneDrive>\AI OS\tools\udgiv-til-y.ps1" -RyddForaeldede
.EXAMPLE
  # Naar Y: som drevbogstav ikke svarer (mappingen hoerer til en anden logon-session),
  # men UNC-stien gor - set 2026-09-05:
  $u = '\\sosurdata.net.local\Groups$\Ansatte'
  & "<OneDrive>\AI OS\tools\udgiv-til-y.ps1" -YAIOS "$u\AI OS" -YAISOSU "$u\AI SOSU"
#>
param(
  [string]$OneDrive = "C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers",
  [string]$YAIOS = "Y:\AI OS",
  [string]$YAISOSU = "Y:\AI SOSU",
  [switch]$KunAIOS,
  [switch]$RyddForaeldede,
  [string]$Log = (Join-Path $env:LOCALAPPDATA "Temp\udgiv-til-y.log")
)
$ErrorActionPreference = 'Continue'
function L($m) { $s = "{0:yyyy-MM-dd HH:mm:ss}  {1}" -f (Get-Date), $m; $s; $s | Out-File -Append -Encoding utf8 $Log }
L "UDGIV start"
if (-not (Test-Path $YAIOS)) { L "FEJL: $YAIOS findes ikke (VPN/Y: ikke tilsluttet?)"; exit 1 }

# 1) AI OS -> Y:\AI OS (filkopi)
$src = Join-Path $OneDrive "AI OS"
& robocopy $src $YAIOS /E /XO /R:2 /W:5 /XD .git .claude .codex-tmp .obsidian node_modules .agents /XF workspace.json /NFL /NDL /NJH /NP | Select-Object -Last 8 | ForEach-Object { L ("  " + $_.Trim()) }
$code = $LASTEXITCODE
L ("AI OS -> Y: robocopy exit $code " + $(if ($code -lt 8) { "(OK)" } else { "(FEJL)" }))
# .obsidian kopieres uden workspace.json (personlig tilstand)
& robocopy (Join-Path $src ".obsidian") (Join-Path $YAIOS ".obsidian") /E /XO /R:2 /W:5 /XF workspace.json workspace-mobile.json /NFL /NDL /NJH /NJS /NP | Out-Null

# 1b) Foraeldede filer paa Y: - dem kilden ikke laengere har. En flytning i kilden ser for
#     robocopy ud som en tilfoejelse, saa uden dette bliver den gamle placering liggende.
#     Samme udelukkelser som robocopy ovenfor, ellers ville .git/.claude se "foraeldede" ud.
$udeladt = @('.git', '.claude', '.codex-tmp', '.obsidian', 'node_modules', '.agents')
$foraeldede = @(Get-ChildItem -LiteralPath $YAIOS -Recurse -File -Force -ErrorAction SilentlyContinue | Where-Object {
    $rel = $_.FullName.Substring($YAIOS.Length).TrimStart('\')
    $top = $rel.Split('\')[0]
    ($udeladt -notcontains $top) -and -not (Test-Path -LiteralPath (Join-Path $src $rel))
  })
if ($foraeldede.Count -eq 0) {
  L "Foraeldede filer paa Y:\AI OS: ingen"
}
elseif ($RyddForaeldede) {
  foreach ($f in $foraeldede) { L ("  sletter: " + $f.FullName.Substring($YAIOS.Length).TrimStart('\')) }
  $foraeldede | Remove-Item -Force -ErrorAction SilentlyContinue
  L "Foraeldede filer paa Y:\AI OS: $($foraeldede.Count) slettet (-RyddForaeldede)"
}
else {
  foreach ($f in $foraeldede | Select-Object -First 20) { L ("  foraeldet: " + $f.FullName.Substring($YAIOS.Length).TrimStart('\')) }
  if ($foraeldede.Count -gt 20) { L ("  ... og " + ($foraeldede.Count - 20) + " mere") }
  L "Foraeldede filer paa Y:\AI OS: $($foraeldede.Count) - koer med -RyddForaeldede for at fjerne dem"
}

if ($KunAIOS) { L "UDGIV slut (kun AI OS)"; exit 0 }

# 2a) Repos der findes i OneDrive men slet ikke paa Y: klones derud fra OneDrive-klonen.
#     Origin fjernes igen, saa klonen ligner de andre lokale kloner (Udgiv henter dem fra OneDrive).
Get-ChildItem -Directory (Join-Path $OneDrive "AI SOSU") | Where-Object { Test-Path (Join-Path $_.FullName ".git\HEAD") } | ForEach-Object {
  $y = Join-Path $YAISOSU $_.Name
  if (Test-Path $y) { return }
  & git clone -q $_.FullName $y 2>&1 | Out-Null
  & git -C $y remote remove origin 2>$null
  & git -C $y config core.hooksPath .githooks
  L ("$($_.Name) : manglede paa Y: - klonet fra OneDrive (" + (& git -C $y rev-parse --short HEAD) + ")")
}

# 2) Y:\AI SOSU\<repo> <- GitHub (ff-only); kloner uden remote <- OneDrive-klonen (ff-only)
Get-ChildItem -Directory $YAISOSU | ForEach-Object {
  $d = $_.FullName; $n = $_.Name
  if (-not (Test-Path (Join-Path $d ".git\HEAD"))) { L "$n : ingen gyldig .git - springes over"; return }
  $remote = (& git -C $d remote get-url origin 2>$null)
  if (-not $remote) {
    # Uden remote er OneDrive-klonen kilden. Kun fast-forward, og kun naar Y: er ren.
    $od = Join-Path $OneDrive "AI SOSU\$n"
    $gren = (& git -C $od branch --show-current 2>$null)
    if (-not $gren) { L "$n : ingen remote og ingen OneDrive-klon - springes over"; return }
    $before = (& git -C $d rev-parse --short HEAD)
    $dirty = @(& git -C $d status --short --untracked-files=no).Count
    & git -C $d fetch -q $od $gren 2>$null
    & git -C $d merge-base --is-ancestor HEAD FETCH_HEAD
    if ($LASTEXITCODE -ne 0 -or $dirty -gt 0) { L "$n : lokal klon kan IKKE fast-forwardes (dirty=$dirty) - roeres ikke"; return }
    & git -C $d merge -q --ff-only FETCH_HEAD 2>&1 | Out-Null
    L ("$n : $before -> " + (& git -C $d rev-parse --short HEAD) + " (fra OneDrive, ingen remote)")
    return
  }
  $dirty = @(& git -C $d status --short | Where-Object { $_ -notmatch '^\?\?' }).Count
  if ($dirty -gt 0) { & git -C $d stash push -q -m ("Y-kopi: lokale aendringer foer Udgiv " + (Get-Date -Format yyyy-MM-dd)) | Out-Null; L "$n : $dirty aendrede filer stashet (git stash list i $d)" }
  $before = (& git -C $d rev-parse --short HEAD)
  $out = (& git -C $d pull -q --ff-only origin main 2>&1 | Select-Object -Last 1)
  $after = (& git -C $d rev-parse --short HEAD)
  L ("$n : $before -> $after " + $(if ($out) { "($out)" } else { "" }))
}

# 2b) Filer git ikke foelger (gitignoreret Input/Output, pbi-cache m.m.) findes kun i OneDrive-klonen
#     og naar aldrig Y: via pull. De kopieres derud, naar de mangler eller er nyere i OneDrive
#     (JST 15-09-2026: Y: og OneDrive skal vaere identiske, ogsaa for persondata). En fil som
#     Y:-klonens git FOELGER, roeres aldrig - BI-OEKONOMI staar paa en feature-gren i OneDrive,
#     mens Y: skal staa paa main.
Get-ChildItem -Directory (Join-Path $OneDrive "AI SOSU") | Where-Object { Test-Path (Join-Path $_.FullName ".git\HEAD") } | ForEach-Object {
  $od = $_.FullName; $y = Join-Path $YAISOSU $_.Name
  if (-not (Test-Path $y)) { return }
  $yTracked = @{}
  if (Test-Path (Join-Path $y ".git\HEAD")) { & git -C $y -c core.quotepath=off ls-files 2>$null | ForEach-Object { $yTracked[$_] = 1 } }
  $kopieret = 0
  & git -C $od -c core.quotepath=off ls-files --others 2>$null |
    Where-Object { $_ -notmatch '(^|/)(__pycache__|node_modules|\.claude/worktrees)/' -and $_ -notmatch '(^|/)(~\$[^/]*|desktop\.ini|Thumbs\.db)$' -and -not $yTracked[$_] } |
    ForEach-Object {
      $src = Join-Path $od $_; $dst = Join-Path $y $_
      if (-not (Test-Path -LiteralPath $src -PathType Leaf)) { return }
      $s = Get-Item -LiteralPath $src -Force
      if (Test-Path -LiteralPath $dst) {
        $t = Get-Item -LiteralPath $dst -Force
        if ($t.Length -eq $s.Length -and $t.LastWriteTimeUtc -ge $s.LastWriteTimeUtc.AddSeconds(-2)) { return }
      }
      New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
      Copy-Item -LiteralPath $src -Destination $dst -Force
      $kopieret++
    }
  if ($kopieret) { L "$($_.Name) : $kopieret filer uden for git kopieret til Y:" }
}

# 3) Filer der KUN findes paa Y: - lagt dér af JST eller en kollega, eller skrevet af en agent
#    der arbejdede direkte paa Y:. Udgiv foerer kun OneDrive -> Y:, saa uden denne rapport
#    forbliver de usynlige for arbejdskopien (set 2026-09-15: infoskaermenes PowerPoints, en
#    pbip og Codex' arbejdsmappe laa kun paa Y:). Kun "New File" taeller: "Newer" er
#    checkout-tidsstempler fra git pull og siger intet om indholdet.
$par = @(@{ Y = $YAIOS; O = (Join-Path $OneDrive "AI OS") })
Get-ChildItem -Directory $YAISOSU | ForEach-Object { $par += @{ Y = $_.FullName; O = (Join-Path $OneDrive "AI SOSU\$($_.Name)") } }
$kunY = 0
foreach ($p in $par) {
  if (-not (Test-Path $p.O)) { L ("KUN PAA Y: hele mappen " + $p.Y); $kunY++; continue }
  $nye = @(& robocopy $p.Y $p.O /E /L /XD .git __pycache__ node_modules /XF desktop.ini workspace.json /NJH /NJS /NDL /NP /FP /R:0 /W:0 |
    Where-Object { $_ -match 'New File' } | ForEach-Object { ($_ -split "`t")[-1].Trim() })
  foreach ($f in $nye | Select-Object -First 10) { L "  kun paa Y: $f" }
  if ($nye.Count -gt 10) { L ("  ... og " + ($nye.Count - 10) + " mere under " + $p.Y) }
  $kunY += $nye.Count
}
L ("Filer der kun findes paa Y: $kunY" + $(if ($kunY) { " - kopiér dem til OneDrive (se AI OS\CLAUDE.md, Placering)" } else { "" }))
L "UDGIV slut"
# robocopy returnerer 1 for "filer kopieret", og den kode slap ellers ud som scriptets exit-kode.
exit $(if ($kunY) { 2 } else { 0 })
