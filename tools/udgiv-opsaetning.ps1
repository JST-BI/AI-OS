<#
.SYNOPSIS
  "Udgiv opsaetning": samler alle skills og JSTs indstillinger (VS Code, Claude Code, Codex) i en pakke
  til kollegerne og laegger den paa Y:\AI OS\Opsaetning.
.DESCRIPTION
  1) Bygger pakken i en midlertidig mappe:
     Skills\AI-OS\<navn>            <- <OneDrive>\AI OS, .agents/skills paa main (git archive: kun det committede)
     Skills\Projekter\<repo>\<navn> <- hvert repo i <OneDrive>\AI SOSU, .agents/skills paa main
     Skills\Personlige\<kilde>\<navn> <- ~\.claude\skills, ~\.claude\skills\synced\*, ~\.agents\skills, ~\.codex\skills
     Indstillinger\VSCode|ClaudeCode|Codex
     LAESMIG.md (fra .agents\skills\udgiv-opsaetning\assets\LAESMIG-skabelon.md)
  2) Filtrerer: projekter i $IkkePaaY (laest fra udgiv-til-y.ps1) springes over; skills med en licens
     der ikke tillader videredeling ("All rights reserved"/"Proprietary") kommer ikke med; junctions
     foelges ikke; Codex' [projects.*], [mcp_servers.*], [shell_environment_policy.*] og [notice.*]
     fjernes; stier til JSTs OneDrive og profil skrives om til Y:\AI OS / Y:\AI SOSU / %USERPROFILE%.
  3) Scanner hver tekstfil i pakken for noegler/tokens, CPR-numre og e-mailadresser. Et fund STOPPER
     alt (exit 3): intet skrives til OneDrive eller Y:. Kun sti, type og antal udskrives - aldrig fundet.
  4) Spejler pakken til <OneDrive>\AI OS\Opsaetning (genereret, gitignoreret). Derfra kopieres den til
     Y:\AI OS\Opsaetning. Almindelig "Udgiv" baerer samme mappe videre, saa den hverken ses som
     "kun paa Y:" eller "foraeldet".
  Y: slettes der aldrig i, medmindre -RyddForaeldede er givet (JSTs ord, som i udgiv-til-y.ps1).
.PARAMETER Proev
  Byg og scan pakken, og vis hvad der ville aendre sig paa Y:. Skriver ikke til OneDrive eller Y:.
.PARAMETER RyddForaeldede
  Slet filer under Y:\AI OS\Opsaetning, som pakken ikke laengere har.
.EXAMPLE
  & "<OneDrive>\AI OS\tools\udgiv-opsaetning.ps1" -Proev
  & "<OneDrive>\AI OS\tools\udgiv-opsaetning.ps1"
.EXAMPLE
  $u = '\\sosurdata.net.local\Groups$\Ansatte'
  & "<OneDrive>\AI OS\tools\udgiv-opsaetning.ps1" -YAIOS "$u\AI OS"
#>
param(
  [string]$OneDrive = "C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers",
  [string]$YAIOS = "Y:\AI OS",
  [string]$Hjem = $env:USERPROFILE,
  [string]$VSCode = (Join-Path $env:APPDATA "Code\User"),
  [string]$Pakke,
  [string]$CodeCli = "code",
  [switch]$Proev,
  [switch]$RyddForaeldede,
  [string]$Log = (Join-Path $env:LOCALAPPDATA "Temp\udgiv-opsaetning.log")
)
$ErrorActionPreference = 'Continue'
$AIOS = Join-Path $OneDrive "AI OS"
# Mappen hedder "Ops<ae>tning" med ae (JST 09-11-2026). Scriptet er ren ASCII (PowerShell 5.1 laeser en fil uden
# BOM som ANSI), saa ae skrives som tegnkode. Kommentarerne staver det "Opsaetning".
$MappeNavn = "Ops" + [char]0x00E6 + "tning"
if (-not $Pakke) { $Pakke = Join-Path $AIOS $MappeNavn }
$Maerke = ".opsaetning-pakke"
function L($m) { $s = "{0:yyyy-MM-dd HH:mm:ss}  {1}" -f (Get-Date), $m; $s; $s | Out-File -Append -Encoding utf8 $Log }
function Stop($kode, $m) { L "STOP: $m"; exit $kode }
L ("UDGIV OPSAETNING start" + $(if ($Proev) { " (proeve)" } else { "" }))

