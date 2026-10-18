#Requires -Version 5.1
<#
.SYNOPSIS
  Koerer en DAX-query mod den model der er aaben i Power BI Desktop (indlejret msmdsrv).

.DESCRIPTION
  Laeser kun. Gemmer intet, aendrer intet i modellen. Bruges til maaling-foer-merge
  (pbi-kritik-gaten), diagnose-dekomponering og facit-verifikation.

  Port og katalog-GUID findes automatisk, naar de udelades: porten fra msmdsrv-processens
  lyttende TCP-forbindelse, katalogen fra $SYSTEM.DBSCHEMA_CATALOGS. Begge skifter ved hver
  PBI-genstart, saa en gemt vaerdi fra en tidligere session er altid forkert.

  PERSONDATA: kun aggregater i output. Skriv EVALUATE-queries der returnerer antal, summer,
  distinkte taellinger eller ikke-personhenfoerbare noegler - aldrig raa personraekker, CPR,
  navne eller mail. Tool-output sendes til Anthropics servere.

  Persondatavagten (TypeSafe/Jev) vurderer ALTID queryen foer koersel. Kun et script der selv
  behandler resultatet lokalt og aldrig viser raekkerne, maa slaa den fra med -LokalBehandling.

.PARAMETER Query
  DAX-udtrykket som streng. Kan ikke kombineres med -QueryFile.
  Taber ae/oe/aa i maal- og tabelnavne - brug -QueryFile naar query'en indeholder danske tegn.

.PARAMETER QueryFile
  Sti til en UTF-8-fil (uden BOM) med DAX-udtrykket. Den sikre vej ved danske tegn.
  Skriv filen med [System.IO.File]::WriteAllText($sti, $q, (New-Object System.Text.UTF8Encoding $false))
  - Set-Content og Out-File giver BOM eller ANSI.

.PARAMETER Port
  msmdsrv-porten. Udelades den, findes den automatisk. Angiv den kun naar flere
  PBI-instanser koerer og du vil ramme en bestemt.

.PARAMETER Database
  Katalog-GUID (ADOMD "Initial Catalog"). Udelades den, findes den automatisk.
  Alias: -Catalog (det gamle navn; begge virker).

.PARAMETER LokalBehandling
  Kalderens erklaering: resultatet behandles i et script og vises aldrig i samtalen (fx en pipeline
  der henter personraekker til lokal aggregering). Slaar persondatavagten fra. Kun til committede
  scripts - aldrig til en ad hoc-query hvis output laeses i samtalen.

.PARAMETER Persondatavagt
  Foraeldet - vagten er standard (JST 2026-10-18). Accepteres stadig, saa aeldre kald virker.
  Vagten (tools/dax-persondata-vagt.py) vurderer queryen FOER den koeres:
  pass -> koerer; review -> stopper, medmindre -BekraeftAggregat er givet; block -> stopper altid.
  Sender kun queryteksten (med literaler maskeret) og modellens tabel-/kolonnenavne - aldrig data.

.PARAMETER BekraeftAggregat
  Agentens erklaering efter at have laest queryen: resultatet er kun aggregater. Laeser kun ved review.

.PARAMETER VedVagtNede
  Hvad der sker, naar vagten ikke kan naa TypeSafe (net, noegle, tjeneste nede). BRUGERENS valg -
  agenten spoerger JST og vaelger aldrig selv.
    Stop      (standard) Queryen koeres ikke; beskeden viser valgmulighederne.
    Noegleord Lokal noegleordsregel: hit (cpr/navn/mail ...) -> som review, ellers koeres queryen.
    Koer      Queryen koeres uden vurdering.

.EXAMPLE
  & "AI OS\tools\dax-query.ps1" -QueryFile "$env:TEMP\q.dax"
  Port og katalog findes selv; persondatavagten vurderer queryen foerst. Den normale form.

