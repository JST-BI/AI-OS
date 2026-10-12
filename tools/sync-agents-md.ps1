#Requires -Version 5.1
<#
.SYNOPSIS
  Sikrer at AGENTS.md er den eneste instruktionsfil, og at CLAUDE.md kun er en pegefil til den.
.DESCRIPTION
  AGENTS.md er den kanoniske, modeluafhaengige instruktionsfil i AI OS, i vault\ og i hvert
  projekt under 'AI SOSU'. Codex laeser AGENTS.md direkte. Claude Code laeser CLAUDE.md, som
  derfor kun indeholder importlinjen

      @AGENTS.md

  saa begge vaerktoejer ser praecis den samme fil. Der findes ingen spejling laengere - foer
  2026-10-12 var CLAUDE.md kilden og AGENTS.md en byte-identisk kopi, og enhver rettelse skulle
  kopieres over. Nu redigeres AGENTS.md alene.

  Scriptet finder selv alle mapper der har mindst en af de to filer (AI OS-roden, undermapper i
  AI OS som vault\, og hver projektmappe) - listen er ikke hardkodet, saa nye projekter kommer
  automatisk med. Uden -Check skrives pegefilen hvor den mangler eller afviger; en CLAUDE.md der
  rummer fuld tekst uden AGENTS.md ved siden af roeres IKKE (kilden er uklar - ret manuelt).
.PARAMETER Check
  Rapporter kun drift, skriv ingen filer. Exitkode 1 hvis noget afviger.
  Beregnet til CI og til session-startkontrollen.
.PARAMETER Root
  AI OS-roden. Udledes normalt af scriptets egen placering.
.PARAMETER ProjectsRoot
  Projektroden. Udledes som 'AI SOSU' ved siden af AI OS (arbejdskopien under OneDrive);
  falder tilbage paa Y:\AI SOSU hvis den mappe ikke findes.
.EXAMPLE
  & "AI OS\tools\sync-agents-md.ps1" -Check
.EXAMPLE
  & "AI OS\tools\sync-agents-md.ps1"
.NOTES
  Haandhaeves ogsaa ved commit af .githooks/check_md_mirror.py.
#>
param(
  [switch]$Check,
  [string]$Root,
  [string]$ProjectsRoot
)
$ErrorActionPreference = 'Stop'

# Pegefilens praecise indhold. Claude Code laeser "@sti" paa egen linje som import af filen,
# relativt til CLAUDE.md's egen mappe. Ingen BOM, LF, en afsluttende linjeskift.
$PEGEFIL = "@AGENTS.md`n"

# AI OS-roden = foraelder til dette scripts tools\-mappe
$aiOsRoot = Split-Path -Parent $PSScriptRoot
if (-not $Root) { $Root = $aiOsRoot }
if (-not $ProjectsRoot) {
  # ARBEJDSKOPIEN ligger ved siden af AI OS (under OneDrive). Y:\AI SOSU er KOLLEGERNES delte
  # kopi og maa ikke vaere standard (fundet 02-09-2026, da kontrollen kontrollerede et foraeldet
  # Y:-snapshot i stedet for de filer der faktisk redigeres). Y: beholdes som fallback.
  $kandidat = Join-Path (Split-Path -Parent $aiOsRoot) 'AI SOSU'
  $ProjectsRoot = if (Test-Path -LiteralPath $kandidat -PathType Container) { $kandidat } else { 'Y:\AI SOSU' }
}
if (-not (Test-Path -LiteralPath $ProjectsRoot -PathType Container)) {
  throw "Den kanoniske projektrod mangler: $ProjectsRoot"
}

$harPar = {
  param($sti)
  (Test-Path (Join-Path $sti 'CLAUDE.md')) -or (Test-Path (Join-Path $sti 'AGENTS.md'))
}
$dirs = @($aiOsRoot)
$dirs += Get-ChildItem -LiteralPath $aiOsRoot -Directory |
  Where-Object { $_.Name -notmatch '^\.' -and (& $harPar $_.FullName) } |
  Select-Object -ExpandProperty FullName
$dirs += Get-ChildItem -LiteralPath $ProjectsRoot -Directory |
  Where-Object { & $harPar $_.FullName } |
  Select-Object -ExpandProperty FullName

function Er-Pegefil([string]$sti) {
  if (-not (Test-Path -LiteralPath $sti)) { return $false }
  $bytes = [System.IO.File]::ReadAllBytes($sti)
  $tekst = [System.Text.Encoding]::UTF8.GetString($bytes).TrimStart([char]0xFEFF)
  # Tolerant over for CRLF og manglende afsluttende linjeskift - men intet andet indhold.
  return ($tekst -replace "`r`n", "`n").Trim() -eq '@AGENTS.md'
}

$drift = @()
$skrevet = 0
$ok = 0
$utf8 = New-Object System.Text.UTF8Encoding($false)

foreach ($d in $dirs) {
  $claude = Join-Path $d 'CLAUDE.md'
  $agents = Join-Path $d 'AGENTS.md'
  $name = if ($d -eq $aiOsRoot) { 'AI OS' }
          elseif ($d.StartsWith($aiOsRoot, [System.StringComparison]::OrdinalIgnoreCase)) { "AI OS\$(Split-Path -Leaf $d)" }
          else { "AI SOSU\$(Split-Path -Leaf $d)" }

  if (-not (Test-Path -LiteralPath $agents)) {
    $drift += "$name : AGENTS.md mangler (kun CLAUDE.md findes) - ret manuelt: flyt teksten til AGENTS.md og goer CLAUDE.md til pegefil"
    continue
  }
  if (Er-Pegefil $claude) {
    $ok++
    if (-not $Check) { Write-Host "  OK       $name" }
    continue
  }
  if ($Check) {
    $why = if (Test-Path -LiteralPath $claude) { 'CLAUDE.md er ikke pegefilen @AGENTS.md' } else { 'CLAUDE.md (pegefil) mangler' }
    $drift += "$name : $why"
    continue
  }
  [System.IO.File]::WriteAllText($claude, $PEGEFIL, $utf8)
  $skrevet++
  Write-Host "  PEGEFIL  $name"
}

if ($Check) {
  if ($drift.Count -gt 0) {
    Write-Host ''
    Write-Host 'INSTRUKTIONSFIL-DRIFT - CLAUDE.md skal kun vaere pegefilen @AGENTS.md:' -ForegroundColor Red
    $drift | ForEach-Object { Write-Host "   - $_" -ForegroundColor Red }
    Write-Host ''
    Write-Host 'Ret med:  & "AI OS\tools\sync-agents-md.ps1"   (skriver pegefilerne; roerer aldrig AGENTS.md)'
    exit 1
  }
  Write-Host "OK: AGENTS.md er instruktionsfilen og CLAUDE.md er pegefil i alle $ok mapper."
  exit 0
}

Write-Host ''
Write-Host "Faerdig: $skrevet pegefil(er) skrevet, $ok var allerede i orden ($($dirs.Count) mapper)."
if ($drift.Count -gt 0) { $drift | ForEach-Object { Write-Host "  MANUELT: $_" -ForegroundColor Yellow } }
if ($skrevet -gt 0) {
  Write-Host 'Husk at committe de skrevne CLAUDE.md-pegefiler i de beroerte repos.'
}
