---
name: pbi-live-maaling
description: Live DAX-måling mod kørende Power BI Desktop — måling-før-merge, diagnose-dekomponering og facit-verifikation i BI-projekterne. Kun aggregater i output.
---

# Live-måling mod kørende PBI-model

Mål DAX-aggregater direkte mod den model JST har åben i PBI Desktop — uden at gemme, uden at
ændre noget.

```powershell
$q = @'
EVALUATE SUMMARIZECOLUMNS ( 'L-Kalender'[År], "AAE", [Årselever] )
'@
[System.IO.File]::WriteAllText("$env:TEMP\q.dax", $q, (New-Object System.Text.UTF8Encoding $false))
& "C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers\AI OS\tools\dax-query.ps1" -QueryFile "$env:TEMP\q.dax"
```

Port og katalog finder scriptet selv; brug `-QueryFile` frem for `-Query` når query'en indeholder
æ/ø/å. Resten af brugsvejledningen står i scriptets egen `Get-Help` — den opdateres sammen med
scriptet og kan derfor ikke drive fra det.

## Hårde regler

- **Kun aggregater i output.** Antal, summer, distinkte tællinger, deltaer og ikke-personhenførbare
  nøgler (konto-, forløbskoder). Aldrig rå personrækker, CPR, navne eller mail — tool-output sendes
  til Anthropics servere.
- **Sub-agenter kan ikke se JSTs msmdsrv-proces.** Orkestratoren måler selv og giver gate-agenten
  de færdige tal. Spawn aldrig en agent til selve målingen.
- **Mål dekomponeret, ikke på totaler**, når to fejl kan nette hinanden (291-vs-131: motor-totalen
  ramte Z8050-totalen, men sammensætningen var forkert).

## Gotchas — det scriptet ikke kan fortælle dig

- **Stale model**: disk-ændringer i TMDL er ikke i den kørende model, før .pbip er lukket helt
  (uden at gemme), genåbnet og refreshet. Måler du efter en disk-edit, måler du den gamle model.
- **Cache-drop**: CL-bump, nye entries i `functions.tmdl` og rene måler-tilføjelser dropper
  datacachen ved genindlæsning → fuld refresh før facit-måling.
- **En BLANK måler giver ingen række** i `SUMMARIZECOLUMNS`; fraværet er signalet. Tæl de rækker du
  forventede, ellers ligner et værn der fyrer et tomt resultat.
- En `CALCULATE` over flere måneder samlet giver forkerte tal for ikke-lineære målere (MAX/MIN pr.
  måned) — iterér med `SUMX(VALUES('L-Kalender'[Månedsstart]), …)`.
- Måler-reference i et boolsk filterargument er en fælde — brug VAR + eksplicit filterudtryk.
- Query-scoped `DEFINE MEASURE` / `DEFINE FUNCTION` de-risker: test ændringen live før TMDL-edit.

Er PBI ikke åben: `BI-OEKONOMI/tools/pbi-desktop-cyklus.md` (scripts `AI OS/tools/pbi-reopen.ps1`
og `pbi-screenshot.ps1`).
