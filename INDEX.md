# INDEX.md — samlet filindeks (SOSU Randers AI-økosystem)

> **Formål**: Ét opslagssted for alle styrede filer på tværs af AI OS og de 6 projekt-repos.
> **Vedligehold**: Opdatér dette indeks når filer tilføjes, fjernes eller omdøbes i ethvert repo (se Selvvedligehold i `CLAUDE.md`).
> **Spejlprincip**: I alle repos er `CLAUDE.md` (Claude Code) og `AGENTS.md` (Codex) identiske spejle — redigér `CLAUDE.md`, kopiér til `AGENTS.md`.
> **Stier**: Relative til OneDrive-roden `…\OneDrive - Social og Sundhedsskolen Randers\`.
> Rådata i projekternes `Input/`-mapper (xlsx/pdf m.m.) er gitignored og indekseres ikke enkeltvis.

---

## AI OS — `AI OS/` (repo: [JST-BI/AI-OS](https://github.com/JST-BI/AI-OS))

Infrastruktur: agentdefinitioner, AI-konfiguration, fælles værktøjer.

| Fil | Beskrivelse |
|---|---|
| `AI OS/CLAUDE.md` / `AGENTS.md` | Overordnede agentregler: startkontrol, routing, sikkerhedsregler, datagovernance, TMDL/PBIR-gotchas (spejle) |
| `AI OS/INDEX.md` | Dette indeks |
| `AI OS/tools/setup-new-repo.ps1` | Opsætning af nyt repo: persondata-hook, `.gitattributes`, `core.hooksPath` |
| `AI OS/tools/dax-query.ps1` | Genbrugeligt live-DAX-query-værktøj mod PBI Desktops indlejrede msmdsrv |
| `AI OS/.githooks/pre-commit` + `check_excel_pii.py` | Versioneret pre-commit hook: blokerer Excel med persondata (findes i alle 7 repos) |
| `AI OS/.githooks/README.md` | Aktivering af hook efter clone (findes i alle 7 repos) |
| `AI OS/.claude/` | Claude Code-indstillinger |
| `AI OS/.claude/skills/pbi-live-maaling/SKILL.md` | Skill (kun Claude Code): live DAX-måling mod kørende PBI Desktop — port-opdagelse, ADOMD, aggregat-only-regel, gotchas |
| `AI OS/.Codex/` | Codex-indstillinger (`settings.json`, `settings.local.json`) |

### Agentdefinitioner — `AI OS/agents/` (bruges af begge værktøjer)

| Fil | Rolle |
|---|---|
| `agents/pbi-dax.md` | DAX measures, KPIs, tidsintelligens, filterkontext |
| `agents/pbi-powerquery.md` | M-kode, query folding, relationer, stjerneskema |
| `agents/pbi-tmdl.md` | TMDL-syntaks, beregningsgrupper, model-metadata |
| `agents/pbi-performance.md` | VertiPaq, storage modes, refresh-optimering |
| `agents/pbi-naming.md` | Navngivningskonventioner, display folders, audits |
| `agents/pbi-kritik.md` | Kritisk GO/NO-GO-gate før merge (grain, dobbelttælling, fortegn) |
| `agents/pbi-design.md` | Obligatorisk visual-design-standard (cards, matrix, stak-farver, verifikation) |
| `agents/inno-hr.md` | Medarbejderlivscyklus, ansættelses-/fratrædelsesprocesser |
| `agents/inno-system.md` | INNOMATE-systemopsætning, handlinger, onboarding-konfiguration |
| `agents/inno-logistics.md` | Procesplaner, tjeklister, rollebeskrivelser |
| `agents/inno-mailtemplate.md` | Mailskabeloner i INNOMATE, merge-felter, CPR-regler |
| `agents/fin-analysis.md` | Finansiel analyse — afvigelser, budget vs. realiseret, cashflow |
| `agents/fin-patterns.md` | Mønstergenkendelse — anomalier, sæsonudsving, outliers |
| `agents/fin-statistics.md` | Statistik — prognoser, regressioner, konfidensintervaller |
| `agents/fin-accounting.md` | Regnskab — kontoplan, dimensioner, bogføringsregler |
| `agents/fin-data.md` | Dataanalyse — datakvalitet, krydskilder, aggregering |
| `agents/fin-database.md` | Databasestruktur — skemadesign, nøgler, relationer |
| `agents/md-optimizer.md` | Vedligehold af `.md`-hukommelsesfiler på tværs af repos |
| `agents/adm-bi.md` | BI governance og styringsdokumenter |

---

## BI-OEKONOMI — `AI-SOSU/BI-OEKONOMI/` (repo: [JST-BI/BI-OEKONOMI](https://github.com/JST-BI/BI-OEKONOMI))

Power BI-rapport og semantisk model for HR/økonomi.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: modelarkitektur, DAX/M-konventioner, workflow, gotchas (spejle) |
| `.claude/rules/pbi-workflows.md` / `.Codex/rules/pbi-workflows.md` | Agent-workflow-mønstre for PBI-arbejde (spejle) |
| `Rapporter/HR_OEKONOMI/` | Selve rapporten som `.pbip`: `HR_OEKONOMI.SemanticModel/` (TMDL) + `HR_OEKONOMI.Report/` (PBIR) |
| `Input/standards/power-query-step-naming.md` | Referencestandard for M-step-navngivning (VerbObject-Konkret) |
| `Output/tmdl/elevproduktion-integration/README.md` | Dokumentation af elevproduktions-integrationen |
| `tools/spor2-byggeplan.md` | Byggeplan for Spor 2 (Formål-dekomponering af resultatopgørelsen) |
| `tools/README-regnskabsforklaring.md` | Dokumentation af regnskabsforklarings-snapshotkæden |
| `tools/snapshot-regnskabsforklaring.ps1` + `snapshot_excel_merge.py` | Scripts til per-konto Forventet-snapshot (Spor 1) |
| `tools/dax-udf-forberedelse.md` | Kandidatliste og forberedelse til DAX UDF-migreringer |
| `tools/pq-analyse-og-optimering.md` | Analysenotat: Power Query-optimering og fxSheetImport |
| `tools/R1-spike-Spor2-DvP-findings.md` | Spike-findings for Spor 2 R1 (Drift vs. Projekt) |
| `tools/taxameter-dobbelttaelling-analyse.md` | Analyse af taxameter-dobbelttælling og netting-fix |
| `tools/motor-koncept-diagram.html` | JST-godkendt koncept-diagram: motor-terminologi, dataflow, afløbs-matrix pr. kohorte × regnskabsår, 291-vs-131, roadmap |

---

## SYS-INNOMATE — `AI-SOSU/SYS-INNOMATE/` (repo: [JST-BI/SYS-INNOMATE](https://github.com/JST-BI/SYS-INNOMATE))

Mailskabeloner og procesplaner for onboarding/offboarding via INNOMATE.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: orkestrator-rolle, CPR-regel, merge-felter, workflow (spejle) |
| `.claude/rules/inno-workflows.md` / `.Codex/rules/inno-workflows.md` | Agent-workflow-mønstre for INNOMATE-arbejde (spejle) |
| `generate-procesplan-v3.js` (+ `package.json`) | Procesplan-generator (Node.js) |
| `Input/Oprettelse af medarbejder/`, `Input/Nedlæggelse af medarbejder/`, `Input/Generelle skabeloner/` | Kildefiler: procesplaner, INNOMATE-skabeloner, korrespondance |
| `Output/` (samme undermapper) | Genererede skabeloner og procesplaner |

---

## ADM-HÅNDBØGER — `AI-SOSU/ADM-HÅNDBØGER/` (repo: [JST-BI/ADM-HANDBOOKS](https://github.com/JST-BI/ADM-HANDBOOKS))

Personalehåndbog og Lederhåndbog — afspejler hinandens emner.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: håndbogs-parallelitet, workflow (spejle) |
| `Personalehåndbog/` | Indhold målrettet medarbejdere |
| `Lederhåndbog/` | Samme emner, ledervinkel |
| `Input/` / `Output/` | Kildemateriale hhv. færdige/godkendte versioner |

---

## ADM-ØKONOMI — `AI-SOSU/ADM-ØKONOMI/` (repo: [JST-BI/ADM-OEKONOMI](https://github.com/JST-BI/ADM-OEKONOMI))

Økonomiske styringsdokumenter.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: dokumentrelationer, workflow (spejle) |
| `Regnskabsinstruks/` | Regler for bogføring, godkendelse, regnskabsaflæggelse |
| `Indkøbspolitik/` | Rammer for indkøb, leverandørstyring, udbudspligt |
| `Strategi for finansiel risiko/` | Risikovurdering, likviditetsstyring, finansielle principper |
| `Input/` / `Output/` | Kildemateriale hhv. færdige/godkendte versioner |

---

## ADM-BI — `AI-SOSU/ADM-BI/` (repo: [JST-BI/ADM-BI](https://github.com/JST-BI/ADM-BI))

BI governance og styringsdokumenter.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: governance-scope, relation til BI-OEKONOMI (spejle) |
| `Input/` / `Output/` | Kildemateriale hhv. godkendte standarder (normgivende for BI-OEKONOMI) |

---

## DATA-BUDGET_PROGNOSE — `AI-SOSU/DATA-BUDGET_PROGNOSE/` (repo: [JST-BI/DATA-BUDGET_PROGNOSE](https://github.com/JST-BI/DATA-BUDGET_PROGNOSE))

Finansiel analyse, budget og prognose (Navision + BRUGER-budget/prognose → .xlsx).

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: datakilder, formålskoder, fin-agent-routing (spejle) |
| `Input/` | Rådata: Navision-finansposter, budget, prognose, finanslov, årsrapporter (gitignored) |
| `Output/` | .xlsx-leverancer med danske formater (rene leverancer må committes) |

---

## Fælles på tværs af alle 7 repos

| Fil | Beskrivelse |
|---|---|
| `.githooks/pre-commit` + `check_excel_pii.py` + `README.md` | Persondata-scan af staged Excel (aktivér pr. klon: `git config core.hooksPath .githooks`) |
| `.gitattributes` | `eol=lf` på hook-filerne, ellers `* text=auto` |
| `.gitignore` | Bl.a. Excel-/rådata-ignorering hvor relevant |
| `_Arkiv/` | Udgåede versioner (projekt-repos) |

**Bemærk (kun Claude Code)**: Claude Codes persistente hukommelse ligger lokalt under `~/.claude/projects/<AI OS-projekt>/memory/` med eget indeks `MEMORY.md` — den er personlig, ikke versionsstyret og ikke en del af repo-strukturen.
