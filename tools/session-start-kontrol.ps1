#Requires -Version 5.1
<#
.SYNOPSIS
  Deterministisk session-startkontrol for AI OS. Tavs naar alt er i orden.

.DESCRIPTION
  Erstatter den prosa-tjekliste der stod i CLAUDE.md, og som modellen skulle "verificere" ved
  hver foerste prompt. En tjekliste af den slags koster kontekst i hver session og er kun saa
  paalidelig som modellens lyst til at koere den. Maskinen goer det samme paa under et sekund
  og kan ikke springe et punkt over.

  Skriver INTET ved succes (exit 0). Ved fejl skrives kun de punkter der fejler, og exitkoden
  er 1 - Claude Code viser teksten som kontekst ved sessionens start.

  Installeret som SessionStart-hook i .claude/settings.json.

  ENCODING: filen SKAL gemmes som UTF-8 MED BOM. Windows PowerShell 5.1 laeser en .ps1 uden BOM
  som ANSI, saa aeoeaa i strenge bliver til mojibake - det ramte foerste udgave af dette script,
  hvor hardkodede projektnavne som ADM-OEKONOMI aldrig kunne matche mappen paa disk. Scriptet
  hardkoder derfor ingen projektnavne mere: det opregner de mapper der faktisk findes.

.PARAMETER Fuld
  Kontrollér ogsaa hvert projekt-repos faste filer. Uden flaget koeres kun spejl- og
  rodkontrollen - det hurtige, der faktisk driver.
#>
param([switch]$Fuld)

$ErrorActionPreference = 'Stop'
$AIOS = Split-Path -Parent $PSScriptRoot
$SOSU = Join-Path (Split-Path -Parent $AIOS) 'AI SOSU'
$fejl = New-Object System.Collections.Generic.List[string]

# 1) CLAUDE.md == AGENTS.md i alle mapper der har mindst en af dem
$sync = Join-Path $AIOS 'tools\sync-agents-md.ps1'
# *>&1 - ikke 2>&1: sync-scriptet skriver med Write-Host, og den gaar til informations-
# stroemmen. Fanges den ikke, skriver hooken sync-scriptets "OK"-linje ved HVER sessionsstart,
# og kontrollen er dermed ikke laengere tavs naar alt er i orden.
$ud = & $sync -Check *>&1
if ($LASTEXITCODE -ne 0) {
  $linjer = @($ud | Where-Object { "$_" -match '\S' } | ForEach-Object { "$_".Trim() })
  $fejl.Add("Spejl-drift mellem CLAUDE.md og AGENTS.md: $($linjer -join ' | ')")
}

# 2) AI OS-roden indeholder kun infrastruktur - ingen loese noter, ingen projektmapper
$tilladt = @('agents','agents-inaktive','tools','vault','.githooks','.claude','.agents','.codex',
             '.codex-tmp','.obsidian','.vscode','.git','CLAUDE.md','AGENTS.md','INDEX.md',
             '.gitattributes','.gitignore')
$fremmede = @(Get-ChildItem -LiteralPath $AIOS -Force | Where-Object { $tilladt -notcontains $_.Name })
if ($fremmede.Count -gt 0) {
  $fejl.Add("AI OS-roden indeholder fremmede elementer: $(($fremmede.Name) -join ', ') - loese .md hoerer i vault\")
}

# 3) INDEX.md findes
if (-not (Test-Path -LiteralPath (Join-Path $AIOS 'INDEX.md'))) { $fejl.Add('INDEX.md mangler i AI OS-roden') }

# 4) Projektroden findes (arbejdskopien, ikke Y:)
if (-not (Test-Path -LiteralPath $SOSU)) {
  $fejl.Add("Projektroden findes ikke: $SOSU")
}
elseif ($Fuld) {
  # 5) Hvert repo under projektroden har de faste filer. Ingen navne hardkodes -
  #    et nyt projekt er automatisk daekket, og danske mappenavne kan ikke mismatche.
  #    Kravet er et GYLDIGT repo: BI-SOSU har en .git der kun rummer en 'gk'-mappe - ingen
  #    HEAD, ingen objects - og er ikke et projekt. "Mappen har .git" alene ville melde fire
  #    falske fejl i hver session. Testen er filbaseret, saa den koster ingen subprocesser.
  $repos = @(Get-ChildItem -LiteralPath $SOSU -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName '.git\HEAD')
  })
  if ($repos.Count -eq 0) { $fejl.Add("Ingen gyldige git-repos fundet under $SOSU") }
  foreach ($r in $repos) {
    foreach ($f in @('CLAUDE.md', 'AGENTS.md', '.githooks', '.codex')) {
      if (-not (Test-Path -LiteralPath (Join-Path $r.FullName $f))) {
        $fejl.Add("$($r.Name): mangler $f")
      }
    }
  }
}

if ($fejl.Count -eq 0) { exit 0 }
Write-Output "SESSION-STARTKONTROL FEJLEDE - ret dette foer du arbejder videre:"
foreach ($f in $fejl) { Write-Output "  - $f" }
exit 1
