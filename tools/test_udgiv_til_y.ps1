<#
.SYNOPSIS
  Vaern for udgiv-til-y.ps1: nyere filer paa Y: overskrives ikke, lokale aendringer paa Y: stopper repoet,
  alle fejl giver exit != 0, Y: foelger altid main, foraeldede filer i AI SOSU meldes, og $IkkePaaYStier
  gaelder hvert FB-aar.
.DESCRIPTION
  Hvert scenarie bygger sin egen falske OneDrive (AI OS + AI SOSU\<repo>), et falsk Y: og evt. en bare-klon
  som "GitHub" under -Rod (standard C:\Temp\udgiv-test\<tid>) og koerer scriptet i en ny powershell.exe
  (scriptet slutter med exit). Intet skrives til OneDrive eller Y:. Mappen slettes bagefter.
  Koer med -Script mod en gammel udgave for at se proeverne roede:
    git show origin/main:tools/udgiv-til-y.ps1 > C:\Temp\udgiv-test\gammel.ps1
.PARAMETER Script
  Udgaven af udgiv-til-y.ps1, der proeves. Standard: den ved siden af testen.
.EXAMPLE
  & "<OneDrive>\AI OS\tools\test_udgiv_til_y.ps1"
#>
param(
  [string]$Script = (Join-Path $PSScriptRoot "udgiv-til-y.ps1"),
  [string]$Rod = (Join-Path "C:\Temp\udgiv-test" ("t-" + (Get-Date -Format yyyyMMdd-HHmmss))),
  [switch]$Behold
)
$ErrorActionPreference = 'Continue'
$enc = New-Object Text.UTF8Encoding $false
$AntalFejl = 0
$Nu = (Get-Date).ToUniversalTime()

function Skriv($sti, $tekst) { New-Item -ItemType Directory -Force (Split-Path -Parent $sti) | Out-Null; [IO.File]::WriteAllText($sti, $tekst, $enc) }
function Laes($sti) { if (Test-Path -LiteralPath $sti) { [IO.File]::ReadAllText($sti) } else { $null } }
function Tid($sti, [int]$minutter) { [IO.File]::SetLastWriteTimeUtc($sti, $Nu.AddMinutes($minutter)) }
function G($dir) { & git -C $dir -c user.name=t -c user.email=t@example.invalid -c commit.gpgsign=false -c core.hooksPath= -c gc.auto=0 -c maintenance.auto=false @args 2>&1 | Out-Null }
function Sha($dir, $ref = 'HEAD') { (& git -C $dir -c safe.directory=* rev-parse $ref 2>$null) }
function Commit($dir, $msg) { G $dir add -A; G $dir commit -q -m $msg }
function NytRepo($dir) { New-Item -ItemType Directory -Force $dir | Out-Null; G $dir init -q -b main }
function Forvent($navn, $betingelse, $tekst) {
  if ($betingelse) { "OK    $navn - $tekst" } else { "FEJL  $navn - $tekst"; $script:AntalFejl++ }
}
# Et nyt scenarie: falsk OneDrive og Y: med AI OS-rod.
function Scenarie($navn) {
  $r = Join-Path $Rod $navn
  $sc = @{ Rod = $r; OD = (Join-Path $r "OneDrive"); YOS = (Join-Path $r "Y\AI OS"); YSOSU = (Join-Path $r "Y\AI SOSU"); Log = (Join-Path $r "udgiv.log") }
  Skriv (Join-Path $sc.OD "AI OS\README.md") "aios`n"
  New-Item -ItemType Directory -Force (Join-Path $sc.OD "AI SOSU"), $sc.YOS, $sc.YSOSU | Out-Null
  $sc
}
function Koer($sc, [string]$ekstra = '', [int]$Tegnsaet = 0) {
  # -Tegnsaet: konsollens OutputEncoding i boerneprocessen (850 = loesrevet powershell.exe, 65001 = UTF-8-session).
  # Afviger den fra robocopy's OEM-tegnsaet, forvanskes aeoeaa i parset robocopy-udskrift.
  $cmd = $(if ($Tegnsaet) { "[Console]::OutputEncoding = [Text.Encoding]::GetEncoding($Tegnsaet); " } else { "" }) + "& '$Script' -OneDrive '$($sc.OD)' -YAIOS '$($sc.YOS)' -YAISOSU '$($sc.YSOSU)' -Log '$($sc.Log)' $ekstra; exit `$LASTEXITCODE"
  & powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command $cmd *> $null
  $kode = $LASTEXITCODE
  @{ Kode = $kode; Log = [string](Laes $sc.Log) }
}
# Repo uden remote i OneDrive (main, .gitignore Output/) + klon paa Y: uden remote.
function RepoUdenRemote($sc, $navn, [switch]$UdenY) {
  $od = Join-Path $sc.OD "AI SOSU\$navn"
  NytRepo $od
  Skriv "$od\.gitignore" "Output/`n"
  Skriv "$od\a.txt" "a`n"
  Commit $od "start"
  $y = Join-Path $sc.YSOSU $navn
  if (-not $UdenY) { & git clone -q $od $y 2>&1 | Out-Null; G $y remote remove origin }
  @{ OD = $od; Y = $y }
}
# Repo med "GitHub" (bare) som origin: OneDrive-klon og Y:-klon peger begge paa den.
function RepoMedRemote($sc, $navn, [switch]$UdenY) {
  $gh = Join-Path $sc.Rod "gh\$navn.git"
  New-Item -ItemType Directory -Force $gh | Out-Null
  & git init -q --bare -b main $gh 2>&1 | Out-Null
  $od = Join-Path $sc.OD "AI SOSU\$navn"
  NytRepo $od
  Skriv "$od\a.txt" "a`n"
  Commit $od "start"
  G $od remote add origin $gh
  G $od push -q origin main
  $y = Join-Path $sc.YSOSU $navn
  if (-not $UdenY) { & git clone -q $gh $y 2>&1 | Out-Null }
  @{ GH = $gh; OD = $od; Y = $y }
}

