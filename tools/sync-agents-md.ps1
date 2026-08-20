#Requires -Version 5.1
<#
.SYNOPSIS
  Spejler CLAUDE.md til AGENTS.md i AI OS og alle projekter under AI-SOSU.
.DESCRIPTION
  Claude Code laeser CLAUDE.md. Codex laeser AGENTS.md. De to filer er samme
  indhold under to navne, saa begge vaerktoejer ser praecis de samme regler.

  Scriptet finder selv alle mapper der har mindst en af de to filer (AI OS-roden
  plus hver projektmappe under AI-SOSU) - listen er ikke hardkodet, saa nye
  projekter kommer automatisk med.

  CLAUDE.md er kilden. AGENTS.md skrives som en byte-identisk kopi.
.PARAMETER Check
  Rapporter kun drift, skriv ingen filer. Exitkode 1 hvis noget afviger.
  Beregnet til CI og til session-startkontrollen.
.PARAMETER Root
  Roden der indeholder baade "AI OS" og "AI-SOSU". Udledes normalt af scriptets
  egen placering.
.EXAMPLE
  & "AI OS\tools\sync-agents-md.ps1" -Check
.EXAMPLE
  & "AI OS\tools\sync-agents-md.ps1"
.NOTES
  Haandhaeves ogsaa ved commit af .githooks/check_md_mirror.py.
#>
param(
  [switch]$Check,
  [string]$Root
)
$ErrorActionPreference = 'Stop'

# AI OS-roden = forael der til dette scripts tools\-mappe; faellesroden er dens forael der
$aiOsRoot = Split-Path -Parent $PSScriptRoot
if (-not $Root) { $Root = Split-Path -Parent $aiOsRoot }
$projectsRoot = Join-Path $Root 'AI-SOSU'

# Find alle mapper der styres: AI OS-roden + enhver projektmappe med mindst en af filerne.
# AI OS\AI-SOSU er en junction til den fysiske soestermappe - vi bruger den fysiske sti,
# saa de samme filer ikke behandles to gange.
$dirs = @($aiOsRoot)
if (Test-Path $projectsRoot) {
  $dirs += Get-ChildItem -LiteralPath $projectsRoot -Directory |
    Where-Object {
      (Test-Path (Join-Path $_.FullName 'CLAUDE.md')) -or
      (Test-Path (Join-Path $_.FullName 'AGENTS.md'))
    } | Select-Object -ExpandProperty FullName
}

$drift = @()
$synced = 0
$ok = 0

foreach ($d in $dirs) {
  $claude = Join-Path $d 'CLAUDE.md'
  $agents = Join-Path $d 'AGENTS.md'
  $name = $d.Substring($Root.Length).TrimStart('\', '/')

  if (-not (Test-Path $claude)) {
    $drift += "$name : CLAUDE.md mangler (kun AGENTS.md findes) - ret manuelt, kilden er uklar"
    continue
  }

  $same = $false
  if (Test-Path $agents) {
    $h1 = (Get-FileHash -LiteralPath $claude -Algorithm SHA256).Hash
    $h2 = (Get-FileHash -LiteralPath $agents -Algorithm SHA256).Hash
    $same = ($h1 -eq $h2)
  }

  if ($same) {
    $ok++
    if (-not $Check) { Write-Host "  OK    $name" }
  }
  elseif ($Check) {
    $why = if (Test-Path $agents) { 'AGENTS.md afviger fra CLAUDE.md' } else { 'AGENTS.md mangler' }
    $drift += "$name : $why"
  }
  else {
    Copy-Item -LiteralPath $claude -Destination $agents -Force
    $synced++
    Write-Host "  SPEJLET  $name"
  }
}

if ($Check) {
  if ($drift.Count -gt 0) {
    Write-Host ''
    Write-Host 'SPEJL BRUDT - Claude Code og Codex ser forskellige regler:' -ForegroundColor Red
    $drift | ForEach-Object { Write-Host "   - $_" -ForegroundColor Red }
    Write-Host ''
    Write-Host 'Ret med:  & "AI OS\tools\sync-agents-md.ps1"'
    exit 1
  }
  Write-Host "OK: CLAUDE.md/AGENTS.md er identiske spejle i alle $ok mapper."
  exit 0
}

Write-Host ''
Write-Host "Faerdig: $synced spejlet, $ok var allerede identiske ($($dirs.Count) mapper)."
if ($synced -gt 0) {
  Write-Host 'Husk at committe de opdaterede AGENTS.md-filer i de beroerte repos.'
}
