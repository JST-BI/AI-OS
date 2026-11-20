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
function Koer($sc, [string]$ekstra = '') {
  $cmd = "& '$Script' -OneDrive '$($sc.OD)' -YAIOS '$($sc.YOS)' -YAISOSU '$($sc.YSOSU)' -Log '$($sc.Log)' $ekstra; exit `$LASTEXITCODE"
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

if (-not $Behold) { Remove-Item -LiteralPath $Rod -Recurse -Force -ErrorAction SilentlyContinue }
if ($AntalFejl) { "$AntalFejl FEJL"; exit 1 } else { "alle OK"; exit 0 }