.EXAMPLE
  & "AI OS\tools\dax-query.ps1" -QueryFile $q -OutputFormat Csv -LokalBehandling
  Fra et script der aggregerer resultatet lokalt. Ingen vagt.

.EXAMPLE
  & "AI OS\tools\dax-query.ps1" -Query "EVALUATE ROW(""n"", COUNTROWS('L-Kalender'))"
  Inline-form. Kun til queries uden danske tegn.

.NOTES
  En BLANK maaler giver INGEN raekke i SUMMARIZECOLUMNS - raekken udelades helt.
  Fravaeret er signalet: taell altid de raekker du forventede.
#>
[CmdletBinding(DefaultParameterSetName = 'File')]
param(
  [Parameter(Mandatory = $true, ParameterSetName = 'File', Position = 0)]
  [ValidateScript({ if (Test-Path -LiteralPath $_) { $true } else { throw "QueryFile findes ikke: $_" } })]
  [string]$QueryFile,

  [Parameter(Mandatory = $true, ParameterSetName = 'Inline')]
  [ValidateNotNullOrEmpty()]
  [string]$Query,

  [ValidateRange(1, 65535)]
  [int]$Port,

  [Alias('Catalog')]
  [string]$Database,

  [ValidateSet('Table', 'Csv', 'Json')]
  [string]$OutputFormat = 'Table',

  [switch]$LokalBehandling,

  [switch]$Persondatavagt,

  [switch]$BekraeftAggregat,

  [ValidateSet('Stop', 'Noegleord', 'Koer')]
  [string]$VedVagtNede = 'Stop'
)

$ErrorActionPreference = 'Stop'

if ($LokalBehandling -and $Persondatavagt) {
  throw "-LokalBehandling og -Persondatavagt udelukker hinanden: vises resultatet i samtalen, skal vagten koere - fjern -LokalBehandling."
}

# --- ADOMD-klienten ------------------------------------------------------
$dll = 'C:\Program Files\DAX Studio\bin\Microsoft.AnalysisServices.AdomdClient.dll'
if (-not (Test-Path -LiteralPath $dll)) {
  throw "ADOMD-klienten findes ikke: $dll. Soeg bredt efter Microsoft.AnalysisServices.AdomdClient.dll og Microsoft.PowerBI.AdomdClient.dll."
}
try { Add-Type -Path $dll -ErrorAction Stop } catch { }  # harmloes ReflectionTypeLoadException

function Invoke-Adomd {
  # VIGTIGT: `return ,$dt` - kommaet er ikke en tastefejl. PowerShell UDRULLER en samling paa
  # vej ud af en funktion, og en DataTable enumererer sine raekker. Uden kommaet faar kalderen
  # DataRow-objekter i stedet for tabellen, saa $resultat.Rows.Count bliver $null - og en
  # kontrol som `-eq 0` laeser det som "ingen raekker". Fejlen ramte katalog-opdagelsen
  # 2026-09-05: modellen var indlaest og svarede fint paa raa ADOMD, mens scriptet meldte
  # "Ingen katalog fundet". Samme klasse som "en logfunktion maa aldrig skrive til pipelinen".
  param([string]$ConnStr, [string]$Dax)
  $conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection($ConnStr)
  $conn.Open()
  try {
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $Dax
    $da = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdDataAdapter($cmd)
    $dt = New-Object System.Data.DataTable
    [void]$da.Fill($dt)
    return ,$dt
  } finally { $conn.Close() }
}