if (-not (Test-Path -LiteralPath $Script)) { "Scriptet findes ikke: $Script"; exit 1 }
"Proever: $Script"
New-Item -ItemType Directory -Force $Rod | Out-Null

# --- S0: alt rent -> exit 0 og "UDGIV OK" (fund 3: opsummering) -------------------------------------------
$sc = Scenarie "s0-rent"
$null = RepoUdenRemote $sc "R"
$res = Koer $sc
Forvent 's0-exit' ($res.Kode -eq 0) "rent udgangspunkt giver exit 0 (fik $($res.Kode))"
Forvent 's0-ok' ($res.Log -match 'UDGIV OK') 'sidste melding er "UDGIV OK"'

# --- S1: fil uden for git, nyere paa Y: (fund 1) ---------------------------------------------------------
$sc = Scenarie "s1-nyere-paa-y"
$r = RepoUdenRemote $sc "R"
Skriv "$($r.OD)\Output\laengde.txt" "od`n";        Tid "$($r.OD)\Output\laengde.txt" -60
Skriv "$($r.Y)\Output\laengde.txt" "y-nyere`n";    Tid "$($r.Y)\Output\laengde.txt" 0
Skriv "$($r.OD)\Output\samme.txt" "aaaa`n";        Tid "$($r.OD)\Output\samme.txt" -60
Skriv "$($r.Y)\Output\samme.txt" "bbbb`n";         Tid "$($r.Y)\Output\samme.txt" 0
Skriv "$($r.OD)\Output\ens.txt" "ens`n";           Tid "$($r.OD)\Output\ens.txt" -60
Skriv "$($r.Y)\Output\ens.txt" "ens`n";            Tid "$($r.Y)\Output\ens.txt" 0
Skriv "$($r.OD)\Output\odnyere.txt" "ny fra od`n"; Tid "$($r.OD)\Output\odnyere.txt" 0
Skriv "$($r.Y)\Output\odnyere.txt" "gl`n";         Tid "$($r.Y)\Output\odnyere.txt" -60
Skriv "$($r.OD)\Output\mangler.txt" "ny`n"
$res = Koer $sc
Forvent 's1-laengde' ((Laes "$($r.Y)\Output\laengde.txt") -eq "y-nyere`n") 'nyere Y:-fil med anden laengde er IKKE overskrevet'
Forvent 's1-samme' ((Laes "$($r.Y)\Output\samme.txt") -eq "bbbb`n") 'nyere Y:-fil med samme laengde er urort'
Forvent 's1-meldt' (($res.Log -match 'nyere paa Y: R/Output/samme\.txt') -and ($res.Log -match 'nyere paa Y: R/Output/laengde\.txt')) 'begge staar i listen "Nyere paa Y:"'
Forvent 's1-ens' ($res.Log -notmatch 'nyere paa Y: R/Output/ens\.txt') 'samme indhold (Y: nyere) meldes ikke'
Forvent 's1-antal' ($res.Log -match 'Nyere paa Y: \(ikke overskrevet\): 2') 'listen taeller 2'
Forvent 's1-odnyere' ((Laes "$($r.Y)\Output\odnyere.txt") -eq "ny fra od`n") 'nyere OneDrive-fil er kopieret til Y:'
Forvent 's1-mangler' ((Laes "$($r.Y)\Output\mangler.txt") -eq "ny`n") 'manglende fil er kopieret til Y:'
Forvent 's1-exit' ($res.Kode -ne 0) "exit != 0, naar noget er nyere paa Y: (fik $($res.Kode))"

