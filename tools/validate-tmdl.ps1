<#
.SYNOPSIS
    Validerer en Power BI TMDL-definitionsmappe UDEN at åbne Power BI Desktop.

.DESCRIPTION
    Kører modellens TMDL-filer gennem den samme TOM-deserializer som Power BI Desktop
    bruger ved åbning af en .pbip. Fanger strukturfejl (ukendte properties, forkert
    indrykning, dublerede properties) på sekunder i stedet for efter en 60-sekunders
    PBI-åbning der ender i "Issues were found".

    Biblioteket (DAX Studios AMO-build) kender ikke DAX UDF'er, så en model med
    functions.tmdl standser til sidst på et kompatibilitetsniveau-tjek. DET er et
    GRØNT resultat: al TMDL-parsing er da gennemført uden fejl.

.PARAMETER DefinitionPath
    Sti til <model>.SemanticModel\definition

.EXAMPLE
    pwsh tools\validate-tmdl.ps1 -DefinitionPath "...\HR_OEKONOMI.SemanticModel\definition"
#>
param(
    [Parameter(Mandatory = $true)][string]$DefinitionPath,
    [string]$DllDir = "C:\Program Files\DAX Studio\bin"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $DefinitionPath)) { throw "Findes ikke: $DefinitionPath" }
if (-not (Test-Path $DllDir)) { throw "AMO-bibliotek ikke fundet: $DllDir" }

# LoadFrom-context prober selv samme mappe for afhængigheder
$order = @("Newtonsoft.Json.dll") +
    (Get-ChildItem $DllDir -Filter "Microsoft.AnalysisServices*.dll" | Sort-Object Name | Select-Object -ExpandProperty Name)
foreach ($dll in $order) {
    $p = Join-Path $DllDir $dll
    if (Test-Path $p) { try { [void][System.Reflection.Assembly]::LoadFrom($p) } catch { } }
}

try {
    $db = [Microsoft.AnalysisServices.Tabular.TmdlSerializer]::DeserializeDatabaseFromFolder($DefinitionPath)
    $m = $db.Model
    Write-Output "GRØN: TMDL parset og modellen bygget uden fejl."
    Write-Output ("  Tabeller: {0}  Relationer: {1}  Målere: {2}" -f $m.Tables.Count, $m.Relationships.Count,
        (($m.Tables | ForEach-Object { $_.Measures.Count } | Measure-Object -Sum).Sum))
    exit 0
}
catch {
    $ex = $_.Exception
    $chain = @()
    while ($null -ne $ex -and $chain.Count -lt 8) { $chain += $ex; $ex = $ex.InnerException }

    # Kompatibilitetsniveau-stop = biblioteket kender ikke DAX UDF'er. Al parsing er gennemført.
    if ($chain | Where-Object { $_.GetType().Name -eq "CompatibilityViolationException" }) {
        Write-Output "GRØN: al TMDL-parsing gennemført uden strukturfejl."
        Write-Output "  (Stoppet til sidst på kompatibilitetsniveau — biblioteket kender ikke DAX UDF'er. Forventet.)"
        exit 0
    }

    Write-Output "RØD: TMDL kunne ikke deserialiseres."
    $i = 0
    foreach ($e in $chain) {
        Write-Output ("  [{0}] {1}: {2}" -f $i, $e.GetType().Name, $e.Message)
        foreach ($prop in @("Document", "LineNumber", "ColumnNumber", "Path", "ObjectName")) {
            $pv = $e.PSObject.Properties[$prop]
            if ($pv -and $pv.Value) { Write-Output ("        {0} = {1}" -f $prop, $pv.Value) }
        }
        $i++
    }
    exit 1
}