# Samme liste som Udgiv - een kilde, saa et nyt fortroligt projekt ikke skal huskes to steder.
$m = Select-String -LiteralPath (Join-Path $PSScriptRoot "udgiv-til-y.ps1") -Pattern '^\$IkkePaaY\s*=\s*@\((.*)\)' | Select-Object -First 1
if (-not $m) { Stop 1 "kunne ikke laese `$IkkePaaY i udgiv-til-y.ps1" }
$IkkePaaY = @([regex]::Matches($m.Matches[0].Groups[1].Value, "'([^']+)'") | ForEach-Object { $_.Groups[1].Value })
$skabelon = Join-Path $PSScriptRoot "..\.agents\skills\udgiv-opsaetning\assets\LAESMIG-skabelon.md"
if (-not (Test-Path -LiteralPath $skabelon)) { Stop 1 "skabelonen mangler: $skabelon" }

$tmp = Join-Path $env:TEMP ("udgiv-opsaetning-" + (Get-Date -Format yyyyMMdd-HHmmss))
$ny = Join-Path $tmp "pakke"; $arb = Join-Path $tmp "arbejde"
New-Item -ItemType Directory -Force $ny, $arb | Out-Null

function Kopier-Mappe($fra, $til) {
  & robocopy $fra $til /E /XJ /R:1 /W:1 /XD .git __pycache__ node_modules *-workspace /XF *.pyc desktop.ini Thumbs.db /NFL /NDL /NJH /NJS /NP | Out-Null
  if ($LASTEXITCODE -ge 8) { Stop 1 "robocopy fejlede: $fra" }
}
# Licens: Apache/MIT og skills uden licens kommer med. "All rights reserved"/"Proprietary" (fx
# Anthropics docx/pdf/pptx/xlsx i ~\.agents\skills) maa ikke videredeles - de listes i LAESMIG.
function Er-Laast($dir) {
  $lic = Get-ChildItem -LiteralPath $dir -File -Filter 'LICENSE*' -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($lic -and ((Get-Content -LiteralPath $lic.FullName -Raw -Encoding UTF8) -match '(?i)all rights reserved|proprietary')) { return $true }
  $fm = Select-String -LiteralPath (Join-Path $dir "SKILL.md") -Pattern '^license:\s*(.*)$' -ErrorAction SilentlyContinue | Select-Object -First 1
  return [bool]($fm -and $fm.Matches[0].Groups[1].Value -match '(?i)proprietary|all rights reserved')
}
$optalt = [ordered]@{}; $laast = @(); $dubletter = @(); $udenSkill = 0
function Tilfoej-Skill($dir, $kilde) {
  if (-not (Test-Path -LiteralPath (Join-Path $dir "SKILL.md"))) { $script:udenSkill++; return }
  $navn = Split-Path $dir -Leaf
  if (Er-Laast $dir) { $script:laast += "$kilde\$navn"; return }
  $dst = Join-Path $ny "Skills\$kilde\$navn"
  if (Test-Path -LiteralPath $dst) { $script:dubletter += "$kilde\$navn"; return }
  Kopier-Mappe $dir $dst
  $optalt[$kilde] = 1 + [int]$optalt[$kilde]
}
# Kun det committede paa main - ucommittet arbejde og worktrees kommer aldrig ud til kollegerne.
function Git-Skills($repo, $kilde) {
  $sha = (& git -C $repo rev-parse --short main 2>$null)
  if (-not $sha) { return $null }
  if (-not (& git -C $repo -c core.quotepath=off ls-tree --name-only main .agents/skills/ 2>$null)) { return $null }
  $id = [guid]::NewGuid().ToString('N')
  $zip = Join-Path $arb "$id.zip"; $ud = Join-Path $arb $id
  & git -C $repo archive --format=zip -o $zip main .agents/skills
  if ($LASTEXITCODE -ne 0) { Stop 1 "git archive fejlede: $repo" }
  Expand-Archive -LiteralPath $zip -DestinationPath $ud
  Get-ChildItem -LiteralPath (Join-Path $ud ".agents\skills") -Directory | ForEach-Object { Tilfoej-Skill $_.FullName $kilde }
  return $sha
}

