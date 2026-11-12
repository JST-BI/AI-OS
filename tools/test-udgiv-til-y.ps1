<#
.SYNOPSIS
  Vaern for udgiv-til-y.ps1: en gitignoreret fil med aeoeaa i navnet skal naa Y: (trin 2b).
.DESCRIPTION
  Bygger en falsk OneDrive (AI OS + AI SOSU\R, et repo uden remote med en ignoreret fil
  "Output\<navn med ae/oe/aa>.txt") og et falsk Y: i %TEMP% og koerer scriptet med konsollens tegnsaet
  850 - som en loesrevet powershell.exe (12-11-2026: git-navne blev afkodet forkert, Test-Path fejlede, og
  filen blev sprunget stille over; 1.616 filer i 8 repos). Intet skrives til OneDrive eller Y:.
.EXAMPLE
  & "<OneDrive>\AI OS\tools\test-udgiv-til-y.ps1"
#>
$ErrorActionPreference = 'Stop'
$script = Join-Path $PSScriptRoot "udgiv-til-y.ps1"
$rod = Join-Path $env:TEMP ("test-udgiv-til-y-" + (Get-Date -Format yyyyMMdd-HHmmss))
$enc = New-Object Text.UTF8Encoding $false
$fejl = 0
function Skriv($sti, $tekst) { New-Item -ItemType Directory -Force (Split-Path -Parent $sti) | Out-Null; [IO.File]::WriteAllText($sti, $tekst, $enc) }
function Forvent($navn, $betingelse, $tekst) { if ($betingelse) { "OK    $navn - $tekst" } else { "FEJL  $navn - $tekst"; $script:fejl++ } }

$od = Join-Path $rod "OneDrive"; $y = Join-Path $rod "Y"
$navn = "R" + [char]0xE6 + "kke " + [char]0xF8 + [char]0xE5 + ".txt"   # 'Række øå.txt'
Skriv "$od\AI OS\README.md" "aios`n"
$r = "$od\AI SOSU\R"
Skriv "$r\.gitignore" "Output/`n"
Skriv "$r\a.txt" "a`n"
Skriv "$r\Output\$navn" "ignoreret med aeoeaa`n"
Skriv "$r\Output\ascii.txt" "ignoreret ascii`n"
$eap = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
& git -C $r init -q 2>&1 | Out-Null
& git -C $r -c user.name=t -c user.email=t@example.invalid -c commit.gpgsign=false -c core.hooksPath= add -A 2>&1 | Out-Null
& git -C $r -c user.name=t -c user.email=t@example.invalid -c commit.gpgsign=false -c core.hooksPath= commit -q -m start 2>&1 | Out-Null
$ErrorActionPreference = $eap
New-Item -ItemType Directory -Force "$y\AI OS", "$y\AI SOSU" | Out-Null

$log = Join-Path $rod "udgiv.log"
$cmd = "[Console]::OutputEncoding = [Text.Encoding]::GetEncoding(850); & '$script' -OneDrive '$od' -YAIOS '$y\AI OS' -YAISOSU '$y\AI SOSU' -Log '$log'"
& powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command $cmd *> $null

Forvent 'klon' (Test-Path "$y\AI SOSU\R\a.txt") 'repoet uden remote er klonet til Y:'
Forvent 'ascii' (Test-Path -LiteralPath "$y\AI SOSU\R\Output\ascii.txt") 'ignoreret fil med ASCII-navn er kopieret'
Forvent 'aeoeaa' (Test-Path -LiteralPath "$y\AI SOSU\R\Output\$navn") 'ignoreret fil med aeoeaa i navnet er kopieret (tegnsaet 850)'
Forvent 'kun-y' ([bool](Select-String -LiteralPath $log -Pattern 'Filer der kun findes paa Y: 0' -Quiet)) 'ingen filer kun paa Y:'
Remove-Item -LiteralPath $rod -Recurse -Force -ErrorAction SilentlyContinue
if ($fejl) { "$fejl FEJL"; exit 1 } else { "alle OK"; exit 0 }
