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

.EXAMPLE
  & "AI OS\tools\dax-query.ps1" -QueryFile "$env:TEMP\q.dax"
  Port og katalog findes selv. Den normale form.

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
  [string]$OutputFormat = 'Table'
)

$ErrorActionPreference = 'Stop'

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

$dt = Invoke-Adomd -ConnStr "Data Source=localhost:$Port;Initial Catalog=$Database" -Dax $Query

switch ($OutputFormat) {
  'Csv'  { $dt | ConvertTo-Csv -NoTypeInformation | Write-Output }
  'Json' { $dt | Select-Object $dt.Columns.ColumnName | ConvertTo-Json -Depth 4 | Write-Output }
  default { $dt | Format-Table -AutoSize | Out-String -Width 4096 | Write-Output }
}
