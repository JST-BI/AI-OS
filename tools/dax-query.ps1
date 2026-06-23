param(
  [string]$Port = "50653",
  [string]$Catalog = "",
  [string]$QueryFile = "",
  [string]$Query = ""
)
$dll = 'C:\Program Files\DAX Studio\bin\Microsoft.AnalysisServices.AdomdClient.dll'
try { Add-Type -Path $dll -ErrorAction Stop } catch { }  # harmless ReflectionTypeLoadException

if ($QueryFile -ne "") {
  $utf8 = [System.Text.UTF8Encoding]::new($false)
  $Query = [System.IO.File]::ReadAllText($QueryFile, $utf8)
}

$connStr = "Data Source=localhost:$Port"
if ($Catalog -ne "") { $connStr += ";Initial Catalog=$Catalog" }

$conn = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection($connStr)
$conn.Open()
try {
  $cmd = $conn.CreateCommand()
  $cmd.CommandText = $Query
  $da = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdDataAdapter($cmd)
  $dt = New-Object System.Data.DataTable
  [void]$da.Fill($dt)
  $dt | Format-Table -AutoSize | Out-String -Width 4096 | Write-Output
} finally {
  $conn.Close()
}