# --- S2: lokale aendringer i Y:-klon med remote (fund 2) ------------------------------------------------
$sc = Scenarie "s2-dirty-y"
$r = RepoMedRemote $sc "G"
$r2 = RepoMedRemote $sc "G2"
$c1 = Sha $r.Y
Skriv "$($r.OD)\a.txt" "a2`n"; Commit $r.OD "c2"; G $r.OD push -q origin main
Skriv "$($r2.OD)\a.txt" "a2`n"; Commit $r2.OD "c2"; G $r2.OD push -q origin main
Skriv "$($r.Y)\a.txt" "kollegas aendring`n"
$res = Koer $sc
$stash = @(& git -C $r.Y -c safe.directory=* stash list 2>$null)
Forvent 's2-ingen-stash' ($stash.Count -eq 0) "intet stashet paa Y: (fandt $($stash.Count))"
Forvent 's2-ingen-pull' ((Sha $r.Y) -eq $c1) 'Y:-klonen er ikke pullet'
Forvent 's2-aendring' ((Laes "$($r.Y)\a.txt") -eq "kollegas aendring`n") 'den lokale aendring ligger urort i arbejdstraeet'
Forvent 's2-meldt' ($res.Log -match 'FEJL: G : 1 lokale aendringer paa Y:') 'repoet meldes som FEJL'
Forvent 's2-exit' ($res.Kode -eq 1) "exit 1 (fik $($res.Kode))"
Forvent 's2-rent-repo' ((Sha $r2.Y) -eq (Sha $r2.OD)) 'et rent repo med remote ff-es stadig'

# --- S3: fejl paavirker exit-koden (fund 3) --------------------------------------------------------------
# 3a robocopy >= 8: Y:-filen er laast, mens OneDrive har en nyere.
$sc = Scenarie "s3a-robocopy"
$null = RepoUdenRemote $sc "R"
Skriv "$($sc.YOS)\laast.txt" "gl`n"; Tid "$($sc.YOS)\laast.txt" -60
Skriv "$($sc.OD)\AI OS\laast.txt" "ny`n"
$laas = [IO.File]::Open("$($sc.YOS)\laast.txt", 'Open', 'ReadWrite', 'None')
try { $res = Koer $sc } finally { $laas.Close() }
Forvent 's3a-exit' ($res.Kode -eq 1) "robocopy-fejl giver exit 1 (fik $($res.Kode))"
Forvent 's3a-opsum' ($res.Log -match 'UDGIV FEJL: \d+') 'opsummering "UDGIV FEJL: n"'
# 3b klon uden remote, der ikke kan fast-forwardes (Y: har en commit, OneDrive ikke har).
$sc = Scenarie "s3b-ikke-ff"
$r = RepoUdenRemote $sc "N"
Skriv "$($r.Y)\a.txt" "kun paa y`n"; Commit $r.Y "kun-y"   # samme fil som OneDrive: ikke "kun paa Y:"
Skriv "$($r.OD)\a.txt" "a2`n"; Commit $r.OD "c2"
$res = Koer $sc
Forvent 's3b-exit' ($res.Kode -eq 1) "ikke-ff klon uden remote giver exit 1 (fik $($res.Kode))"
# 3c klon med remote, hvor merge --ff-only afvises (divergeret, men ren).
$sc = Scenarie "s3c-ff-afvist"
$r = RepoMedRemote $sc "G"
Skriv "$($r.Y)\a.txt" "kun paa y`n"; Commit $r.Y "kun-y"   # samme fil som OneDrive: ikke "kun paa Y:"
Skriv "$($r.OD)\a.txt" "a2`n"; Commit $r.OD "c2"; G $r.OD push -q origin main
$res = Koer $sc
Forvent 's3c-exit' ($res.Kode -eq 1) "afvist ff-only giver exit 1 (fik $($res.Kode))"
Forvent 's3c-opsum' ($res.Log -match 'UDGIV FEJL: \d+') 'opsummering "UDGIV FEJL: n"'

