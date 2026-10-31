#Requires -Version 5.1
<#
.SYNOPSIS
  Sikrer at .agents\skills\ er den eneste kilde til skills, og at .claude\skills\ kun er et genereret spejl.
.DESCRIPTION
  Samme princip som AGENTS.md/CLAUDE.md: reglerne maa aldrig afhaenge af AI-model (JST 2026-10-12).
  Codex laeser skills i .agents\skills\, Claude Code i .claude\skills\. Claude Code har ingen
  import-mekanisme for skills, og symlinks/junctions afvises af filserveren og overlever ikke Udgiv
  - derfor er .claude\skills\ en byte-identisk kopi, der KUN skrives af dette script.

  Rediger altid i .agents\skills\<navn>\. Uden -Check spejles hele kilden til .claude\skills\:
  manglende og afvigende filer skrives, og filer/mapper i spejlet uden modpart i kilden slettes.
  En skill der KUN findes i .claude\skills\ roeres ikke (kilden er uklar - flyt den til .agents\skills\).
.PARAMETER Check
  Rapporter kun drift, skriv ingen filer. Exitkode 1 hvis noget afviger (session-startkontrollen).
.PARAMETER Root
  Repo-roden (AI OS). Udledes af scriptets egen placering.
.EXAMPLE
  & "AI OS\tools\sync-skills.ps1" -Check
.NOTES
  Haandhaeves ogsaa ved commit af .githooks/check_skills_mirror.py.
#>
param(
  [switch]$Check,
  [string]$Root
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

if ($Check) {
  if ($drift.Count -gt 0) {
    Write-Host 'SKILL-DRIFT - .claude\skills\ skal vaere et spejl af .agents\skills\:' -ForegroundColor Red
    $drift | ForEach-Object { Write-Host "   - $_" -ForegroundColor Red }
    Write-Host 'Ret med:  & "AI OS\tools\sync-skills.ps1"   (rediger altid i .agents\skills\)'
    exit 1
  }
  Write-Host "OK: .claude\skills\ er et spejl af .agents\skills\ ($($kildeSkills.Count) skills)."
  exit 0
}
Write-Host "Faerdig: $skrevet fil(er) skrevet, $slettet slettet ($($kildeSkills.Count) skills)."
$drift | ForEach-Object { Write-Host "  MANUELT: $_" -ForegroundColor Yellow }
if ($skrevet + $slettet -gt 0) { Write-Host 'Husk at committe .claude\skills\ sammen med kilden.' }
