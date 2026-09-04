# Inaktive agenter

Rollefiler for projekter der ligger stille. De ligger her frem for i `agents/`, fordi Claude Code
injicerer hver agents `description` i systemprompten i **hver** session, uanset hvilket projekt
man arbejder i. Elleve sovende agenter kostede omkring 6 KB kontekst i hver eneste session — og
gjorde samtidig agentlisten sværere at vælge rigtigt i.

De er ikke slettet. Intet i dem er forældet af den grund; de er bare ikke i brug.

| Fil | Projekt |
|---|---|
| `fin-accounting`, `fin-analysis`, `fin-data`, `fin-database`, `fin-patterns`, `fin-statistics` | `DATA-BUDGET_PROGNOSE` |
| `inno-hr`, `inno-system`, `inno-logistics`, `inno-mailtemplate` | `SYS-INNOMATE` |
| `adm-bi` | `ADM-BI` |

## Sådan tages en i brug igen

1. `git mv agents-inaktive/<navn>.md agents/<navn>.md`
2. **Efterprøv agentens fakta mod virkeligheden, før du bruger den.** De fem PBI-agenter lå
   ubrugte i månedsvis og nåede at indeholde seks kolonnenavne der ikke fandtes, en advarsel om
   en bug der var rettet, og en navnekonvention der modsagde modellens egen. En agent der ikke
   kaldes, bliver ikke opdaget i at tage fejl.
3. Tilføj den i `INDEX.md` under de aktive agenter.

`fin-database.md` beskriver et foreslået `fct_`/`dim_`-skema for DATA-BUDGET_PROGNOSE. Det er
**ikke** HR_OEKONOMI-modellens konvention (den er `DOMAIN-LAYERTYPE-KILDE`) — bland dem ikke
sammen, hvis begge en dag er aktive.