# 1a) Skills fra git
$aiosSha = Git-Skills $AIOS "AI-OS"
if (-not $aiosSha) { Stop 1 "ingen .agents/skills paa main i $AIOS" }
$projSha = @()
Get-ChildItem -Directory (Join-Path $OneDrive "AI SOSU") | Where-Object { Test-Path (Join-Path $_.FullName ".git\HEAD") } | ForEach-Object {
  if ($IkkePaaY -contains $_.Name) { L "$($_.Name) : springes over (`$IkkePaaY)"; return }
  $s = Git-Skills $_.FullName ("Projekter\" + $_.Name)
  if ($s) { $projSha += "$($_.Name) $s" }
}

# 1b) Personlige skills. Mapper der starter med "." (Codex' .system m.fl.) og junctions springes over;
#     de synkroniserede claude.ai-skills ligger under en mappe opkaldt efter konto-id'er - den flades ud.
$personlige = @(
  @{ Kilde = "Personlige\claude";    Rod = (Join-Path $Hjem ".claude\skills") },
  @{ Kilde = "Personlige\agents";    Rod = (Join-Path $Hjem ".agents\skills") },
  @{ Kilde = "Personlige\codex";     Rod = (Join-Path $Hjem ".codex\skills") }
)
Get-ChildItem -LiteralPath (Join-Path $Hjem ".claude\skills\synced") -Directory -ErrorAction SilentlyContinue | ForEach-Object {
  $personlige += @{ Kilde = "Personlige\claude-ai"; Rod = $_.FullName }
}
foreach ($p in $personlige) {
  if (-not (Test-Path -LiteralPath $p.Rod)) { continue }
  Get-ChildItem -LiteralPath $p.Rod -Directory -Force | Where-Object { -not $_.LinkType -and $_.Name -notmatch '^\.' -and $_.Name -ne 'synced' } |
    ForEach-Object { Tilfoej-Skill $_.FullName $p.Kilde }
}

# 2) Indstillinger. Kollegerne har ingen adgang til JSTs OneDrive: dens AI OS/AI SOSU svarer til Y:.
$omskrevet = 0
function Omskriv-Stier([string]$t) {
  $par = @(
    @((Join-Path $OneDrive "AI OS"), "Y:\AI OS"),
    @((Join-Path $OneDrive "AI SOSU"), "Y:\AI SOSU"),
    @($Hjem, "%USERPROFILE%"))
  foreach ($p in $par) {
    # Laengste foerst: en tilladelsesregel i settings.json kan vaere escapet to gange (\\\\).
    foreach ($sep in @('\\\\', '\\', '\', '/')) {
      $mo = [regex]::Escape($p[0].Replace('\', $sep))
      $script:omskrevet += [regex]::Matches($t, $mo, 'IgnoreCase').Count
      $t = [regex]::Replace($t, $mo, $p[1].Replace('\', $sep).Replace('$', '$$'), 'IgnoreCase')
    }
  }
  return $t
}
function Skriv-Omskrevet($fra, $til) {
  New-Item -ItemType Directory -Force (Split-Path -Parent $til) | Out-Null
  $t = [IO.File]::ReadAllText($fra)
  [IO.File]::WriteAllText($til, (Omskriv-Stier $t), (New-Object Text.UTF8Encoding $false))
}
$ind = Join-Path $ny "Indstillinger"
foreach ($f in 'settings.json', 'keybindings.json') {
  $s = Join-Path $VSCode $f; if (Test-Path -LiteralPath $s) { Skriv-Omskrevet $s (Join-Path $ind "VSCode\$f") }
}
$snip = Join-Path $VSCode "snippets"
if (Get-ChildItem -LiteralPath $snip -File -ErrorAction SilentlyContinue) { Kopier-Mappe $snip (Join-Path $ind "VSCode\snippets") }
$udvidelser = 0
if ($CodeCli -and (Get-Command $CodeCli -ErrorAction SilentlyContinue)) {
  $liste = @(& $CodeCli --list-extensions 2>$null)
  $udvidelser = $liste.Count
  [IO.File]::WriteAllLines((Join-Path $ind "VSCode\extensions.txt"), [string[]]$liste, (New-Object Text.UTF8Encoding $false))
}
foreach ($f in 'settings.json', 'statusline-command.ps1') {
  $s = Join-Path $Hjem ".claude\$f"; if (Test-Path -LiteralPath $s) { Skriv-Omskrevet $s (Join-Path $ind "ClaudeCode\$f") }
}
$tema = Join-Path $Hjem ".claude\themes"
$temaer = @(Get-ChildItem -LiteralPath $tema -File -ErrorAction SilentlyContinue).Count
if ($temaer) { Kopier-Mappe $tema (Join-Path $ind "ClaudeCode\themes") }
# Claude Code-mods (fx statuspanel) ligger i ~\.claude\dev-mods\<id>\<mod> med .claude-plugin\plugin.json.
# Id-mappen flades ud. Uden dette laa et mod kun i en loes kopi (AI SOSU\AI SETUP, ryddet 09-11-2026).
$mods = @()
Get-ChildItem -LiteralPath (Join-Path $Hjem ".claude\dev-mods") -Directory -ErrorAction SilentlyContinue | ForEach-Object {
  Get-ChildItem -LiteralPath $_.FullName -Directory | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName ".claude-plugin\plugin.json") } | ForEach-Object {
    $dst = Join-Path $ind "ClaudeCode\mods\$($_.Name)"
    if (Test-Path -LiteralPath $dst) { $script:dubletter += "ClaudeCode\mods\$($_.Name)"; return }
    Kopier-Mappe $_.FullName $dst
    $script:mods += $_.Name
  }
}

# Codex: hvidliste af tabeller. [projects.*] har mappenavne afledt af samtalernes emner, og
# mcp_servers/shell_environment_policy har maskinens stier og miljoe - de kommer aldrig med.
# Kun tabelpraefiks og antal logges, aldrig tabelnavnene.
$fjernet = [ordered]@{}; $stiLinjer = 0
$cfg = Join-Path $Hjem ".codex\config.toml"
if (Test-Path -LiteralPath $cfg) {
  $behold = '^(features|tui|windows|audio|desktop|plugins\..+|marketplaces\..+)$'
  $smid = '^(tui\.model_availability_nux|desktop\.open-in-target-preferences)$'
  $ud = New-Object System.Collections.Generic.List[string]; $hold = $true
  foreach ($linje in [IO.File]::ReadAllLines($cfg)) {
    if ($linje -match '^\s*\[\[?\s*(.+?)\s*\]\]?\s*$') {
      $tabel = $Matches[1]
      $hold = ($tabel -match $behold) -and ($tabel -notmatch $smid)
      if (-not $hold) { $k = ($tabel -split '\.')[0]; $fjernet[$k] = 1 + [int]$fjernet[$k] }
    }
    if (-not $hold) { continue }
    if ($linje -match '(?i)[a-z]:[\\/]|\\\\\?|\\\\[a-z]|%userprofile%') { $stiLinjer++; continue }
    $ud.Add($linje)
  }
  New-Item -ItemType Directory -Force (Join-Path $ind "Codex") | Out-Null
  $codexUd = Join-Path $ind "Codex\config.toml"
  [IO.File]::WriteAllLines($codexUd, [string[]]$ud, (New-Object Text.UTF8Encoding $false))
  $py = Get-Command python -ErrorAction SilentlyContinue
  if ($py) {
    & $py.Source -I -c "import sys,tomllib; tomllib.load(open(sys.argv[1],'rb'))" $codexUd 2>$null
    if ($LASTEXITCODE -ne 0) { Stop 1 "den filtrerede Codex-config er ikke gyldig TOML: $codexUd" }
  } else { L "  ADVARSEL: python findes ikke - Codex-config er ikke TOML-tjekket" }
}

# 3) LAESMIG
$enc = New-Object Text.UTF8Encoding $false
$t = [IO.File]::ReadAllText((Resolve-Path -LiteralPath $skabelon), [Text.Encoding]::UTF8)
$tabel = ($optalt.Keys | ForEach-Object { "| ``Skills\$_`` | $($optalt[$_]) |" }) -join "`n"
$t = $t.Replace('{{DATO}}', (Get-Date -Format 'dd-MM-yyyy HH:mm')).Replace('{{AIOS_SHA}}', $aiosSha)
$t = $t.Replace('{{PROJEKT_SHA}}', $(if ($projSha) { ($projSha | ForEach-Object { "``$_``" }) -join ', ' } else { 'ingen (intet projekt har skills endnu)' }))
$t = $t.Replace('{{SKILLS_TABEL}}', $tabel)
$t = $t.Replace('{{LAAST}}', $(if ($laast) { ($laast | ForEach-Object { "- ``$_``" }) -join "`n" } else { '- ingen' }))
$t = $t.Replace('{{DUBLETTER}}', $(if ($dubletter) { ($dubletter | ForEach-Object { "- ``$_``" }) -join "`n" } else { '- ingen' }))
$t = $t.Replace('{{CODEX_FJERNET}}', $(if ($fjernet.Count) { ($fjernet.Keys | ForEach-Object { "``[$_.*]`` ($($fjernet[$_]))" }) -join ', ' } else { 'intet' }))
$t = $t.Replace('{{UDVIDELSER}}', "$udvidelser").Replace('{{TEMAER}}', "$temaer")
$t = $t.Replace('{{MODS}}', $(if ($mods) { ($mods | ForEach-Object { "``$_``" }) -join ', ' } else { 'ingen' }))
[IO.File]::WriteAllText((Join-Path $ny "LAESMIG.md"), $t, $enc)
[IO.File]::WriteAllText((Join-Path $ny $Maerke), "Genereret af AI OS\tools\udgiv-opsaetning.ps1 - rediger ikke her.`r`n", $enc)

$antal = @(Get-ChildItem -LiteralPath $ny -Recurse -File -Force).Count
L ("Pakke bygget: $antal filer; skills " + (($optalt.Keys | ForEach-Object { "$_ $($optalt[$_])" }) -join ', '))
L "  ikke med (licens): $($laast.Count); dubletter: $($dubletter.Count); mapper uden SKILL.md: $udenSkill"
L "  Claude Code: temaer $temaer; mods $($mods.Count) ($($mods -join ', '))"
L ("  stier omskrevet: $omskrevet; Codex fjernet: " + (($fjernet.Keys | ForEach-Object { "$_ ($($fjernet[$_]))" }) -join ', ') + "; Codex-linjer med sti fjernet: $stiLinjer")

# 4) Scan. Et fund stopper alt. Kun sti, type og antal - aldrig selve fundet (e-mail: kun domaenet).
$tekst = '(?i)\.(md|txt|json|jsonc|toml|ya?ml|ps1|psm1|py|js|mjs|cjs|ts|tsx|html?|css|xml|sh|cmd|bat|csv|ini|cfg)$'
$noegle = '(sk-ant-[A-Za-z0-9_\-]{16,}|gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{20,}|xox[abprs]-[A-Za-z0-9\-]{10,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|(?i)["'']?(api[_-]?key|access[_-]?token|client[_-]?secret|password|passwd)["'']?\s*[:=]\s*["''][^"''\s]{12,}["''])'
$cpr = '(?<![\d.,:/-])(0[1-9]|[12]\d|3[01])(0[1-9]|1[0-2])\d{2}-?\d{4}(?![\d.,:/-])'
$mail = '[A-Za-z0-9._%+\-]+@([A-Za-z0-9\-]+(\.[A-Za-z0-9\-]+)*\.[A-Za-z]{2,})'
# Pladsholdere i dokumentation (Anthropics claude-api-skill: api_key="your-api-key", "xoxp-...") og
# eksempeladresser er ikke fund. Tilfoej kun et moenster her med begrundelse i commitbeskeden.
$pladsholder = '(?i)your[-_ ]|<[^>]*>|example|placeholder|x{4,}|\.\.\.|changeme|dummy|\*{3,}'
$tilladt = '(?i)^(noreply|no-reply)@|@(example\.(com|org|net)|anthropic\.com|users\.noreply\.github\.com|co\.com|workspacesamples\.dev)$'  # sidste: eksempler i Claude Codes MCP-typer (statuspanel)
$fund = 0
Get-ChildItem -LiteralPath $ny -Recurse -File -Force | Where-Object { $_.Name -match $tekst } | ForEach-Object {
  $rel = $_.FullName.Substring($ny.Length).TrimStart('\')
  $t = [IO.File]::ReadAllText($_.FullName)
  $n = @([regex]::Matches($t, $noegle) | Where-Object { $_.Value -notmatch $pladsholder }).Count
  if ($n) { L "  FUND noegle/token: $rel ($n)"; $script:fund += $n }
  $n = [regex]::Matches($t, $cpr).Count
  if ($n) { L "  FUND CPR-lignende tal: $rel ($n)"; $script:fund += $n }
  $ms = @([regex]::Matches($t, $mail) | Where-Object { $_.Value -notmatch $tilladt })
  if ($ms) { L ("  FUND e-mail: $rel ($($ms.Count); domaener: " + (($ms | ForEach-Object { $_.Groups[1].Value.ToLower() } | Sort-Object -Unique) -join ', ') + ")"); $script:fund += $ms.Count }
}
$rest = @(Get-ChildItem -LiteralPath $ind -Recurse -File -ErrorAction SilentlyContinue | Where-Object { [IO.File]::ReadAllText($_.FullName) -match '(?i)onedrive - social|c:[\\/]+users[\\/]+jst' })
foreach ($f in $rest) { L ("  FUND personlig sti tilbage: " + $f.FullName.Substring($ny.Length).TrimStart('\')); $fund++ }
if ($fund) { Stop 3 "$fund fund i pakken - intet er skrevet til OneDrive eller Y:. Pakken ligger til eftersyn i $ny" }
L "Scanning: 0 fund"

# 5) Pakken -> <OneDrive>\AI OS\Opsaetning (/MIR af en genereret mappe - kun hvis maerket bekraefter den)
$yOps = Join-Path $YAIOS $MappeNavn
if ($Proev) {
  if (Test-Path $YAIOS) {
    $ae = @(& robocopy $ny $yOps /E /L /NJH /NJS /NDL /NP /FP /R:0 /W:0 | Where-Object { $_ -match 'New File|Newer|Older|Changed' }).Count
    L "Proeve: $ae filer ville blive kopieret til $yOps"
  } else { L "Proeve: $YAIOS kan ikke naas - Y:-sammenligning sprunget over" }
  L "UDGIV OPSAETNING slut (proeve) - pakken ligger i $ny"
  exit 0
}
if ((Test-Path -LiteralPath $Pakke) -and -not (Test-Path -LiteralPath (Join-Path $Pakke $Maerke))) {
  Stop 1 "$Pakke findes, men er ikke en genereret pakke (mangler $Maerke) - roeres ikke"
}
& robocopy $ny $Pakke /MIR /R:1 /W:1 /NFL /NDL /NJH /NP | Select-Object -Last 6 | ForEach-Object { L ("  " + $_.Trim()) }
if ($LASTEXITCODE -ge 8) { Stop 1 "robocopy til $Pakke fejlede" }
L "OneDrive: $Pakke ajour"
Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue

# 6) -> Y:\AI OS\Opsaetning. Ingen sletning uden -RyddForaeldede.
if (-not (Test-Path $YAIOS)) { L "Y: kan ikke naas ($YAIOS) - pakken er kun bygget i OneDrive; koer igen med VPN eller UNC"; exit 2 }
& robocopy $Pakke $yOps /E /R:2 /W:5 /NFL /NDL /NJH /NP | Select-Object -Last 6 | ForEach-Object { L ("  " + $_.Trim()) }
if ($LASTEXITCODE -ge 8) { Stop 1 "robocopy til $yOps fejlede" }
$foraeldede = @(Get-ChildItem -LiteralPath $yOps -Recurse -File -Force -ErrorAction SilentlyContinue | Where-Object {
    -not (Test-Path -LiteralPath (Join-Path $Pakke $_.FullName.Substring($yOps.Length).TrimStart('\'))) })
if ($foraeldede.Count -eq 0) { L "Foraeldede filer paa ${yOps}: ingen" }
elseif ($RyddForaeldede) { $foraeldede | Remove-Item -Force -ErrorAction SilentlyContinue; L "Foraeldede filer paa ${yOps}: $($foraeldede.Count) slettet (-RyddForaeldede)" }
else {
  foreach ($f in $foraeldede | Select-Object -First 20) { L ("  foraeldet: " + $f.FullName.Substring($yOps.Length).TrimStart('\')) }
  L "Foraeldede filer paa ${yOps}: $($foraeldede.Count) - koer med -RyddForaeldede for at fjerne dem"
}
L "UDGIV OPSAETNING slut"
exit 0