# --- Port: find den, hvis den ikke er givet ------------------------------
if (-not $PSBoundParameters.ContainsKey('Port')) {
  $ms = @(Get-Process msmdsrv -ErrorAction SilentlyContinue)
  if ($ms.Count -eq 0) {
    throw "Ingen msmdsrv-proces - Power BI Desktop er ikke aaben med en model. Aabn .pbip'en (se BI-OEKONOMI/tools/pbi-desktop-cyklus.md) og proev igen."
  }
  # Get-Process | Get-NetTCPConnection binder IKKE i Windows PowerShell 5.1 - brug -OwningProcess.
  # Vaelg IKKE bare den foerste instans: PBI Desktop efterlader tomme msmdsrv-instanser uden
  # katalog (set 2026-09-05 - to instanser, kun den ene havde modellen). Vaelg den der faktisk
  # har et katalog, saa det ikke afhaenger af processernes raekkefoelge.
  $kandidater = @()
  foreach ($m in $ms) {
    foreach ($pt in (Get-NetTCPConnection -State Listen -OwningProcess $m.Id -ErrorAction SilentlyContinue |
                     Select-Object -ExpandProperty LocalPort -Unique)) {
      $kandidater += $pt
    }
  }
  if ($kandidater.Count -eq 0) {
    throw "msmdsrv koerer, men lytter ikke paa nogen port endnu - modellen er formentlig stadig ved at indlaese."
  }
  foreach ($pt in $kandidater) {
    try {
      $k = Invoke-Adomd -ConnStr "Data Source=localhost:$pt" -Dax "SELECT [CATALOG_NAME] FROM `$SYSTEM.DBSCHEMA_CATALOGS"
      if ($k.Rows.Count -gt 0) { $Port = $pt; if (-not $Database) { $Database = $k.Rows[0][0] }; break }
    } catch { }
  }
  if (-not $Port) {
    throw "Ingen af de $($kandidater.Count) msmdsrv-porte ($($kandidater -join ', ')) har et katalog. Er modellen faerdig med at indlaese?"
  }
  Write-Verbose "Port fundet: $Port (katalog: $Database)"
}

# --- Katalog: find det, hvis det ikke er givet ---------------------------
if ([string]::IsNullOrEmpty($Database)) {
  $cat = Invoke-Adomd -ConnStr "Data Source=localhost:$Port" -Dax "SELECT [CATALOG_NAME] FROM `$SYSTEM.DBSCHEMA_CATALOGS"
  if ($cat.Rows.Count -eq 0) { throw "Ingen katalog fundet paa localhost:$Port." }
  if ($cat.Rows.Count -gt 1) {
    Write-Warning "Flere kataloger paa porten: $(($cat.Rows | ForEach-Object { $_[0] }) -join ', '). Vaelger det foerste - angiv -Database for at ramme et bestemt."
  }
  $Database = $cat.Rows[0][0]
  Write-Verbose "Katalog fundet: $Database"
}

# --- Query ---------------------------------------------------------------
if ($PSCmdlet.ParameterSetName -eq 'File') {
  $utf8 = New-Object System.Text.UTF8Encoding $false
  $Query = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $QueryFile), $utf8)
}

$connStr = "Data Source=localhost:$Port;Initial Catalog=$Database"

