---
name: pbi-live-maaling
description: Live DAX-måling mod kørende Power BI Desktop (msmdsrv) — port-opdagelse, ADOMD, aggregat-only persondata-regel. Brug ved måling-før-merge, diagnose-dekomponering og facit-verifikation i BI-OEKONOMI.
---

# Live-måling mod kørende PBI-model (msmdsrv)

Formål: måle DAX-aggregater direkte mod den model brugeren har åben i PBI Desktop — UDEN at gemme, UDEN at ændre noget. Bruges til måling-før-merge (pbi-kritik-gate), diagnose-dekomponering (fx kohorte × Indberetningsår) og facit-verifikation.

## Arbejdsgang

1. **Find porten** (skifter ved hver PBI-genstart — antag ALDRIG en gammel port):
   ```powershell
   Get-Process msmdsrv | Get-NetTCPConnection -State Listen | Select-Object LocalPort
   ```
   Ingen msmdsrv-proces ⇒ PBI Desktop er lukket — bed brugeren åbne .pbip, eller brug selvkørt PBI-cyklus (opskrift i BI-OEKONOMI/CLAUDE.md).

2. **Find katalog-GUID** (kræves som Initial Catalog):
   ```powershell
   pwsh "AI OS/tools/dax-query.ps1" -Port <port> -Query "SELECT [CATALOG_NAME] FROM `$SYSTEM.DBSCHEMA_CATALOGS"
   ```

3. **Kør DAX** via `AI OS/tools/dax-query.ps1`:
   - Queries med æ/ø/å i mål-/tabelnavne: skriv til UTF-8-fil (uden BOM) og brug `-QueryFile` — inline `-Query` taber encoding.
   - Kun `EVALUATE`-aggregater (ROW/SUMMARIZECOLUMNS/TOPN på nøgler) — se persondata-reglen nedenfor.
   - Query-scoped `DEFINE MEASURE`/`DEFINE FUNCTION` de-risker: test en måler-/UDF-ændring live FØR TMDL-edit.

## Hårde regler

- **PERSONDATA: kun aggregater i output.** Aldrig rå personrækker, CPR-, navne- eller mailværdier — tool-output sendes til Anthropics servere. Antal, summer, distinkte tællinger, deltaer og ikke-personhenførbare nøgler (konto-/forløbskoder) er OK. Se memory `persondata-kun-aggregater.md`.
- **Sub-agenter kan IKKE se brugerens msmdsrv-proces.** Orkestratoren kører måle-queries selv og giver gate-/analyse-agenter de færdige tal. Spawn aldrig en agent til selve målingen.
- **Mål dekomponeret, ikke på totaler**, når to fejl kan nette hinanden (fx 291-vs-131: motor-total ≈ Z8050-total, men sammensætningen er forkert).

## Gotchas

- ADOMD-dll: `C:\Program Files\DAX Studio\bin\Microsoft.AnalysisServices.AdomdClient.dll`. `Add-Type` kaster harmløs `ReflectionTypeLoadException` — allerede try/catch-pakket i dax-query.ps1. Findes dll'en ikke: søg bredt efter både `Microsoft.AnalysisServices.AdomdClient.dll` og `Microsoft.PowerBI.AdomdClient.dll`.
- **Stale model**: disk-TMDL-ændringer er IKKE i den kørende model før brugeren har genåbnet .pbip (luk HELT, gem ikke først) + refreshet. Måler du efter en disk-edit, måler du den GAMLE model.
- **Cache-drop**: CL-bump, nye functions i functions.tmdl OG rene måler-tilføjelser dropper datacachen ved genindlæsning → fuld refresh påkrævet før facit-måling.
- En CALCULATE over flere måneder SAMLET kan give forkerte tal for ikke-lineære målere (MAX/MIN pr. måned) — iterér pr. måned via `SUMX(VALUES('L-Kalender'[Månedsstart]), …)`.
- Måler-reference i boolsk filterarg er en fælde — brug VAR + eksplicit filterudtryk.
