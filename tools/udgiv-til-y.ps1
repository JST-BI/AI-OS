<#
.SYNOPSIS
  "Udgiv": ajourfoer kollegernes delte kopier paa Y: fra JSTs arbejdskopier (OneDrive) og GitHub.
.DESCRIPTION
  1) Y:\AI OS  <- filkopi af <OneDrive>\AI OS (robocopy /E /XO: kun nyere filer, intet slettes).
     Udelader .git, .claude\worktrees, .codex-tmp, .obsidian\workspace.json, node_modules og alt personligt.
  2) Y:\AI SOSU\<repo> <- git pull --ff-only origin main i hver klon med remote. Lokale aendringer paa Y:
     stashes foerst (rapporteres), saa intet overskrives i blinde. Kloner uden remote springes over.
  Y:-kopierne er kollegernes arbejdsgrundlag: DATAKONTROLCENTER paa Y: og Z8050 m.fl. paa Y: roeres IKKE.
  Koeres af agenten paa kodeordet "Udgiv" (se AI OS\CLAUDE.md) eller manuelt.
.EXAMPLE
  & "<OneDrive>\AI OS\tools\udgiv-til-y.ps1"
  & "<OneDrive>\AI OS\tools\udgiv-til-y.ps1" -KunAIOS
#>
param(
  [string]$OneDrive = "C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers",
  [string]$YAIOS = "Y:\AI OS",
  [string]$YAISOSU = "Y:\AI SOSU",
  [switch]$KunAIOS,
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

if ($KunAIOS) { L "UDGIV slut (kun AI OS)"; exit 0 }

# 2) Y:\AI SOSU\<repo> <- GitHub (ff-only)
Get-ChildItem -Directory $YAISOSU | ForEach-Object {
  $d = $_.FullName; $n = $_.Name
  if (-not (Test-Path (Join-Path $d ".git"))) { L "$n : ingen .git - springes over"; return }
  $remote = (& git -C $d remote get-url origin 2>$null)
  if (-not $remote) { L "$n : ingen remote (lokal klon) - springes over"; return }
  $dirty = @(& git -C $d status --short | Where-Object { $_ -notmatch '^\?\?' }).Count
  if ($dirty -gt 0) { & git -C $d stash push -q -m ("Y-kopi: lokale aendringer foer Udgiv " + (Get-Date -Format yyyy-MM-dd)) | Out-Null; L "$n : $dirty aendrede filer stashet (git stash list i $d)" }
  $before = (& git -C $d rev-parse --short HEAD)
  $out = (& git -C $d pull -q --ff-only origin main 2>&1 | Select-Object -Last 1)
  $after = (& git -C $d rev-parse --short HEAD)
  L ("$n : $before -> $after " + $(if ($out) { "($out)" } else { "" }))
}
L "UDGIV slut"
