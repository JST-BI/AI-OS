#Requires -Version 5.1
<#
.SYNOPSIS
  Sikrer at AGENTS.md er den eneste instruktionsfil - ingen CLAUDE.md-varianter nogen steder.
.DESCRIPTION
  AGENTS.md er den kanoniske, modeluafhaengige instruktionsfil i AI OS, i vault\ og i hvert
  projekt under 'AI SOSU'. Codex og Claude Code (>= v2.1.277) laeser den direkte.

  En CLAUDE.md, CLAUDE.local.md eller .claude\CLAUDE.md i en mappe ELLER OVER DEN faar Claude Code
  til at springe AGENTS.md over - den slukker altsaa stille for reglerne. Indtil 2026-11-01 var
  CLAUDE.md en pegefil med "@AGENTS.md" (fra foer Claude Code laeste AGENTS.md selv); den er
  fjernet, og dette script holder det saadan.

  Scriptet finder selv alle mapper med AGENTS.md eller en CLAUDE-variant (AI OS-roden, undermapper
  i AI OS som vault\, og hver projektmappe) og kontrollerer desuden de overliggende mapper
  (projektroden og dens foraelder). Uden -Check slettes varianter, der praecis er den gamle
  pegefil; en variant med anden tekst roeres IKKE (flyt teksten til AGENTS.md og slet den manuelt).
.PARAMETER Check
  Rapporter kun drift, skriv/slet intet. Exitkode 1 hvis noget afviger.
  Beregnet til session-startkontrollen.
.PARAMETER Root
  AI OS-roden. Udledes normalt af scriptets egen placering.
.PARAMETER ProjectsRoot
  Projektroden. Udledes som 'AI SOSU' ved siden af AI OS (arbejdskopien under OneDrive);
  falder tilbage paa Y:\AI SOSU hvis den mappe ikke findes.
.EXAMPLE
  & "AI OS\tools\sync-agents-md.ps1" -Check
.NOTES
  Haandhaeves ogsaa ved commit af .githooks/check_kun_agents_md.py. Kilden er kun ASCII.
#>
param(
  [switch]$Check,
  [string]$Root,
  [string]$ProjectsRoot
)
$ErrorActionPreference = 'Stop'

$VARIANTER = @('CLAUDE.md', 'CLAUDE.local.md', '.claude\CLAUDE.md')

# AI OS-roden = foraelder til dette scripts tools\-mappe
if (-not $Root) { $Root = Split-Path -Parent $PSScriptRoot }
if (-not $ProjectsRoot) {
  # ARBEJDSKOPIEN ligger ved siden af AI OS (under OneDrive). Y:\AI SOSU er KOLLEGERNES delte
  # kopi og maa ikke vaere standard (fundet 02-09-2026). Y: beholdes som fallback.
  $kandidat = Join-Path (Split-Path -Parent $Root) 'AI SOSU'
  $ProjectsRoot = if (Test-Path -LiteralPath $kandidat -PathType Container) { $kandidat } else { 'Y:\AI SOSU' }
}
if (-not (Test-Path -LiteralPath $ProjectsRoot -PathType Container)) {
  throw "Den kanoniske projektrod mangler: $ProjectsRoot"
}

function Varianter([string]$dir) {
  @($VARIANTER | ForEach-Object { Join-Path $dir $_ } | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf })
}
function Er-Pegefil([string]$sti) {
  $tekst = [System.Text.Encoding]::UTF8.GetString([System.IO.File]::ReadAllBytes($sti)).TrimStart([char]0xFEFF)
  # Tolerant over for CRLF og manglende afsluttende linjeskift - men intet andet indhold.
  ($tekst -replace "`r`n", "`n").Trim() -eq '@AGENTS.md'
}
$relevant = { param($sti) (Test-Path -LiteralPath (Join-Path $sti 'AGENTS.md')) -or ((Varianter $sti).Count -gt 0) }

$dirs = @($Root)
$dirs += Get-ChildItem -LiteralPath $Root -Directory |
  Where-Object { $_.Name -notmatch '^\.' -and (& $relevant $_.FullName) } |
  Select-Object -ExpandProperty FullName
$dirs += Get-ChildItem -LiteralPath $ProjectsRoot -Directory |
  Where-Object { & $relevant $_.FullName } |
  Select-Object -ExpandProperty FullName

$drift = @(); $slettet = 0; $ok = 0

# Overliggende mapper: en variant her slukker AGENTS.md i alle mapper under den. Roeres aldrig.
foreach ($over in @($ProjectsRoot, (Split-Path -Parent $ProjectsRoot)) | Select-Object -Unique) {
  foreach ($v in Varianter $over) { $drift += "$v : ligger OVER projekterne og slukker AGENTS.md i dem alle - fjern den manuelt" }
}

foreach ($d in $dirs) {
  $name = if ($d -eq $Root) { 'AI OS' }
          elseif ($d.StartsWith($Root, [System.StringComparison]::OrdinalIgnoreCase)) { "AI OS\$(Split-Path -Leaf $d)" }
          else { "AI SOSU\$(Split-Path -Leaf $d)" }
  $v = Varianter $d
  if (-not (Test-Path -LiteralPath (Join-Path $d 'AGENTS.md'))) {
    $drift += "$name : AGENTS.md mangler - flyt instruktionerne til AGENTS.md"
  }
  if ($v.Count -eq 0) { $ok++; continue }
  foreach ($f in $v) {
    $rel = $f.Substring($d.Length + 1)
    if (-not (Er-Pegefil $f)) {
      $drift += "$name\$rel : rummer tekst - flyt den til AGENTS.md og slet filen manuelt"
      continue
    }
    if ($Check) { $drift += "$name\$rel : gammel pegefil - slet den (koer scriptet uden -Check)"; continue }
    Remove-Item -LiteralPath $f -Force
    $slettet++
    Write-Host "  SLETTET  $name\$rel"
  }
}

if ($Check) {
  if ($drift.Count -gt 0) {
    Write-Host ''
    Write-Host 'INSTRUKTIONSFIL-DRIFT - AGENTS.md skal vaere eneste instruktionsfil (ingen CLAUDE.md-varianter):' -ForegroundColor Red
    $drift | ForEach-Object { Write-Host "   - $_" -ForegroundColor Red }
    Write-Host ''
    Write-Host 'Ret med:  & "AI OS\tools\sync-agents-md.ps1"   (sletter kun rene pegefiler; roerer aldrig AGENTS.md)'
    exit 1
  }
  Write-Host "OK: AGENTS.md er eneste instruktionsfil i alle $ok mapper."
  exit 0
}
Write-Host "Faerdig: $slettet pegefil(er) slettet."
$drift | ForEach-Object { Write-Host "  MANUELT: $_" -ForegroundColor Yellow }
if ($slettet -gt 0) { Write-Host 'Husk at committe sletningerne i de beroerte repos.' }