# --- S4: Y: foelger altid main (fund 4) ------------------------------------------------------------------
$sc = Scenarie "s4-main"
# 4a uden remote: OneDrive-klonen staar paa en feature-gren foran main.
$r = RepoUdenRemote $sc "R"
Skriv "$($r.OD)\a.txt" "main2`n"; Commit $r.OD "main2"
$main2 = Sha $r.OD
G $r.OD checkout -q -b feature
Skriv "$($r.OD)\f.txt" "feature`n"; Commit $r.OD "feature"
# 4b mangler paa Y:, har GitHub-remote, OneDrive-klonen staar paa en feature-gren.
$m = RepoMedRemote $sc "M" -UdenY
$mMain = Sha $m.OD
G $m.OD checkout -q -b feature
Skriv "$($m.OD)\f.txt" "feature`n"; Commit $m.OD "feature"
$res = Koer $sc
Forvent 's4a-main' ((Sha $r.Y) -eq $main2) 'klon uden remote ff-es til OneDrive-klonens main, ikke dens aktuelle gren'
$mGren = (& git -C $m.Y -c safe.directory=* branch --show-current 2>$null)
Forvent 's4b-gren' ($mGren -eq 'main' -and (Sha $m.Y) -eq $mMain) "manglende repo klones fra main (gren '$mGren')"
$mUrl = (& git -C $m.Y -c safe.directory=* remote get-url origin 2>$null)
Forvent 's4b-origin' ($mUrl -eq $m.GH) 'origin bevares som GitHub-remoten (fjernes ikke)'
# 4c OneDrive-klonen har ingen main -> intet klonet, exit != 0.
$sc = Scenarie "s4c-ingen-main"
$od = Join-Path $sc.OD "AI SOSU\X"
New-Item -ItemType Directory -Force $od | Out-Null
G $od init -q -b master
Skriv "$od\a.txt" "a`n"; Commit $od "start"
$res = Koer $sc
Forvent 's4c-ikke-klonet' (-not (Test-Path (Join-Path $sc.YSOSU "X"))) 'repo uden main klones ikke til Y:'
Forvent 's4c-exit' ($res.Kode -eq 1) "exit 1 (fik $($res.Kode))"

# --- S5: foraeldede filer i Y:\AI SOSU meldes, slettes ikke (fund 5) -------------------------------------
$sc = Scenarie "s5-foraeldet"
$r = RepoUdenRemote $sc "R"
Skriv "$($r.Y)\Output\gammel.txt" "gammel`n"
$res = Koer $sc -ekstra '-RyddForaeldede'
Forvent 's5-meldt' ($res.Log -match 'Foraeldede filer paa Y:\\AI SOSU\\R : 1') 'foraeldet fil i AI SOSU meldes'
Forvent 's5-urort' (Test-Path "$($r.Y)\Output\gammel.txt") 'og slettes ikke (heller ikke med -RyddForaeldede)'

