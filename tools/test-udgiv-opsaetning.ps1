<#
.SYNOPSIS
  Vaern for udgiv-opsaetning.ps1: hvert filter og hver scanning skal kunne fejle.
.DESCRIPTION
  Bygger en falsk hjemmemappe og VS Code-mappe i %TEMP% og koerer scriptet med -Proev mod en
  Y:-sti der ikke findes. AI OS-skills hentes fra den rigtige OneDrive-klon (kun laesning, git archive).
  Hver mutation planter EN ting og kontrollerer exitkoden og pakkens indhold. Intet skrives til
  OneDrive eller Y:.
.EXAMPLE
  & "<OneDrive>\AI OS\tools\test-udgiv-opsaetning.ps1"
#>
param([string]$OneDrive = "C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers")
$ErrorActionPreference = 'Stop'
$script = Join-Path $PSScriptRoot "udgiv-opsaetning.ps1"
$rod = Join-Path $env:TEMP ("test-udgiv-opsaetning-" + (Get-Date -Format yyyyMMdd-HHmmss))
$enc = New-Object Text.UTF8Encoding $false
$fejl = 0

function Skriv($sti, $tekst) { New-Item -ItemType Directory -Force (Split-Path -Parent $sti) | Out-Null; [IO.File]::WriteAllText($sti, $tekst, $enc) }
function Byg-Hjem($navn) {
  $h = Join-Path $rod "$navn\hjem"; $v = Join-Path $rod "$navn\vscode"
  Skriv "$h\.claude\skills\ren-skill\SKILL.md" "---`nname: ren-skill`ndescription: test`n---`nIntet her.`n"
  $od = $OneDrive.Replace('\', '\\')
  Skriv "$h\.claude\settings.json" ("{ `"statusLine`": { `"command`": `"" + $h.Replace('\', '\\') + "\\.claude\\statusline-command.ps1`" }, `"x`": `"$od\\AI OS\\tools\\a.ps1`" }")
  Skriv "$h\.codex\config.toml" "model = `"m`"`n`n[features]`nfoo = true`n`n[projects.'c:\\users\\x\\hemmeligt-emne']`ntrust_level = `"trusted`"`n"
  Skriv "$v\settings.json" "{ `"editor.fontSize`": 14 }"
  return @{ Hjem = $h; VSCode = $v }
}
function Koer($navn, $h) {
  $log = Join-Path $rod "$navn.log"
  & $script -OneDrive $OneDrive -YAIOS (Join-Path $rod "findes-ikke") -Hjem $h.Hjem -VSCode $h.VSCode -CodeCli '' -Proev -Log $log *> $null
  $kode = $LASTEXITCODE
  $pakke = (Select-String -LiteralPath $log -Pattern 'pakken ligger (i|til eftersyn i) (.+)$' | Select-Object -Last 1).Matches[0].Groups[2].Value.Trim()
  return @{ Kode = $kode; Pakke = $pakke; Log = $log }
}
function Forvent($navn, $betingelse, $tekst) {
  if ($betingelse) { "OK    $navn - $tekst" } else { "FEJL  $navn - $tekst"; $script:fejl++ }
}

