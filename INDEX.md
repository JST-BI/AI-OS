# INDEX.md — samlet filindeks (SOSU Randers AI-økosystem)

> `<OneDrive>` = `C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers` (arbejdskopier); `Y:\AI OS` / `Y:\AI SOSU` er delte kopier til kollegerne.

> **Formål**: Ét opslagssted for alle styrede filer på tværs af AI OS og de 12 projekter.
> **Vedligehold**: Opdatér dette indeks når filer tilføjes, fjernes eller omdøbes i ethvert repo (se Selvvedligehold i `CLAUDE.md`).
> **Spejlprincip**: I alle repos er `CLAUDE.md` (Claude Code) og `AGENTS.md` (Codex) identiske spejle — redigér `CLAUDE.md`, spejl med `tools/sync-agents-md.ps1`. Håndhæves ved commit af `.githooks/check_md_mirror.py`.
> **Obsidian**: Vault-roden er `<OneDrive>\AI OS\`. De fysiske projektfiler ligger separat og kanonisk i `<OneDrive>\AI SOSU\`; der findes ingen junction eller særskilte Obsidian-kopier af projektfilerne.
> **Stier**: AI OS ligger i `<OneDrive>\AI OS\`, og alle arbejdsprojekter ligger i den separate kanoniske projektrod `<OneDrive>\AI SOSU\`.
> Rådata i projekternes `Input/`-mapper (xlsx/pdf m.m.) er gitignored og indekseres ikke enkeltvis — **undtagen `ADM-KANTINE`**, hvor de små, persondatafrie menu-PDF'er committes.

---

## AI OS — `AI OS/` (repo: [JST-BI/AI-OS](https://github.com/JST-BI/AI-OS))

Infrastruktur: agentdefinitioner, AI-konfiguration, fælles værktøjer.

| Fil | Beskrivelse |
|---|---|
| `AI OS/CLAUDE.md` / `AGENTS.md` | Overordnede agentregler: startkontrol, routing, sikkerhedsregler, datagovernance, TMDL/PBIR-gotchas (spejle) |
| `AI OS/INDEX.md` | Dette indeks |
| `AI OS/tools/setup-new-repo.ps1` | Opsætning af nyt repo: begge pre-commit hooks, `.gitattributes`, `.codex/config.toml`, `core.hooksPath` |
| `AI OS/tools/session-start-kontrol.ps1` | Deterministisk session-startkontrol (SessionStart-hook): spejl, rodrenhed, INDEX.md, projektfiler. Tavs ved succes |
| `AI OS/tools/codex-opsaetning.md` | Codex på en ny maskine: trust, `project_doc_max_bytes`, hooks, `.codex/rules/`. Flyttet ud af CLAUDE.md 2026-09-05 |
| `AI OS/tools/sync-agents-md.ps1` | Spejler CLAUDE.md → AGENTS.md i alle projekter; `-Check` rapporterer drift (exit 1) |
| `AI OS/tools/udgiv-til-y.ps1` | "Udgiv": spejler `<OneDrive>\AI OS` → `Y:\AI OS` og ff-puller `Y:\AI SOSU\<repo>` fra GitHub (kollegernes kopier); skill `/udgiv` |
| `AI OS/.claude/skills/udgiv/SKILL.md` | Skill bag kodeordet "Udgiv" |
| `AI OS/tools/codex-config.template.toml` | Kanonisk skabelon for projekternes `.codex/config.toml` |
| `AI OS/tools/dax-query.ps1` | Genbrugeligt live-DAX-query-værktøj mod PBI Desktops indlejrede msmdsrv |
| `AI OS/tools/validate-tmdl.ps1` | Offline TMDL-validering med PBI's egen TOM-deserializer — pre-flight-gate før PBI-åbning |
| `AI OS/tools/tmsl-refresh.ps1` | Tabel-scoped TMSL-refresh mod kørende PBI Desktop-instans (undgår fuld model-refresh) |
| `AI OS/tools/pbi-reopen.ps1` | Genåbner HR_OEKONOMI.pbip i en kørende "Untitled" PBI Desktop via UIA-recents (kold genstart-cyklus) |
| `AI OS/tools/pbi-screenshot.ps1` | Vælger rapportfane via UIA, lukker backstage, søger fejltekster og gemmer PrintWindow-screenshot |
| `AI OS/.githooks/pre-commit` | Versioneret pre-commit hook; kalder begge checks nedenfor (findes i alle 12 repos) |
| `AI OS/.githooks/check_excel_pii.py` | Blokerer commit af Excel med persondata (CPR/e-mail/navnekolonner) |
| `AI OS/.githooks/check_md_mirror.py` | Blokerer commit hvor CLAUDE.md og AGENTS.md ikke er identiske spejle |
| `AI OS/.githooks/README.md` | Aktivering af hooks efter clone (findes i alle 12 repos) |
| `AI OS/.claude/` | Claude Code-indstillinger |
| `AI OS/.claude/skills/pbi-live-maaling/SKILL.md` | Skill (kun Claude Code): live DAX-måling mod kørende PBI Desktop — port-opdagelse, ADOMD, aggregat-only-regel, gotchas |
| `AI OS/.codex/config.toml` | Codex-konfiguration (TOML). Hæver `project_doc_max_bytes`, sætter sandkasse og AGENTS.md-fallback. Erstattede 2026-08-20 en virkningsløs `.Codex/settings.json` i Claude Codes JSON-format |
| `AI OS/.obsidian/` | Stabil Obsidian-konfiguration for vaulten med `AI OS/` som rod; maskinspecifik `workspace*.json` og cache er gitignored. `app.json`/`daily-notes.json`/`templates.json` dirigerer nye noter til `vault/` — uden dem skrev daily-notes-pluginet i roden |
| `AI OS/vault/` | De frie Obsidian-noter (`inbox/`, `journal/`, `notes/{,people,decisions}/`, `meetings/`, `resources/`, `_templates/`, `_attachments/`). Adskilt fra de styrede filer — se CLAUDE.md → *Obsidian-vaultregler* |
| `AI OS/vault/CLAUDE.md` / `AGENTS.md` | Obsidian-notereglerne (frontmatter, routing, index-vedligehold, AI_ACTION_METADATA). Flyttet ud af AI OS-roden 2026-09-05 — de gælder kun filer under `vault/` (spejle) |
| `AI OS/vault/Index - Vault.md` | Vaultens MOC: mappeoversigt, routing og noteliste. Ikke det samme som dette indeks, der dækker **styrede** filer |
| `AI OS/vault/_templates/*.md` | Note-skabeloner med obligatorisk frontmatter: `Daily`, `Note`, `Meeting`, `Decision` |
| `<OneDrive>\AI SOSU\` | Separat fysisk og kanonisk projektrod på netværksdrevet; må ikke kopieres eller linkes ind under `<OneDrive>\AI OS\` |

### Agentdefinitioner — `AI OS/agents/` (bruges af begge værktøjer)

Claude Code spawner dem som subagenter via `~/.claude/agents`; Codex læser samme filer som
rolleinstruks. Hver agents `description` injiceres i systemprompten i hver session — derfor ligger
agenter for projekter i dvale i `agents-inaktive/`.

| Fil | Rolle |
|---|---|
| `agents/pbi-kritik.md` | **Obligatorisk GO/NO-GO-gate** før merge af model-/dataændring (grain, dobbelttælling, fortegn, måling-før-merge) |
| `agents/pbi-design.md` | **Obligatorisk** visual-design-standard (cards, matrix, stak-farver, visuel verifikation) |
| `agents/pbi-dax.md` | DAX: målere, tidsintelligens, filterkontekst, review. Verificerer navne mod TMDL-kilden |
| `agents/pbi-powerquery.md` | M-kode, grain og fan-out, relationer, query folding |
| `agents/pbi-tmdl.md` | TMDL-filerne: objekter, beregningsgrupper, relationships, load-diagnose. Kører `validate-tmdl.ps1` |
| `agents/pbi-performance.md` | Diagnose af langsom refresh/render/query mod målt baseline. Rapporterer, implementerer ikke |
| `agents/pbi-naming.md` | Navnebeslutninger og -audits mod modellens egen, målte konvention |
| `agents/md-optimizer.md` | Vedligehold af instruktions- og hukommelsesfiler på tværs af repos |

### Inaktive agenter — `AI OS/agents-inaktive/`

Flyttet ud af rosteret 2026-09-05: ingen dokumenteret brug, og hver beskrivelse kostede kontekst i
hver session. Ikke slettet. Genaktivering + advarsel om at efterprøve fakta først: `agents-inaktive/README.md`.

| Fil | Projekt |
|---|---|
| `agents-inaktive/README.md` | Hvorfor de ligger her, og hvordan en tages i brug igen |
| `agents-inaktive/fin-analysis.md` · `fin-patterns.md` · `fin-statistics.md` · `fin-accounting.md` · `fin-data.md` · `fin-database.md` | `DATA-BUDGET_PROGNOSE` |
| `agents-inaktive/inno-hr.md` · `inno-system.md` · `inno-logistics.md` · `inno-mailtemplate.md` | `SYS-INNOMATE` |
| `agents-inaktive/adm-bi.md` | `ADM-BI` |

---

## BI-OEKONOMI — `<OneDrive>\AI SOSU\BI-OEKONOMI\` (repo: [JST-BI/BI-OEKONOMI](https://github.com/JST-BI/BI-OEKONOMI))

Power BI-rapport og semantisk model for HR/økonomi.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: modelarkitektur, DAX/M-konventioner, workflow, gotchas (spejle) |
| `.claude/rules/pbi-workflows.md` | Agent-workflow-mønstre for PBI-arbejde. Læses eksplicit af begge værktøjer — indlæses ikke automatisk. (Fjernet fra `.codex/rules/` 2026-08-20: dén mappe er til Starlark-`.rules`, ikke Markdown) |
| `Rapporter/HR_OEKONOMI/` | Selve rapporten som `.pbip`: `HR_OEKONOMI.SemanticModel/` (TMDL) + `HR_OEKONOMI.Report/` (PBIR) |
| `Input/standards/tmdl-syntaks.md` | TMDL-syntaks og fejlmønstre. Flyttet ud af CLAUDE.md 2026-09-05 — læs FØR enhver TMDL-redigering |
| `Input/standards/power-query-step-naming.md` | Referencestandard for M-step-navngivning (VerbObject-Konkret) |
| `Input/standards/pbir-visual-json.md` | PBIR visual-JSON: farvearkitektur (selector.metadata vs. data), queryGroup-placering, auto-date-time, sourceColumn ved rename, PBIR-struktur og formatering (flyttet fra CLAUDE.md 2026-08-25) |
| `Input/standards/tmdl-integration.md` | Erfaringer ved import af tabeller fra en fremmed TMDL-model: expressions vs. model-tabeller, sanitering, transitive M-afhængigheder (flyttet fra CLAUDE.md 2026-08-25) |
| `Output/tmdl/elevproduktion-integration/README.md` | Dokumentation af elevproduktions-integrationen |
| `tools/spor2-byggeplan.md` | Byggeplan for Spor 2 (Formål-dekomponering af resultatopgørelsen) |
| `tools/bestyrelsestabeller-arbejdsnote.md` | Bestyrelsens to tabeller (økonomi + årselever): skabelonens kolonne-/rækkestruktur, lønandels- og likviditetsdefinition, hybrid-datagrundlaget (JSTs valg 01-09-2026) og alt det målte mod skabelonen |
| `tools/pbi-desktop-cyklus.md` | Selvkørt PBI Desktop-cyklus: luk/åbn via UIA, TMSL-refresh, gem via keystroke, screenshots, disk-cache-fælder (flyttet fra CLAUDE.md 2026-08-25) |
| `tools/pbi-side-foto.ps1` | Fotograferer en rapportside i **begge** tilstande — ufiltreret og med et slicer-valg — og rydder filteret bagefter. Skaffer sig fokus med `AttachThreadInput` **og efterprøver at det lykkedes**: uden fokus fejler `SetForegroundWindow` tavst fra en agent-session, så Escape og klik lander i et andet vindue. Et filter afslørede 2026-09-06 tre fejl der ikke fandtes ufiltreret |
| `tools/z8050-elevside-laeringer.md` | Z8050-elevsiden: unikke elever, frafaldsdefinition, Bullet Chart 2.4.2.0-grænser, variansanalysens gate-læringer (PR #61–#64; flyttet fra CLAUDE.md 2026-08-25) |
| `tools/z8050-deneb-bullets-2026-08-27.patch` | Gemt patch fra parallel session (Deneb-bullets på Z8050-siden, 27-08) — kasseret i produktion (BC er linjen, PR #73); arkiv til reference |
| `tools/deneb-kalender/SÅDAN-GØR-DU.md` | Deneb-kalenderens byggekæde (byg-spec → render-test → embed) + geometri-/testharnisk-læringer |
| `tools/kalender-ansoegere-konceptafklaring.md` | Konceptafklaring for kalender-visual og ansøger-subtotal + de flyttede undersøgelseslogs (L3/Z8005, lokalafdeling, optags-matrix, frakoblet dim) |
| `tools/README-regnskabsforklaring.md` | Dokumentation af regnskabsforklarings-snapshotkæden |
| `tools/snapshot-regnskabsforklaring.ps1` + `snapshot_excel_merge.py` | Scripts til per-konto Forventet-snapshot (Spor 1) |
| `tools/sync-datakilder.ps1` | Spejler modellens datakilder fra Y: til `C:\BI-Data` (robocopy `/MIR`). Læser stierne i DATAKONTROLCENTER + parameteren `$Ekstra` med de fem mapper der kun har eksplicit sti i M-koden |
| `tools/refresh-hr-oekonomi.ps1` | Refresh-rutinen: synkroniserer spejlet, **friskhedskontrollerer** at ingen kilde er nyere på Y: end i spejlet (`-KunKontrol` svarer uden at refreshe), og kører TMSL-refresh i én transaktion med fallback til tabel-for-tabel. `-Only` refresher præcis de navngivne tabeller |
| `tools/dax-udf-forberedelse.md` | Kandidatliste og forberedelse til DAX UDF-migreringer |
| `tools/pq-analyse-og-optimering.md` | Analysenotat: Power Query-optimering og fxSheetImport |
| `tools/R1-spike-Spor2-DvP-findings.md` | Spike-findings for Spor 2 R1 (Drift vs. Projekt) |
| `tools/taxameter-dobbelttaelling-analyse.md` | Analyse af taxameter-dobbelttælling og netting-fix |
| `tools/motor-koncept-diagram.html` | JST-godkendt koncept-diagram: motor-terminologi, dataflow, afløbs-matrix pr. kohorte × regnskabsår, 291-vs-131, roadmap |
| `tools/pptx/sosu_pptx.py` | Fælles PowerPoint-skabelon i skolens visuelle identitet. Palet, skrift og de to logobilleder er **udtrukket** af skolens eget årshjul (`Input/Årshjul - forløbsstart ... .pdf`), ikke opfundet. Rummer to tavse PowerPoint-fælder: `<a:ln>` skal stå før `<a:effectLst>`, og rækkefølgen inde i `<a:ln>` er bindende — ellers kasseres formateringen uden fejl |
| `tools/pptx/byg-aarshjul.py` | Årshjul over forløbsstart med stiplede buede pile for fødekæderne. Følger skolens 4:3-forlæg; ét bevidst afvig: hjulet er en ring, så pilene kan ligge i navet |
| `tools/pptx/byg-foedekaeder.py` | Præsentation om fødekæder og optag: 2026-optagene, de 17 aktive kæder, den direkte indgang pr. hold, elevtyperne, EUX' femårige løb |
| `tools/pptx/byg-dataflow.py` | Præsentation om budgettets dataflow: de fem trin fra kildesystem til rapport, de 68 registrerede datakilder, budgetmotorens 17 rækker |
| `tools/pptx/eksporter-til-png.ps1` | Eksporterer .pptx til PNG for visuel kontrol. **Kopierer altid til et tidsstemplet navn først** — PowerPoint COM cacher på filsti og serverer ellers en gammel udgave uden at fejle |
| `Output/praesentationer/*.pptx` | De tre genererede præsentationer. Genbygges med `python byg-*.py`; redigér generatoren, ikke .pptx-filen |

---

## SYS-INNOMATE — `<OneDrive>\AI SOSU\SYS-INNOMATE\` (repo: [JST-BI/SYS-INNOMATE](https://github.com/JST-BI/SYS-INNOMATE))

Mailskabeloner og procesplaner for onboarding/offboarding via INNOMATE.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: orkestrator-rolle, CPR-regel, merge-felter, workflow (spejle) |
| `.claude/rules/inno-workflows.md` | Agent-workflow-mønstre for INNOMATE-arbejde. Læses eksplicit af begge værktøjer — indlæses ikke automatisk. (Fjernet fra `.codex/rules/` 2026-08-20, se ovenfor) |
| `generate-procesplan-v3.js` (+ `package.json`) | Procesplan-generator (Node.js) |
| `Input/Oprettelse af medarbejder/`, `Input/Nedlæggelse af medarbejder/`, `Input/Generelle skabeloner/` | Kildefiler: procesplaner, INNOMATE-skabeloner, korrespondance |
| `Output/` (samme undermapper) | Genererede skabeloner og procesplaner |

---

## ADM-HÅNDBØGER — `<OneDrive>\AI SOSU\ADM-HÅNDBØGER\` (repo: [JST-BI/ADM-HANDBOOKS](https://github.com/JST-BI/ADM-HANDBOOKS))

Personalehåndbog og Lederhåndbog — afspejler hinandens emner.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: håndbogs-parallelitet, workflow (spejle) |
| `Personalehåndbog/` | Indhold målrettet medarbejdere |
| `Lederhåndbog/` | Samme emner, ledervinkel |
| `Input/` / `Output/` | Kildemateriale hhv. færdige/godkendte versioner |

---

## ADM-ØKONOMI — `<OneDrive>\AI SOSU\ADM-ØKONOMI\` (repo: [JST-BI/ADM-OEKONOMI](https://github.com/JST-BI/ADM-OEKONOMI))

Økonomiske styringsdokumenter.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: dokumentrelationer, workflow (spejle) |
| `Regnskabsinstruks/` | Regler for bogføring, godkendelse, regnskabsaflæggelse |
| `Indkøbspolitik/` | Rammer for indkøb, leverandørstyring, udbudspligt |
| `Strategi for finansiel risiko/` | Risikovurdering, likviditetsstyring, finansielle principper |
| `Input/` / `Output/` | Kildemateriale hhv. færdige/godkendte versioner |

---

## ADM-BI — `<OneDrive>\AI SOSU\ADM-BI\` (repo: [JST-BI/ADM-BI](https://github.com/JST-BI/ADM-BI))

BI governance og styringsdokumenter.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: governance-scope, relation til BI-OEKONOMI (spejle) |
| `Input/` / `Output/` | Kildemateriale hhv. godkendte standarder (normgivende for BI-OEKONOMI) |

---

## DATA-BUDGET_PROGNOSE — `<OneDrive>\AI SOSU\DATA-BUDGET_PROGNOSE\` (repo: [JST-BI/DATA-BUDGET_PROGNOSE](https://github.com/JST-BI/DATA-BUDGET_PROGNOSE))

Finansiel analyse, budget og prognose (Navision + BRUGER-budget/prognose → .xlsx).

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: datakilder, formålskoder, fin-agent-routing (spejle) |
| `Input/` | Rådata: Navision-finansposter, budget, prognose, finanslov, årsrapporter (gitignored) |
| `Output/` | .xlsx-leverancer med danske formater (rene leverancer må committes) |

---

## ADM-KANTINE — `<OneDrive>\AI SOSU\ADM-KANTINE\` (repo: [JST-BI/ADM-KANTINE](https://github.com/JST-BI/ADM-KANTINE))

Kantinens menukort (tilrettede udgaver af leverandørens ugemenu) og de ugentlige bestillingssedler til Jespers Torvekøkken og Bilkas bageri.
**Bemærk**: `Input/`s PDF'er committes her (små, persondatafrie = dokumentation for hvert ugekort). `.gitattributes` sætter `*.pdf binary`.
Mailmapperne under `Input/` og `Output/Bestillinger/` er derimod gitignored — de indeholder navne, mobilnumre og e-mailadresser.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: kilder, filnavngivning, ugentlig arbejdsgang (spejle) |
| `tools/hent-portionsanretning.py` | Henter kilde-PDF'en fra torvekoekken.dk når den ikke allerede ligger i `Input/` — regex på knappens `onClick`-attribut i den rå HTML, ingen browser nødvendig; vælger altid den danske "Uge `<N>`"-knap, ikke den engelske |
| `tools/byg-ugekort.py` | Generator: bygger `Output/Kantine Ugekort <uge>.pdf` (kun FAVORIT + stående Bowl+Sandwich-tilbud). Auto-skalerer dagsblokkene så de aldrig løber ned over allergen-footeren — kræver `reportlab` |
| `tools/test-layout.py` | Layout-værn: tjekker ugens indhold + et værre tilfælde, med negativ kontrol der kræver at et fast layout faktisk overlapper |
| `Input/<uge>_Aarhus_Portion.pdf` | Leverandørens portionsanretning, 5 sider (FAVORIT, Vegetar, Vegansk, Halal, Gluten/laktosefri) |
| `Input/Kantine - Prisskilt.pdf` | Kantinens prisskilt (bagværk, frokost, drikkevarer) — kilde til Bowl- og Sandwich-prisen |
| `Output/Kantine Ugekort <uge>.pdf` | Ugens menukort til opslag — kun FAVORIT-retten pr. dag |
| `tools/lav-muah-seddel.py` | Generator: udfylder MUAH-udfyldningssedler til Bilkas bagerudsalg ud fra en JSON-liste og en tidligere seddel som skabelon — kræver `python-docx` |
| `Output/Kantine - Prisskilt.pdf` | Prisskilt klar til opslag |

---

## BI-OPGAVEOVERSIGT — `<OneDrive>\AI SOSU\BI-OPGAVEOVERSIGT\` (repo: [JST-BI/BI-OPGAVEOVERSIGT](https://github.com/JST-BI/BI-OPGAVEOVERSIGT))

Power BI-rapport: medarbejderes opgaveoversigt mod arbejdstidsnorm. Kilde: Budgetskema.xlsx på SharePoint + Studie+-udtræk (Z8004, Z8082).

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: datamodel, ShowRow-grain, normvarianter, rapportfiltre, PBI-/refresh-arbejdsgang (spejle) |
| `Power BI - Opgaveoversigt - Ledere.pbip` | PBIP-projektfil |
| `…SemanticModel/definition/tables/` | `DB Budget underviser og SPS medarbejder.tmdl` (fakta + alle målere), `Arbejdstidsnorm.tmdl`, `L-Kalender.tmdl` |
| `…SemanticModel/definition/expressions.tmdl` | M-queries, bl.a. `UV Medarbejder` og `Støtte Medarbejder` (normvarianterne) |
| `…Report/definition/pages/` | Siderne `Opgaveoversigt - Ledere` og `Forklaring på blokke` |

---

## BI-OPTAG FRAVÆR — `<OneDrive>\AI SOSU\BI-OPTAG FRAVÆR\` (lokalt repo, intet GitHub-remote)

Power BI-rapport: elevoptag og skoleforløbsfravær. Kilde: Studie+-udtræk `Z8312` (alle holdplaceringer) og `Z8224S` (skoleforløbsfravær). Bragt under AI-styring 2026-08-20.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: datagrundlag, målergrupper, agentbrug, skærpet persondata-opmærksomhed (spejle) |
| `SOSU BI OPTAG FRAVÆR.pbip` | PBIP-projektfil |
| `…SemanticModel/definition/tables/` | Målergrupper (`#Measures - ELEV/HRLØN/KPI/TEMATIK/ØKONOMI`), `L-Kalender`, `L-STU Dim…`-dimensioner, `L-STU Fact Z8224S…` |
| `.codex/config.toml` | Codex-projektkonfiguration |

---

## ADM-AFTALER — `<OneDrive>\AI SOSU\ADM-AFTALER\` (lokalt repo, intet GitHub-remote)

Samarbejds- og samhandelsaftaler med eksterne parter. Bragt under AI-styring 2026-08-20. `Input/` er gitignored som forsigtig standard: aftaler indeholder navne og underskrifter, og fortrolighedsniveauet er ikke afklaret.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: versionssammenligning af aftaletekst, juridisk forbehold, persondata (spejle) |
| `.codex/config.toml` | Codex-projektkonfiguration |

---

## ADM-BLANKET — `<OneDrive>\AI SOSU\ADM-BLANKET\` (lokalt repo, intet GitHub-remote)

Administrative blanketter og formularer (i dag kørselsbemyndigelser). Bragt under AI-styring 2026-08-20. `Input/` er gitignored: blanketterne er personhenførbare af natur.

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: blanketstruktur, skærpet persondata-advarsel mod `--no-verify` (spejle) |
| `.codex/config.toml` | Codex-projektkonfiguration |

---

## ADM-RETTIGHEDSSTYRING — `<OneDrive>\AI SOSU\ADM-RETTIGHEDSSTYRING\` (lokalt repo, intet GitHub-remote)

Rettighedsstyring på Y:-drevet (`\\sosurdata.net.local\Groups$\Ansatte`): ACL- og
gruppemedlemsudtræk → adgangsoversigter ("hvem har adgang til hvilken mappe", og omvendt
"hvilke mapper har denne person adgang til"). Bragt under AI-styring 2026-09-07.
`Input/` og `Output/` er begge gitignored i deres helhed — persondataholdige, se `CLAUDE.md`
→ *Persondata*. Deling af `Output/`-leverancer: kun JST (besluttet 2026-09-07).

| Fil | Beskrivelse |
|---|---|
| `CLAUDE.md` / `AGENTS.md` | Projektregler: datamodel (ACL-join, indlejrede grupper), persondataregler, workflow (spejle) |
| `Input/Fællesdrev/udtræk sikkerhedsgrupper.xlsx` | ACL-udtræk: mappe → sikkerhedsgruppe → rettighed (gitignored) |
| `Input/Fællesdrev/Udtræk medlemmer.xlsx` | Gruppemedlemskab: gruppe → medlem (navn, e-mail m.m.) — persondata (gitignored) |
| `tools/byg-rettighedsoversigt.py` | Genbygger Output-oversigten fra de to udtræk; udleder snapshot-dato fra ACL-arkets titel |
| `Output/Rettighedsoversigt Y-drev (data 2026-03-31).xlsx` | Genereret adgangsoversigt: pr.-mappe, pr.-gruppe, detaljeret medlemsliste, pr.-person-oversigt og pr.-person-detalje — persondata (gitignored) |

---

## Fælles på tværs af alle 13 repos

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

**13 repos** = AI OS + 12 projekter. Fire af dem (`BI-OPTAG FRAVÆR`, `ADM-AFTALER`, `ADM-BLANKET`, `ADM-RETTIGHEDSSTYRING`) har lokale git-repos uden GitHub-remote, indtil fortrolighedsniveauet er afklaret med JST.

**Bemærk (kun Claude Code)**: Claude Codes persistente hukommelse ligger lokalt under `~/.claude/projects/<AI OS-projekt>/memory/` med eget indeks `MEMORY.md` — den er personlig, ikke versionsstyret og ikke en del af repo-strukturen.