# --- S6: $IkkePaaYStier gaelder hvert FB-aar (fund 6) ----------------------------------------------------
$sc = Scenarie "s6-ikke-paa-y"
$r = RepoUdenRemote $sc "BI-OEKONOMI"
$g = "DATA-BUDGET_PROGNOSE\Output\Grundlag"
Skriv "$($r.OD)\.gitignore" "Output/`nDATA-BUDGET_PROGNOSE/Output/`n"; Commit $r.OD "ignore"
G $r.Y fetch -q $r.OD main; G $r.Y merge -q --ff-only FETCH_HEAD
Skriv "$($r.OD)\$g\budget2027\loen\jst-valg.json" "{}"
Skriv "$($r.OD)\$g\budget2028\loen\jst-valg.json" "{}"
Skriv "$($r.OD)\$g\Budget2029\loen\jst-valg.json" "{}"
Skriv "$($r.OD)\$g\andet.txt" "maa gerne`n"
Skriv "$($r.Y)\$g\budget2030\x.json" "{}"
$res = Koer $sc
Forvent 's6-2027' (-not (Test-Path "$($r.Y)\$g\budget2027")) 'budget2027 kopieres ikke (vaernet holder)'
Forvent 's6-2028' (-not (Test-Path "$($r.Y)\$g\budget2028")) 'budget2028 kopieres ikke (uafhaengigt af aarstal)'
Forvent 's6-case' (-not (Test-Path "$($r.Y)\$g\Budget2029")) 'Budget2029 (store bogstaver) kopieres ikke'
Forvent 's6-andet' (Test-Path "$($r.Y)\$g\andet.txt") 'andre filer i Grundlag kopieres'
Forvent 's6-advarsel' ($res.Log -match 'ADVARSEL BI-OEKONOMI/DATA-BUDGET_PROGNOSE/Output/Grundlag/budget\*/ : ligger paa Y:') 'en budget-mappe paa Y: giver ADVARSEL'

# --- S7: fortrolige data paa Y: er en FEJL, ikke en tavs advarsel (review #41) ---------------------------
# 7a ADM-BESPARELSER ligger paa Y:.
$sc = Scenarie "s7a-besparelser-paa-y"
$null = RepoUdenRemote $sc "R"
Skriv "$($sc.YSOSU)\ADM-BESPARELSER\varsling.txt" "fortroligt`n"
$res = Koer $sc
Forvent 's7a-exit' ($res.Kode -ne 0) "ADM-BESPARELSER paa Y: giver exit != 0 (fik $($res.Kode))"
Forvent 's7a-opsum' ($res.Log -match 'UDGIV FEJL: \d+') 'opsummering "UDGIV FEJL: n"'
Forvent 's7a-urort' (Test-Path "$($sc.YSOSU)\ADM-BESPARELSER\varsling.txt") 'intet slettet paa Y:'
# 7b en Grundlag/budget2027-fil ligger paa Y: og findes ogsaa i OneDrive (trin 3 ser den derfor ikke).
$sc = Scenarie "s7b-grundlag-paa-y"
$r = RepoUdenRemote $sc "BI-OEKONOMI"
Skriv "$($r.OD)\.gitignore" "Output/`nDATA-BUDGET_PROGNOSE/Output/`n"; Commit $r.OD "ignore"
G $r.Y fetch -q $r.OD main; G $r.Y merge -q --ff-only FETCH_HEAD
Skriv "$($r.OD)\$g\budget2027\loen\jst-valg.json" "{}"
Skriv "$($r.Y)\$g\budget2027\loen\jst-valg.json" "{}"
$res = Koer $sc
Forvent 's7b-exit' ($res.Kode -ne 0) "Grundlag-fil paa Y: giver exit != 0 (fik $($res.Kode))"
Forvent 's7b-opsum' ($res.Log -match 'UDGIV FEJL: \d+') 'opsummering "UDGIV FEJL: n"'
Forvent 's7b-urort' (Test-Path "$($r.Y)\$g\budget2027\loen\jst-valg.json") 'intet slettet paa Y:'

# --- S8: en hash, der ikke kan beregnes, er en FEJL, ikke "ens" (review #41) -----------------------------
$sc = Scenarie "s8-hashfejl"
$r = RepoUdenRemote $sc "R"
Skriv "$($r.OD)\Output\laast.txt" "od`n";       Tid "$($r.OD)\Output\laast.txt" -60
Skriv "$($r.Y)\Output\laast.txt" "y-nyere`n";   Tid "$($r.Y)\Output\laast.txt" 0
$laas = [IO.File]::Open("$($r.Y)\Output\laast.txt", 'Open', 'ReadWrite', 'None')
try { $res = Koer $sc } finally { $laas.Close() }
Forvent 's8-exit' ($res.Kode -eq 1) "ulaeselig Y:-fil giver exit 1 (fik $($res.Kode))"
Forvent 's8-meldt' ($res.Log -match 'FEJL: R/Output/laast\.txt : hash kunne ikke beregnes') 'hashfejlen meldes'

