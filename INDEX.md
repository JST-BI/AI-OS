# INDEX.md — samlet filindeks (SOSU Randers AI-økosystem)

> **Formål**: Ét opslagssted for alle styrede filer på tværs af AI OS og de 11 projekter.
> **Vedligehold**: Opdatér dette indeks når filer tilføjes, fjernes eller omdøbes i ethvert repo (se Selvvedligehold i `CLAUDE.md`).
> **Spejlprincip**: I alle repos er `CLAUDE.md` (Claude Code) og `AGENTS.md` (Codex) identiske spejle — redigér `CLAUDE.md`, spejl med `tools/sync-agents-md.ps1`. Håndhæves ved commit af `.githooks/check_md_mirror.py`.
> **Obsidian**: Vault-roden er `AI OS/`; den lokale junction `AI OS/AI-SOSU/` viser de fysiske projektfiler direkte. Der findes ingen særskilte Obsidian-kopier af `.md`-filerne.
> **Stier**: Relative til OneDrive-roden `…\OneDrive - Social og Sundhedsskolen Randers\`.
> Rådata i projekternes `Input/`-mapper (xlsx/pdf m.m.) er gitignored og indekseres ikke enkeltvis — **undtagen `ADM-KANTINE`**, hvor de små, persondatafrie menu-PDF'er committes.

---

## AI OS — `AI OS/` (repo: [JST-BI/AI-OS](https://github.com/JST-BI/AI-OS))

Infrastruktur: agentdefinitioner, AI-konfiguration, fælles værktøjer.

| Fil | Beskrivelse |
|---|---|
| `AI OS/CLAUDE.md` / `AGENTS.md` | Overordnede agentregler: startkontrol, routing, sikkerhedsregler, datagovernance, TMDL/PBIR-gotchas (spejle) |
| `AI OS/INDEX.md` | Dette indeks |
| `AI OS/tools/setup-new-repo.ps1` | Opsætning af nyt repo: begge pre-commit hooks, `.gitattributes`, `.codex/config.toml`, `core.hooksPath` |
| `AI OS/tools/sync-agents-md.ps1` | Spejler CLAUDE.md → AGENTS.md i alle projekter; `-Check` rapporterer drift (exit 1) |
| `AI OS/tools/codex-config.template.toml` | Kanonisk skabelon for projekternes `.codex/config.toml` |
| `AI OS/tools/dax-query.ps1` | Genbrugeligt live-DAX-query-værktøj mod PBI Desktops indlejrede msmdsrv |
| `AI OS/tools/validate-tmdl.ps1` | Offline TMDL-validering med PBI's egen TOM-deserializer — pre-flight-gate før PBI-åbning |
| `AI OS/tools/tmsl-refresh.ps1` | Tabel-scoped TMSL-refresh mod kørende PBI Desktop-instans (undgår fuld model-refresh) |
| `AI OS/.githooks/pre-commit` | Versioneret pre-commit hook; kalder begge checks nedenfor (findes i alle 12 repos) |
| `AI OS/.githooks/check_excel_pii.py` | Blokerer commit af Excel med persondata (CPR/e-mail/navnekolonner) |
| `AI OS/.githooks/check_md_mirror.py` | Blokerer commit hvor CLAUDE.md og AGENTS.md ikke er identiske spejle |
| `AI OS/.githooks/README.md` | Aktivering af hooks efter clone (findes i alle 12 repos) |
| `AI OS/.claude/` | Claude Code-indstillinger |
| `AI OS/.claude/skills/pbi-live-maaling/SKILL.md` | Skill (kun Claude Code): live DAX-måling mod kørende PBI Desktop — port-opdagelse, ADOMD, aggregat-only-regel, gotchas |
| `AI OS/.codex/config.toml` | Codex-konfiguration (TOML). Hæver `project_doc_max_bytes`, sætter sandkasse og AGENTS.md-fallback. Erstattede 2026-08-20 en virkningsløs `.Codex/settings.json` i Claude Codes JSON-format |
| `AI OS/.obsidian/` | Stabil Obsidian-konfiguration for vaulten med `AI OS/` som rod; maskinspecifik `workspace*.json` og cache er gitignored |
| `AI OS/AI-SOSU/` | Lokal, gitignored directory junction til `../AI-SOSU/`, så Obsidian læser alle projekt-repos direkte uden kopier |

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
| `.claude/rules/pbi-workflows.md` | Agent-workflow-mønstre for PBI-arbejde. Læses eksplicit af begge værktøjer — indlæses ikke automatisk. (Fjernet fra `.codex/rules/` 2026-08-20: dén mappe er til Starlark-`.rules`, ikke Markdown) |
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
| `.claude/rules/inno-workflows.md` | Agent-workflow-mønstre for INNOMATE-arbejde. Læses eksplicit af begge værktøjer — indlæses ikke automatisk. (Fjernet fra `.codex/rules/` 2026-08-20, se ovenfor) |
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

## ADM-KANTINE — `AI-SOSU/ADM-KANTINE/` (repo: [JST-BI/ADM-KANTINE](https://github.com/JST-BI/ADM-KANTINE))

Kantinens menukort: tilrettede udgaver af leverandørens ugemenu (Jespers Torvekøkken).
**Bemærk**: `Input/` committes her (små, persondatafrie PDF'er = dokumentation for hvert ugekort). `.gitattributes` sætter `*.pdf binary`.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: kilder, filnavngivning, ugentlig arbejdsgang (spejle) |
| `tools/byg-ugekort.py` | Generator: bygger `Output/Kantine Ugekort <uge>.pdf` (kun FAVORIT + stående Bowl-tilbud). Auto-skalerer dagsblokkene så de aldrig løber ned over allergen-footeren — kræver `reportlab` |
| `tools/test-layout.py` | Layout-værn: tjekker ugens indhold + et værre tilfælde, med negativ kontrol der kræver at et fast layout faktisk overlapper |
| `Input/<uge>_Aarhus_Portion.pdf` | Leverandørens portionsanretning, 5 sider (FAVORIT, Vegetar, Vegansk, Halal, Gluten/laktosefri) |
| `Input/Kantine - Prisskilt.pdf` | Kantinens prisskilt (bagværk, frokost, drikkevarer) — kilde til Bowl-prisen |
| `Output/Kantine Ugekort <uge>.pdf` | Ugens menukort til opslag — kun FAVORIT-retten pr. dag |
| `Output/Kantine - Prisskilt.pdf` | Prisskilt klar til opslag |

---

## BI-OPGAVEOVERSIGT — `AI-SOSU/BI-OPGAVEOVERSIGT/` (repo: [JST-BI/BI-OPGAVEOVERSIGT](https://github.com/JST-BI/BI-OPGAVEOVERSIGT))

Power BI-rapport: medarbejderes opgaveoversigt mod arbejdstidsnorm. Kilde: Budgetskema.xlsx på SharePoint + Studie+-udtræk (Z8004, Z8082).

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: datamodel, ShowRow-grain, normvarianter, rapportfiltre, PBI-/refresh-arbejdsgang (spejle) |
| `Power BI - Opgaveoversigt - Ledere.pbip` | PBIP-projektfil |
| `…SemanticModel/definition/tables/` | `DB Budget underviser og SPS medarbejder.tmdl` (fakta + alle målere), `Arbejdstidsnorm.tmdl`, `L-Kalender.tmdl` |
| `…SemanticModel/definition/expressions.tmdl` | M-queries, bl.a. `UV Medarbejder` og `Støtte Medarbejder` (normvarianterne) |
| `…Report/definition/pages/` | Siderne `Opgaveoversigt - Ledere` og `Forklaring på blokke` |

---

## BI-OPTAG FRAVÆR — `AI-SOSU/BI-OPTAG FRAVÆR/` (lokalt repo, intet GitHub-remote)

Power BI-rapport: elevoptag og skoleforløbsfravær. Kilde: Studie+-udtræk `Z8312` (alle holdplaceringer) og `Z8224S` (skoleforløbsfravær). Bragt under AI-styring 2026-08-20.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: datagrundlag, målergrupper, agentbrug, skærpet persondata-opmærksomhed (spejle) |
| `SOSU BI OPTAG FRAVÆR.pbip` | PBIP-projektfil |
| `…SemanticModel/definition/tables/` | Målergrupper (`#Measures - ELEV/HRLØN/KPI/TEMATIK/ØKONOMI`), `L-Kalender`, `L-STU Dim…`-dimensioner, `L-STU Fact Z8224S…` |
| `.codex/config.toml` | Codex-projektkonfiguration |