# --- Persondatavagt (standard; -LokalBehandling slaar den fra) -----------
if ($LokalBehandling) {
  Write-Verbose "Persondatavagt: sprunget over (-LokalBehandling - resultatet behandles lokalt)."
}
else {
  $vagtDir = Join-Path $env:TEMP 'ai-os-persondatavagt'
  New-Item -ItemType Directory -Force -Path $vagtDir | Out-Null
  $utf8NoBom = New-Object System.Text.UTF8Encoding $false
  $qf = Join-Path $vagtDir 'query.dax'
  $cf = Join-Path $vagtDir 'kolonner.json'
  [System.IO.File]::WriteAllText($qf, $Query, $utf8NoBom)
  # Kolonnenavne fra modellen, saa vagten ogsaa ser kolonnerne bag `EVALUATE 'Tabel'`.
  # Type 3 = RowNumber (intern). Kolonnenavnene i DMV'erne er laest fra modellen 2026-10-17.
  $tabeller = @{}
  foreach ($r in (Invoke-Adomd -ConnStr $connStr -Dax 'SELECT [ID],[Name] FROM $SYSTEM.TMSCHEMA_TABLES').Rows) { $tabeller["$($r[0])"] = "$($r[1])" }
  $kolonner = foreach ($r in (Invoke-Adomd -ConnStr $connStr -Dax 'SELECT [TableID],[ExplicitName],[Type] FROM $SYSTEM.TMSCHEMA_COLUMNS').Rows) {
    if ("$($r[2])" -ne '3' -and "$($r[1])" -ne '' -and $tabeller.ContainsKey("$($r[0])")) {
      [pscustomobject]@{ t = $tabeller["$($r[0])"]; c = "$($r[1])" }
    }
  }
  [System.IO.File]::WriteAllText($cf, (ConvertTo-Json -InputObject @($kolonner) -Depth 3 -Compress), $utf8NoBom)
  $vagt = Join-Path $PSScriptRoot 'dax-persondata-vagt.py'
  # Kan vagten slet ikke koere (ingen Python, kun Store-genvejen, eller et nedbrud), er den
  # utilgaengelig som ved API-nedbrud - brugeren vaelger, scriptet fejler ikke haardt.
  $svar = $null; $kode = -1
  if (Get-Command python -ErrorAction SilentlyContinue) {
    try { $svar = & python -X utf8 $vagt --query-file $qf --columns-file $cf; $kode = $LASTEXITCODE } catch { $kode = -1 }
  }
  if ($kode -notin 0, 10, 20, 30) {
    $hit = [bool]($Query -match '(?i)cpr|navn|mail|tjenestenum|f.dselsdato|fornavn|efternavn|initial')
    $svar = ConvertTo-Json -Compress -InputObject @{ verdict = 'unavailable'; reason = "vagten kunne ikke koere (exit $kode - Python mangler?)"; keyword_hit = $hit }
    $kode = 30
  }
  Write-Verbose "Persondatavagt: $svar"
  switch ($kode) {
    0  { }
    10 {
      if (-not $BekraeftAggregat) {
        throw "Persondatavagt: REVIEW - queryen kan eksponere personer. Laes den igen; returnerer den kun aggregater, saa koer igen med -BekraeftAggregat. $svar"
      }
      Write-Warning "Persondatavagt: review tilsidesat med -BekraeftAggregat."
    }
    20 { throw "Persondatavagt: BLOKERET - resultatet ville eksponere personer. Skriv queryen om til antal/summer/distinkte taellinger. $svar" }
    30 {
      $nede = $svar | ConvertFrom-Json
      switch ($VedVagtNede) {
        'Stop' {
          throw ("Persondatavagt: UTILGAENGELIG ($($nede.reason)) - queryen er IKKE koert. Brugeren vaelger (agenten spoerger JST):`n" +
                 "  -VedVagtNede Noegleord  lokal noegleordsregel (hit i denne query: $($nede.keyword_hit))`n" +
                 "  -VedVagtNede Koer       koer uden vurdering`n" +
                 "  eller proev igen senere.")
        }
        'Noegleord' {
          if ($nede.keyword_hit -and -not $BekraeftAggregat) {
            throw "Persondatavagt utilgaengelig; noegleordsreglen ramte. Laes queryen igen; returnerer den kun aggregater, saa koer igen med -BekraeftAggregat."
          }
          Write-Warning "Persondatavagt utilgaengelig - lokal noegleordsregel brugt efter brugerens valg."
        }
        'Koer' { Write-Warning "Persondatavagt utilgaengelig - queryen koeres uden vurdering efter brugerens valg." }
      }
    }
  }
}

$dt = Invoke-Adomd -ConnStr $connStr -Dax $Query

switch ($OutputFormat) {
  'Csv'  { $dt | ConvertTo-Csv -NoTypeInformation | Write-Output }
  'Json' { $dt | Select-Object $dt.Columns.ColumnName | ConvertTo-Json -Depth 4 | Write-Output }
  default { $dt | Format-Table -AutoSize | Out-String -Width 4096 | Write-Output }
}