# --- S9: nyere fil paa Y:\AI OS meldes og overskrives ikke (review #41) ----------------------------------
$sc = Scenarie "s9-aios-nyere"
$null = RepoUdenRemote $sc "R"
Skriv "$($sc.OD)\AI OS\noter.md" "od`n";          Tid "$($sc.OD)\AI OS\noter.md" -60
Skriv "$($sc.YOS)\noter.md" "kollegas rettelse`n"; Tid "$($sc.YOS)\noter.md" 0
Skriv "$($sc.OD)\AI OS\ens.md" "ens`n";           Tid "$($sc.OD)\AI OS\ens.md" -60
Skriv "$($sc.YOS)\ens.md" "ens`n";                Tid "$($sc.YOS)\ens.md" 0
$res = Koer $sc
Forvent 's9-urort' ((Laes "$($sc.YOS)\noter.md") -eq "kollegas rettelse`n") 'nyere Y:\AI OS-fil er ikke overskrevet'
Forvent 's9-meldt' ($res.Log -match 'nyere paa Y: AI OS/noter\.md') 'den staar i listen "Nyere paa Y:"'
Forvent 's9-ens' ($res.Log -notmatch 'nyere paa Y: AI OS/ens\.md') 'samme indhold meldes ikke'
Forvent 's9-exit' ($res.Kode -ne 0) "exit != 0 (fik $($res.Kode))"

# --- S10: aeoeaa i stierne - trin 1 (nyere paa Y:) og trin 3 (kun paa Y:) maa ikke forvanske dem (review #41 r2)
$ae = [char]0xE6; $oe = [char]0xF8; $aa = [char]0xE5; $AEstort = [char]0xC6
foreach ($tegn in 850, 65001) {
$sc = Scenarie "s10-aeoeaa-$tegn"
$r = RepoUdenRemote $sc "R"
$mappe = "$ae$oe$aa"; $fil = "${AEstort}r$oe fil.txt"; $taet = "t${ae}t.txt"; $kunOS = "ny $ae$oe$aa.txt"; $kunSOSU = "kun $ae$oe$aa.txt"
Skriv "$($sc.OD)\AI OS\$mappe\$fil" "od`n";             Tid "$($sc.OD)\AI OS\$mappe\$fil" -60
Skriv "$($sc.YOS)\$mappe\$fil" "kollegas rettelse`n";   Tid "$($sc.YOS)\$mappe\$fil" 0
Skriv "$($sc.OD)\AI OS\$taet" "ens`n"
Skriv "$($sc.YOS)\$taet" "ens`n"
[IO.File]::SetLastWriteTimeUtc("$($sc.OD)\AI OS\$taet", $Nu.AddSeconds(-1)); [IO.File]::SetLastWriteTimeUtc("$($sc.YOS)\$taet", $Nu)
Skriv "$($sc.YOS)\$kunOS" "kun paa y`n"
Skriv "$($r.Y)\Output\$kunSOSU" "kun paa y`n"
$res = Koer $sc -Tegnsaet $tegn
$t = "s10-$tegn"
Forvent "$t-nyere" ($res.Log.Contains("nyere paa Y: AI OS/$mappe/$fil")) 'nyere Y:-fil med aeoeaa staar korrekt i "Nyere paa Y:"'
Forvent "$t-urort" ((Laes "$($sc.YOS)\$mappe\$fil") -eq "kollegas rettelse`n") 'og er ikke overskrevet'
Forvent "$t-ens" ($res.Log -notmatch '\d\d:\d\d:\d\d  FEJL:') 'ingen FEJL-linjer (samme indhold 1 s nyere, ingen forvansket hash-sti)'
Forvent "$t-ens-ikke-meldt" (-not $res.Log.Contains("nyere paa Y: AI OS/$taet")) 'samme indhold 1 s nyere meldes ikke som nyere'
Forvent "$t-kun-y-aios" ($res.Log.Contains("kun paa Y: $($sc.YOS)\$kunOS")) 'kun-paa-Y med aeoeaa (AI OS) staar korrekt i loggen'
Forvent "$t-kun-y-sosu" ($res.Log.Contains("kun paa Y: $($r.Y)\Output\$kunSOSU")) 'kun-paa-Y med aeoeaa (AI SOSU) staar korrekt i loggen'
Forvent "$t-antal" ($res.Log -match 'Filer der kun findes paa Y: 2') 'trin 3 taeller 2'
Forvent "$t-exit" ($res.Kode -eq 2) "exit 2 - kun nyere/kun paa Y:, ingen fejl (fik $($res.Kode))"
}

