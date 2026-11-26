#Requires -Version 5.1
<#
.SYNOPSIS
  Sikrer at .agents\skills\ er den eneste kilde til skills, og at .claude\skills\ kun er et genereret spejl.
.DESCRIPTION
  Samme princip som AGENTS.md (een neutral kilde): reglerne maa aldrig afhaenge af AI-model (JST 2026-10-12).
  Codex laeser skills i .agents\skills\, Claude Code i .claude\skills\. Claude Code har ingen
  import-mekanisme for skills, og symlinks/junctions afvises af filserveren og overlever ikke Udgiv
  - derfor er .claude\skills\ en byte-identisk kopi, der KUN skrives af dette script.

  Rediger altid i .agents\skills\<navn>\. Uden -Check spejles hele kilden til .claude\skills\:
  manglende og afvigende filer skrives, og filer/mapper i spejlet uden modpart i kilden slettes.
  En skill der KUN findes i .claude\skills\ roeres ikke (kilden er uklar - flyt den til .agents\skills\).

  Brugerspejl (JST 26-11-2026, "Loesning 2"): skills i .claude\skills\ indlaeses kun i sessioner startet i
  AI OS, saa /aflever, /pause, /udgiv m.fl. manglede i sessioner startet i C:\Users\jst eller et AI SOSU-projekt.
  Derfor spejles hver skill ogsaa til ~\.claude\skills\<navn>\ (brugerniveau - laeses i alle sessioner).
  Scriptet roerer KUN de mapper, det selv har lagt der (listen i ~\.claude\skills\.ai-os-skills); en
  eksisterende mappe med samme navn, som det ikke styrer (fx en personlig skill eller en junction), springes
  over med en advarsel. En skill der fjernes fra kilden, fjernes ogsaa fra brugerspejlet.
.PARAMETER Check
  Rapporter kun drift, skriv ingen filer. Exitkode 1 hvis noget afviger (session-startkontrollen).
.PARAMETER Root
  Repo-roden (AI OS). Udledes af scriptets egen placering.
.PARAMETER BrugerSkills
  Brugerspejlets rod (standard ~\.claude\skills). Bruges af testen.
.PARAMETER UdenBruger
  Spring brugerspejlet over (kun repo-spejlet .claude\skills\).
.EXAMPLE
  & "AI OS\tools\sync-skills.ps1" -Check
.NOTES
  Haandhaeves ogsaa ved commit af .githooks/check_skills_mirror.py.
#>
param(
  [switch]$Check,
  [string]$Root,
  [string]$BrugerSkills = (Join-Path $env:USERPROFILE '.claude\skills'),
  [switch]$UdenBruger
)
$ErrorActionPreference = 'Stop'
if (-not $Root) { $Root = Split-Path -Parent $PSScriptRoot }
$kilde = Join-Path $Root '.agents\skills'
$spejl = Join-Path $Root '.claude\skills'
if (-not (Test-Path -LiteralPath $kilde -PathType Container)) { throw "Kilden mangler: $kilde" }