# 0) Udgangspunkt: ren pakke -> exit 0, stier omskrevet, projects-tabel fjernet, TOML gyldig
$h = Byg-Hjem "0-ren"; $r = Koer "0-ren" $h
Forvent "0-ren" ($r.Kode -eq 0) "exit 0 (fik $($r.Kode))"
$cs = [IO.File]::ReadAllText((Join-Path $r.Pakke "Indstillinger\ClaudeCode\settings.json"))
Forvent "0-ren" ($cs -match '%USERPROFILE%' -and $cs -match 'Y:\\\\AI OS' -and $cs -notmatch [regex]::Escape($h.Hjem.Replace('\', '\\'))) "stier skrevet om til %USERPROFILE% og Y:\AI OS"
$ct = [IO.File]::ReadAllText((Join-Path $r.Pakke "Indstillinger\Codex\config.toml"))
Forvent "0-ren" ($ct -notmatch 'hemmeligt-emne' -and $ct -match '\[features\]') "[projects.*] fjernet, [features] beholdt"
Forvent "0-ren" (Test-Path (Join-Path $r.Pakke "Skills\Personlige\claude\ren-skill\SKILL.md")) "personlig skill med"
# 0a) Statuslinje med BOM og ae/oe/aa: BOM og tegn skal overleve omskrivningen (ellers laeser PS 5.1 den som ANSI)
$h = Byg-Hjem "0a-bom"
$tekst = "# Statuslinje: " + [char]0xE6 + [char]0xF8 + [char]0xE5 + "`n& '" + $h.Hjem + "\x.ps1'`n"
[IO.File]::WriteAllText("$($h.Hjem)\.claude\statusline-command.ps1", $tekst, (New-Object Text.UTF8Encoding $true))
$r = Koer "0a-bom" $h
$ud = Join-Path $r.Pakke "Indstillinger\ClaudeCode\statusline-command.ps1"
$bu = [IO.File]::ReadAllBytes($ud)
Forvent "0a-bom" ($r.Kode -eq 0 -and $bu[0] -eq 0xEF -and $bu[1] -eq 0xBB -and $bu[2] -eq 0xBF) "BOM bevaret"
Forvent "0a-bom" (([IO.File]::ReadAllText($ud)) -eq ($tekst.Replace($h.Hjem, '%USERPROFILE%'))) "tegn intakte, kun stien skrevet om"
# 0b) Claude Code-mod i dev-mods\<id>\<mod> kommer med, og id-mappen flades ud; en mappe uden plugin.json er ikke et mod
$h = Byg-Hjem "0b-mod"
Skriv "$($h.Hjem)\.claude\dev-mods\abc123-id\minmod\.claude-plugin\plugin.json" "{ `"name`": `"minmod`" }"
Skriv "$($h.Hjem)\.claude\dev-mods\abc123-id\minmod\hooks\hooks.json" "{}"
Skriv "$($h.Hjem)\.claude\dev-mods\abc123-id\ikke-mod\x.txt" "x"
Skriv "$($h.Hjem)\.claude\themes\mit-tema.json" "{ `"name`": `"mit-tema`" }"
$r = Koer "0b-mod" $h
$m = Join-Path $r.Pakke "Indstillinger\ClaudeCode\mods"
Forvent "0b-mod" ($r.Kode -eq 0 -and (Test-Path (Join-Path $m "minmod\hooks\hooks.json")) -and -not (Test-Path (Join-Path $m "ikke-mod")) -and -not (Test-Path (Join-Path $m "abc123-id"))) "mod med, fladet ud, ikke-mod udeladt"
Forvent "0b-mod" (Test-Path (Join-Path $r.Pakke "Indstillinger\ClaudeCode\themes\mit-tema.json")) "tema med"
Forvent "0b-mod" (([IO.File]::ReadAllText((Join-Path $r.Pakke "LAESMIG.md"))) -match '`minmod`' -and ([IO.File]::ReadAllText((Join-Path $r.Pakke "LAESMIG.md"))) -notmatch '\{\{') "mod listet i LAESMIG, ingen pladsholdere tilbage"

# 1-4) Hver scanning skal stoppe pakken
# Vaerdi = det hemmelige; det plantes i en saetning og maa aldrig staa i loggen.
$mut = [ordered]@{
  "1-noegle" = "sk-ant-api03-" + ("Ab3" * 15)
  "2-cpr"    = "010190-1234"
  "3-email"  = "person@sosu-eksempel.dk"
}
foreach ($k in $mut.Keys) {
  $h = Byg-Hjem $k
  Skriv "$($h.Hjem)\.claude\skills\ren-skill\noter.md" "Her staar $($mut[$k]) midt i teksten."
  $r = Koer $k $h
  Forvent $k ($r.Kode -eq 3) "scanningen stopper (exit 3, fik $($r.Kode))"
  Forvent $k (-not ((Get-Content -LiteralPath $r.Log -Raw).Contains($mut[$k]))) "fundet selv staar ikke i loggen"
}
# 4) Sti der ikke kan skrives om (en anden brugers profil i OneDrive-form) -> stop
$h = Byg-Hjem "4-sti"
Skriv "$($h.Hjem)\.claude\statusline-command.ps1" "& 'C:\Users\jst\Andet\x.ps1'"
$r = Koer "4-sti" $h
Forvent "4-sti" ($r.Kode -eq 3) "rest af personlig sti stopper (exit 3, fik $($r.Kode))"
# 5) Pladsholder i dokumentation er IKKE et fund
$h = Byg-Hjem "5-pladsholder"
Skriv "$($h.Hjem)\.claude\skills\ren-skill\noter.md" "api_key=`"your-api-key-here`" og jane@co.com"
$r = Koer "5-pladsholder" $h
Forvent "5-pladsholder" ($r.Kode -eq 0) "pladsholder og eksempeladresse giver exit 0 (fik $($r.Kode))"
# 6) Laast licens -> skill udelades, exit 0, og den staar i LAESMIG
$h = Byg-Hjem "6-licens"
Skriv "$($h.Hjem)\.agents\skills\laast\SKILL.md" "---`nname: laast`nlicense: Proprietary. LICENSE.txt has complete terms`n---`n"
Skriv "$($h.Hjem)\.agents\skills\laast\LICENSE.txt" "(c) 2025 Firma. All rights reserved."
$r = Koer "6-licens" $h
Forvent "6-licens" ($r.Kode -eq 0 -and -not (Test-Path (Join-Path $r.Pakke "Skills\Personlige\agents\laast"))) "laast skill ikke kopieret"
Forvent "6-licens" (([IO.File]::ReadAllText((Join-Path $r.Pakke "LAESMIG.md"))) -match 'Personlige\\agents\\laast') "laast skill listet i LAESMIG"
# 7) Junction foelges ikke (ellers kommer samme skill to gange)
$h = Byg-Hjem "7-junction"
Skriv "$($h.Hjem)\.agents\skills\delt\SKILL.md" "---`nname: delt`ndescription: x`n---`n"
New-Item -ItemType Junction -Path "$($h.Hjem)\.claude\skills\delt" -Target "$($h.Hjem)\.agents\skills\delt" | Out-Null
$r = Koer "7-junction" $h
Forvent "7-junction" ((Test-Path (Join-Path $r.Pakke "Skills\Personlige\agents\delt")) -and -not (Test-Path (Join-Path $r.Pakke "Skills\Personlige\claude\delt"))) "junction sprunget over, originalen med"

"{0} fejl" -f $fejl
if ($fejl -eq 0) { Remove-Item -LiteralPath $rod -Recurse -Force -ErrorAction SilentlyContinue }
Get-ChildItem $env:TEMP -Directory -Filter 'udgiv-opsaetning-*' | Where-Object { $_.CreationTime -gt (Get-Date).AddMinutes(-30) -and (Test-Path (Join-Path $_.FullName 'pakke\Skills\Personlige\claude\ren-skill')) } |
  Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
exit $fejl