# --- S11: FilerUnder finder alle filer i den RIGTIGE OneDrive\AI OS (review #41 r3) ----------------------
# Kun laesning og kun antal. Med Files On-Demand er alle OneDrive-mapper reparse points; de skal foelges.
$rigtig = "C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers\AI OS"
if (Test-Path -LiteralPath $rigtig) {
  $ast = [System.Management.Automation.Language.Parser]::ParseFile($Script, [ref]$null, [ref]$null)
  $fu = $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $n.Name -eq 'FilerUnder' }, $true) | Select-Object -First 1
  if (-not $fu) { Forvent 's11-funktion' $false 'FilerUnder findes i scriptet' }
  else {
    function Fejl($m) { $script:S11Fejl++ }
    function L($m) { $script:S11Log += "$m`n" }
    $script:S11Fejl = 0; $script:S11Log = ''; $script:LinksOver = 0
    . ([scriptblock]::Create($fu.Extent.Text))
    $mapperX = @('.git', '.claude', '.codex-tmp', 'node_modules', '.agents'); $filerX = '(^|\\)workspace\.json$'
    $antalFU = (FilerUnder $rigtig $mapperX $filerX).Count
    $laengdeR = $rigtig.Length
    $antalGCI = @(Get-ChildItem -LiteralPath $rigtig -Recurse -File -Force -ErrorAction SilentlyContinue | Where-Object {
        $rel = $_.FullName.Substring($laengdeR).TrimStart('\'); $dele = $rel.Split('\')
        -not ($dele[0..($dele.Count - 2)] | Where-Object { $mapperX -contains $_ }) -and $rel -notmatch $filerX }).Count
    $tom = Join-Path $Rod "findes-ikke"
    $antalRC = @(& robocopy $rigtig $tom /L /E /XD $mapperX /XF workspace.json /NJH /NJS /NDL /NC /NS /NP /FP /R:0 /W:0 | Where-Object { $_.Trim() }).Count
    Forvent 's11-gci' ($antalFU -eq $antalGCI -and $antalFU -gt 100) "FilerUnder = Get-ChildItem -Recurse ($antalFU mod $antalGCI)"
    Forvent 's11-robocopy' ($antalFU -eq $antalRC) "FilerUnder = robocopy /L ($antalFU mod $antalRC)"
    Forvent 's11-fejl' ($S11Fejl -eq 0) "ingen ulaeselige mapper ($S11Fejl)"
    # Et aegte link (junction) foelges ikke.
    $jr = Join-Path $Rod "s11-junction"; Skriv "$jr\rod\a.txt" "a"; Skriv "$jr\maal\b.txt" "b"
    & cmd /c mklink /J "$jr\rod\link" "$jr\maal" 2>&1 | Out-Null
    $jf = FilerUnder "$jr\rod" @() ''
    Forvent 's11-junction' ($jf.Count -eq 1 -and $jf.ContainsKey('a.txt')) "junction foelges ikke ($($jf.Count) filer)"
    Forvent 's11-junction-meldt' (($S11Log -match 'link sprunget over \(Junction\)') -and $LinksOver -eq 1) 'det overspringne link meldes og taelles'
    & cmd /c rmdir "$jr\rod\link" 2>&1 | Out-Null
  }
}
else { "SPRUNGET s11 - $rigtig findes ikke paa denne maskine" }