function Rel([string]$base, [string]$sti) { $sti.Substring($base.Length).TrimStart('\') }
function Filer([string]$base) {
  if (-not (Test-Path -LiteralPath $base)) { return @{} }
  $h = @{}
  Get-ChildItem -LiteralPath $base -Recurse -File -Force | ForEach-Object { $h[(Rel $base $_.FullName)] = $_.FullName }
  $h
}
$K = Filer $kilde
$S = Filer $spejl
$kildeSkills = @(Get-ChildItem -LiteralPath $kilde -Directory | Select-Object -ExpandProperty Name)

$drift = @(); $skrevet = 0; $slettet = 0
# Skills der kun findes i spejlet: kilden er uklar - aldrig slet automatisk
$kunSpejl = @()
if (Test-Path -LiteralPath $spejl) {
  # En mappe uden filer er ingen skill (git kan ikke spore den; OneDrive efterlader dem) - ignoreres
  $kunSpejl = @(Get-ChildItem -LiteralPath $spejl -Directory | Where-Object {
      $kildeSkills -notcontains $_.Name -and @(Get-ChildItem -LiteralPath $_.FullName -Recurse -File -Force).Count -gt 0
    } | Select-Object -ExpandProperty Name)
}
foreach ($n in $kunSpejl) { $drift += ".claude\skills\$n findes ikke i .agents\skills\ - flyt den dertil (kilden), og koer scriptet igen" }

foreach ($r in $K.Keys) {
  $maal = Join-Path $spejl $r
  $ens = $S.ContainsKey($r) -and ((Get-FileHash -LiteralPath $K[$r]).Hash -eq (Get-FileHash -LiteralPath $S[$r]).Hash)
  if ($ens) { continue }
  if ($Check) { $drift += ".claude\skills\$r " + $(if ($S.ContainsKey($r)) { 'afviger fra kilden' } else { 'mangler i spejlet' }); continue }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $maal) | Out-Null
  Copy-Item -LiteralPath $K[$r] -Destination $maal -Force
  $skrevet++; Write-Host "  SKREVET  .claude\skills\$r"
}
foreach ($r in $S.Keys) {
  $skill = ($r -split '\\')[0]
  if ($K.ContainsKey($r) -or $kunSpejl -contains $skill) { continue }
  if ($Check) { $drift += ".claude\skills\$r har ingen modpart i kilden"; continue }
  Remove-Item -LiteralPath $S[$r] -Force
  $slettet++; Write-Host "  SLETTET  .claude\skills\$r"
}

# --- Brugerspejl: ~\.claude\skills\<navn>\ for hver skill i kilden (kun mapper scriptet selv styrer) ---
$bSkrevet = 0; $bSlettet = 0; $bSprunget = @()
if (-not $UdenBruger) {
  $liste = Join-Path $BrugerSkills '.ai-os-skills'
  $styret = @()
  if (Test-Path -LiteralPath $liste) { $styret = @(Get-Content -LiteralPath $liste | Where-Object { $_ -match '\S' } | ForEach-Object { $_.Trim() }) }
  $nyListe = @()
  foreach ($n in $kildeSkills) {
    $bMappe = Join-Path $BrugerSkills $n
    $findes = Test-Path -LiteralPath $bMappe
    $link = $findes -and (@('Junction', 'SymbolicLink') -contains (Get-Item -LiteralPath $bMappe -Force).LinkType)
    if ($findes -and ($link -or $styret -notcontains $n)) {
      # Ikke vores: en personlig skill eller et link med samme navn - roeres aldrig
      $bSprunget += $n
      $drift += "~\.claude\skills\$n findes allerede og styres ikke af AI OS - springes over (flyt/omdoeb den, hvis AI OS' udgave skal bruges)"
      continue
    }
    $nyListe += $n
    $KB = Filer (Join-Path $kilde $n)
    $BB = Filer $bMappe
    foreach ($r in $KB.Keys) {
      $maal = Join-Path $bMappe $r
      if ($BB.ContainsKey($r) -and (Get-FileHash -LiteralPath $KB[$r]).Hash -eq (Get-FileHash -LiteralPath $BB[$r]).Hash) { continue }
      if ($Check) { $drift += "~\.claude\skills\$n\$r " + $(if ($BB.ContainsKey($r)) { 'afviger fra kilden' } else { 'mangler i brugerspejlet' }); continue }
      New-Item -ItemType Directory -Force -Path (Split-Path -Parent $maal) | Out-Null
      Copy-Item -LiteralPath $KB[$r] -Destination $maal -Force
      $bSkrevet++; Write-Host "  SKREVET  ~\.claude\skills\$n\$r"
    }
    foreach ($r in $BB.Keys) {
      if ($KB.ContainsKey($r)) { continue }
      if ($Check) { $drift += "~\.claude\skills\$n\$r har ingen modpart i kilden"; continue }
      Remove-Item -LiteralPath $BB[$r] -Force
      $bSlettet++; Write-Host "  SLETTET  ~\.claude\skills\$n\$r"
    }
  }
  # Skills fjernet fra kilden: deres styrede mappe i brugerspejlet fjernes
  foreach ($n in $styret) {
    if ($kildeSkills -contains $n) { continue }
    $bMappe = Join-Path $BrugerSkills $n
    if (-not (Test-Path -LiteralPath $bMappe)) { continue }
    if ($Check) { $drift += "~\.claude\skills\$n er fjernet fra kilden, men ligger stadig i brugerspejlet"; continue }
    Remove-Item -LiteralPath $bMappe -Recurse -Force
    $bSlettet++; Write-Host "  SLETTET  ~\.claude\skills\$n (fjernet fra kilden)"
  }
  if (-not $Check) {
    $gammel = ($styret | Sort-Object) -join "`n"; $ny = ($nyListe | Sort-Object) -join "`n"
    if ($gammel -ne $ny -or -not (Test-Path -LiteralPath $liste)) {
      New-Item -ItemType Directory -Force -Path $BrugerSkills | Out-Null
      [IO.File]::WriteAllText($liste, (($nyListe | Sort-Object) -join "`r`n") + "`r`n", (New-Object Text.UTF8Encoding $false))
    }
  } elseif (Compare-Object @($styret | Sort-Object) @($nyListe | Sort-Object)) {
    $drift += "~\.claude\skills\.ai-os-skills (listen over styrede skills) er ikke ajour"
  }
}

if ($Check) {
  if ($drift.Count -gt 0) {
    Write-Host 'SKILL-DRIFT - .claude\skills\ og ~\.claude\skills\ skal vaere spejle af .agents\skills\:' -ForegroundColor Red
    $drift | ForEach-Object { Write-Host "   - $_" -ForegroundColor Red }
    Write-Host 'Ret med:  & "AI OS\tools\sync-skills.ps1"   (rediger altid i .agents\skills\)'
    exit 1
  }
  Write-Host ("OK: .claude\skills\ er et spejl af .agents\skills\ ($($kildeSkills.Count) skills)" + $(if ($UdenBruger) { '.' } else { ', og ~\.claude\skills\ har dem paa brugerniveau.' }))
  exit 0
}
Write-Host "Faerdig: $skrevet fil(er) skrevet, $slettet slettet ($($kildeSkills.Count) skills)."
if (-not $UdenBruger) { Write-Host "Brugerspejl (~\.claude\skills): $bSkrevet fil(er) skrevet, $bSlettet slettet, $($bSprunget.Count) sprunget over." }
$drift | ForEach-Object { Write-Host "  MANUELT: $_" -ForegroundColor Yellow }
if ($skrevet + $slettet -gt 0) { Write-Host 'Husk at committe .claude\skills\ sammen med kilden.' }
