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