# --- S12: FB <aar>-mappen spejles til Y:\Oekonomi\Oekonomistyring\FB <aar> (JST 20-11-2026) -------------
$stregO = [string][char]0xD8; $oekoN = "${stregO}konomi"; $styrN = "${stregO}konomistyring"   # ikke $OE: = $oe (PowerShell skelner ikke store/smaa)
$sc = Scenarie "s12-oekonomistyring"
$r = RepoUdenRemote $sc "BI-OEKONOMI" -UdenY
Skriv "$($r.OD)\.gitignore" "Output/`nDATA-BUDGET_PROGNOSE/Output/`n"
Skriv "$($r.OD)\DATA-BUDGET_PROGNOSE\tools\budget2027\budgetaar.py" "`"`"`"doc`"`"`"`nBUDGETAAR = 2031`nFB = f'FB {BUDGETAAR}'`n"
Commit $r.OD "budgetaar"
& git clone -q $r.OD $r.Y 2>&1 | Out-Null; G $r.Y remote remove origin
$fbO = "$($r.OD)\DATA-BUDGET_PROGNOSE\Output\FB 2031"
$maal = Join-Path $sc.Rod "Y\$oekoN\$styrN"
New-Item -ItemType Directory -Force $maal | Out-Null
$fbY = "$maal\FB 2031"
$aeFil = "Grundlag og input\$ae$oe$aa - med navne.txt"
Skriv "$fbO\FB 2031 - budgetforslag - med navne.txt" "ny`n"
Skriv "$fbO\$aeFil" "aeoeaa`n"
Skriv "$fbO\nyere.txt" "od`n";             Tid "$fbO\nyere.txt" -60
Skriv "$fbY\nyere.txt" "rettet paa Y`n";   Tid "$fbY\nyere.txt" 0
Skriv "$fbO\ens.txt" "ens`n";              Tid "$fbO\ens.txt" -60
Skriv "$fbY\ens.txt" "ens`n";              Tid "$fbY\ens.txt" 0
Skriv "$fbY\kun $ae$oe$aa paa maal.txt" "kun`n"
Skriv "$($r.OD)\DATA-BUDGET_PROGNOSE\Output\FB 2030\gammel.txt" "andet aar`n"
$res = Koer $sc
Forvent 's12-kopi' ((Laes "$fbY\FB 2031 - budgetforslag - med navne.txt") -eq "ny`n") 'manglende fil (med navne) er kopieret'
Forvent 's12-aeoeaa' ((Laes "$fbY\$aeFil") -eq "aeoeaa`n") 'fil med aeoeaa i undermappe er kopieret'
Forvent 's12-nyere' ((Laes "$fbY\nyere.txt") -eq "rettet paa Y`n") 'nyere fil paa maalet er IKKE overskrevet'
Forvent 's12-nyere-meldt' ($res.Log.Contains("nyere paa Y: $styrN/FB 2031/nyere.txt")) 'og staar i "Nyere paa Y:"'
Forvent 's12-kun-maal' ($res.Log.Contains("kun paa Y: $fbY\kun $ae$oe$aa paa maal.txt")) 'fil kun paa maalet meldes (trin 3)'
Forvent 's12-kun-urort' (Test-Path -LiteralPath "$fbY\kun $ae$oe$aa paa maal.txt") 'og slettes ikke'
Forvent 's12-andet-aar' (-not (Test-Path "$maal\FB 2030")) 'kun budgetaarets FB-mappe (ikke FB 2030)'
Forvent 's12-log' ($res.Log.Contains("${styrN}: 2 filer kopieret, 1 ens")) 'log "Oekonomistyring: 2 filer kopieret, 1 ens"'
Forvent 's12-exit' ($res.Kode -eq 2) "exit 2 (nyere + kun paa maal, ingen fejl) (fik $($res.Kode))"

if (-not $Behold) {
  Remove-Item -LiteralPath $Rod -Recurse -Force -ErrorAction SilentlyContinue
  # Standardroden C:\Temp\udgiv-test fjernes ogsaa, naar den er tom bagefter.
  $forael = Split-Path -Parent $Rod
  if ((Split-Path -Leaf $forael) -eq 'udgiv-test' -and -not (Get-ChildItem -LiteralPath $forael -Force -ErrorAction SilentlyContinue)) {
    Remove-Item -LiteralPath $forael -Force -ErrorAction SilentlyContinue
  }
}
if ($AntalFejl) { "$AntalFejl FEJL"; exit 1 } else { "alle OK"; exit 0 }
