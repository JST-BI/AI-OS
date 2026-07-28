#Requires -Version 5.1
<#
.SYNOPSIS
  Tabel-scoped TMSL-refresh mod en koerende PBI Desktop-instans (indlejret AS).
.DESCRIPTION
  Sender en TMSL 'refresh'-kommando via ADOMD til localhost:<Port>. Refresher kun de
  navngivne tabeller, saa man undgaar en fuld model-refresh (der ofte timeouter over VPN).
  Uden -Table refreshes hele databasen.
.PARAMETER Port
  msmdsrv-porten. Find den med:
    $p = Get-Process msmdsrv; foreach($x in $p){ Get-NetTCPConnection -State Listen -OwningProcess $x.Id }
.PARAMETER Catalog
  Katalog-GUID. Find den med:
    dax-query.ps1 -Port <port> -Query "SELECT [CATALOG_NAME] FROM `$SYSTEM.DBSCHEMA_CATALOGS"
.PARAMETER Table
  Et eller flere tabelnavne. Udelades de, refreshes hele databasen.
.PARAMETER RefreshType
  TMSL-refreshtype (full, dataOnly, calculate, automatic). Standard: full.
.EXAMPLE
  .\tmsl-refresh.ps1 -Port 55748 -Catalog f7bd9e67-... -Table "Arbejdstidsnorm"
#>
param(
  [Parameter(Mandatory = $true)][string]$Port,
  [Parameter(Mandatory = $true)][string]$Catalog,
  [string[]]$Table = @(),
  [string]$RefreshType = 'full',
  [int]$TimeoutSeconds = 3600
)
$ErrorActionPreference = 'Stop'

$dll = 'C:\Program Files\DAX Studio\bin\Microsoft.AnalysisServices.AdomdClient.dll'
try { Add-Type -Path $dll -ErrorAction Stop } catch { }  # harmless ReflectionTypeLoadException

if ($Table.Count -gt 0) {
  $objects = @($Table | ForEach-Object { @{ database = $Catalog; table = $_ } })
}
else {
  $objects = @(@{ database = $Catalog })
}
$tmsl = @{ refresh = @{ type = $RefreshType; objects = $objects } } | ConvertTo-Json -Depth 6 -Compress

$conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection("Data Source=localhost:$Port;Initial Catalog=$Catalog")
$conn.Open()
try {
  $cmd = $conn.CreateCommand()
  $cmd.CommandTimeout = $TimeoutSeconds
  $cmd.CommandText = $tmsl
  $sw = [System.Diagnostics.Stopwatch]::StartNew()
  [void]$cmd.ExecuteNonQuery()
  $sw.Stop()
  $hvad = if ($Table.Count -gt 0) { $Table -join ', ' } else { '<hele databasen>' }
  Write-Host ("OK: refresh ({0}) af {1} - {2:n1} sek." -f $RefreshType, $hvad, $sw.Elapsed.TotalSeconds)
}
finally {
  $conn.Close()
}