---

## ADM-AFTALER — `AI-SOSU/ADM-AFTALER/` (lokalt repo, intet GitHub-remote)

Samarbejds- og samhandelsaftaler med eksterne parter. Bragt under AI-styring 2026-08-20. `Input/` er gitignored som forsigtig standard: aftaler indeholder navne og underskrifter, og fortrolighedsniveauet er ikke afklaret.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: versionssammenligning af aftaletekst, juridisk forbehold, persondata (spejle) |
| `.codex/config.toml` | Codex-projektkonfiguration |

---

## ADM-BLANKET — `AI-SOSU/ADM-BLANKET/` (lokalt repo, intet GitHub-remote)

Administrative blanketter og formularer (i dag kørselsbemyndigelser). Bragt under AI-styring 2026-08-20. `Input/` er gitignored: blanketterne er personhenførbare af natur.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: blanketstruktur, skærpet persondata-advarsel mod `--no-verify` (spejle) |
| `.codex/config.toml` | Codex-projektkonfiguration |

---

## Fælles på tværs af alle 12 repos

| Fil | Beskrivelse |
|---|---|
| `.githooks/pre-commit` | Kalder begge checks nedenfor (aktivér pr. klon: `git config core.hooksPath .githooks`) |
| `.githooks/check_excel_pii.py` | Persondata-scan af staged Excel (CPR, e-mail, navnekolonner) |
| `.githooks/check_md_mirror.py` | Blokerer commit hvor CLAUDE.md og AGENTS.md ikke er identiske spejle |
| `.githooks/README.md` | Aktiveringsvejledning efter clone |
| `.codex/config.toml` | Codex-projektkonfiguration fra `AI OS/tools/codex-config.template.toml` |
| `.gitattributes` | `eol=lf` på hook-filerne, ellers `* text=auto` |
| `.gitignore` | Bl.a. Excel-/rådata-ignorering hvor relevant |
| `_Arkiv/` | Udgåede versioner (projekt-repos) |

**12 repos** = AI OS + 11 projekter. Tre af dem (`BI-OPTAG FRAVÆR`, `ADM-AFTALER`, `ADM-BLANKET`) har lokale git-repos uden GitHub-remote, indtil fortrolighedsniveauet er afklaret med JST.

**Bemærk (kun Claude Code)**: Claude Codes persistente hukommelse ligger lokalt under `~/.claude/projects/<AI OS-projekt>/memory/` med eget indeks `MEMORY.md` — den er personlig, ikke versionsstyret og ikke en del af repo-strukturen.
