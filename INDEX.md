# INDEX.md — samlet filindeks (SOSU Randers AI-økosystem)

> `<OneDrive>` = `C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers` (arbejdskopier); `Y:\AI OS` / `Y:\AI SOSU` er delte kopier til kollegerne.

> **Formål**: Ét opslagssted for alle styrede filer på tværs af AI OS og de 14 projekter (13 i AI SOSU + Second Brain).
> **Vedligehold**: Opdatér dette indeks når filer tilføjes, fjernes eller omdøbes i ethvert repo (se Selvvedligehold i `AGENTS.md`).
> **Instruktionsfil**: I alle repos er `AGENTS.md` den eneste instruktionsfil (uafhængig af AI-model); Codex og Claude Code (≥ v2.1.277) læser den direkte, og der må ingen `CLAUDE.md`, `CLAUDE.local.md` eller `.claude/CLAUDE.md` findes (de får Claude Code til at ignorere `AGENTS.md`). `tools/sync-agents-md.ps1` melder og fjerner dem; `.githooks/check_kun_agents_md.py` håndhæver det ved commit. **Review**: hvert repo har `REVIEW.md` (review-instruktioner), som `AGENTS.md` importerer med `@REVIEW.md`, så også lokal `/code-review` følger den; fælles skabelon `tools/review-skabelon.md`. **Skills** samme princip: `.agents/skills/` er eneste kilde, `.claude/skills/` et spejl skrevet af `tools/sync-skills.ps1`; `.githooks/check_skills_mirror.py` håndhæver det.
> **Obsidian**: Vault-roden er `<OneDrive>\AI OS\`. De fysiske projektfiler ligger separat og kanonisk i `<OneDrive>\AI SOSU\`; der findes ingen junction eller særskilte Obsidian-kopier af projektfilerne.
> **Stier**: AI OS ligger i `<OneDrive>\AI OS\`, og alle arbejdsprojekter ligger i den separate kanoniske projektrod `<OneDrive>\AI SOSU\`.
> Rådata i projekternes `Input/`-mapper (xlsx/pdf m.m.) er gitignored og indekseres ikke enkeltvis — **undtagen `ADM-KANTINE`**, hvor de små, persondatafrie menu-PDF'er committes.

---

## AI OS — `AI OS/` (repo: [JST-BI/AI-OS](https://github.com/JST-BI/AI-OS))

Infrastruktur: agentdefinitioner, AI-konfiguration, fælles værktøjer.

| Fil | Beskrivelse |
|---|---|
| `AI OS/AGENTS.md` | Overordnede agentregler: startkontrol, routing, sikkerhedsregler, datagovernance, TMDL/PBIR-gotchas |
| `AI OS/REVIEW.md` | Review-instruktioner (Important/Nit/Pre-existing); importeret i `AGENTS.md` med `@REVIEW.md` |
| `AI OS/tools/review-skabelon.md` | Fælles skabelon for `REVIEW.md` i alle repos; projektets egne regler tilføjes nederst |
| `AI OS/INDEX.md` | Dette indeks |
| `AI OS/.claude/skills/` + `AI OS/.agents/skills/` (obsidian-skills) | Kepanos Obsidian-skills til Claude Code og Codex (kopier, ikke symlinks): `obsidian-markdown`, `obsidian-bases`, `json-canvas`, `obsidian-cli`, `defuddle`, `knap`. Kilde og hashes i `AI OS/skills-lock.json`; opdatér med `npx skills update -p` |
| `AI OS/docs/agents/` | Konfiguration for Matt Pococks engineering-skills: `issue-tracker.md` (GitHub Issues, persondataforbud), `triage-labels.md` (fem standardlabels), `domain.md` (single-context: `GLOSSARY.md` + `docs/adr/` oprettes ved brug) |
| `AI OS/tools/setup-new-repo.ps1` | Opsætning af nyt repo: begge pre-commit hooks, `.gitattributes`, `.codex/config.toml`, `core.hooksPath` |
| `AI OS/tools/session-start-kontrol.ps1` | Deterministisk session-startkontrol (SessionStart-hook): instruktionsfiler, rodrenhed, INDEX.md, projektfiler. Tavs ved succes |
| `AI OS/tools/codex-opsaetning.md` | Codex på en ny maskine: trust, `project_doc_max_bytes`, hooks, `.codex/rules/`. Flyttet ud af AGENTS.md 2026-09-05 |
| `AI OS/tools/sync-agents-md.ps1` | Sikrer at `AGENTS.md` er eneste instruktionsfil: sletter gamle `CLAUDE.md`-pegefiler; `-Check` melder enhver CLAUDE-variant, også over projekterne (exit 1) |
| `AI OS/tools/sync-skills.ps1` | Spejler `.agents/skills/` (kilden) til `.claude/skills/` og til `~\.claude\skills\` (brugerniveau, kun mapper på listen `.ai-os-skills`, så `/aflever` m.fl. virker uden for AI OS); `-Check` rapporterer drift (exit 1, kaldes af sessionsstartkontrollen); `-UdenBruger` springer brugerspejlet over |
| `AI OS/tools/test-sync-skills.ps1` | Test af brugerspejlet i en syntetisk `%TEMP%`-mappe: spejl, sammenstød med personlig skill/junction, grøn Check, drift, oprydning, `-UdenBruger` |
| `AI OS/tools/udgiv-til-y.ps1` | "Udgiv": spejler `<OneDrive>\AI OS` → `Y:\AI OS` og ff-puller `Y:\AI SOSU\<repo>` fra GitHub (kollegernes kopier) og spejler FB <år>-mappen til `Y:\Økonomi\Økonomistyring\FB <år>`; skill `/udgiv` |
| `AI OS/.agents/skills/udgiv/SKILL.md` | Skill bag kodeordet "Udgiv" (spejl i `.claude/skills/`) |
| `AI OS/tools/udgiv-opsaetning.ps1` | "Udgiv opsætning": samler alle skills (AI OS, projekter, personlige) og JSTs indstillinger i VS Code, Claude Code og Codex i `<OneDrive>\AI OS\AI-SETUP` (gitignoreret) → `Y:\AI OS\AI-SETUP`; licensfilter, stiomskrivning, stop ved nøgle/CPR/e-mail; `-Proev` |
| `AI OS/tools/test-udgiv-til-y.ps1` | Værn for `udgiv-til-y.ps1` trin 2b: en gitignoreret fil med æøå i navnet skal nå Y: også fra en løsrevet `powershell.exe` (tegnsæt 850) – falsk OneDrive/Y: i `%TEMP%` |
| `AI OS/tools/test_udgiv_til_y.ps1` | Værn for `udgiv-til-y.ps1`: nyere Y:-fil (AI SOSU og AI OS) overskrives ikke, hashfejl og ADM-BESPARELSER/Grundlag på Y: giver `FEJL`, lokale ændringer på Y: stopper repoet (ingen stash), robocopy ≥ 8/ikke-ff/afvist ff giver exit ≠ 0 + `UDGIV FEJL`, Y: følger altid `main` (også ved kloning, origin bevares), forældede filer i AI SOSU meldes, `$IkkePaaYStier` gælder hvert FB-år, æøå-stier i "nyere/kun på Y:" forvanskes ikke (tegnsæt 850 og 65001); falske OneDrive/Y:/GitHub under `C:\Temp\udgiv-test`; `-Script` kører mod en gammel udgave |
| `AI OS/tools/test-udgiv-opsaetning.ps1` | Værn for `udgiv-opsaetning.ps1`: planter nøgle, CPR, e-mail, personlig sti, låst licens og junction én ad gangen og kræver stop/udeladelse |
| `AI OS/.agents/skills/udgiv-opsaetning/SKILL.md` | Skill bag kodeordet "Udgiv opsætning" + `assets/LAESMIG-skabelon.md` (kollegernes vejledning; spejl i `.claude/skills/`) |
| `AI OS/.agents/skills/aflever/SKILL.md` | Skill bag kodeordet "Aflever": sikr, bogfør, merge (JST vælger), ff kloner + INDEX, udgiv, ryd op, rapport (spejl i `.claude/skills/`) |
| `AI OS/.agents/skills/vis-mig/SKILL.md` | Skill bag kodeordet "Vis mig": teknisk dokumentation som artefakt-side på dansk efter ASD-STE100-principperne, for lægfolk, tekst + grafik (spejl i `.claude/skills/`) |
| `AI OS/.agents/skills/vis-mig/references/ste-dansk.md` | STE100-reglerne oversat til dansk skrivepraksis: ord, sætningslængde, aktiv form, trin, advarsler, foretrukne ord, fy-liste |
| `AI OS/.agents/skills/vis-mig/scripts/ste_tjek.py` | Tjek af en færdig side: for lange sætninger, fy-ord, s-passiv i trin, lange ord, uforklarede forkortelser, figurer uden billedtekst |
| `AI OS/.agents/skills/vis-mig/evals/` | Tre testcases (byggekæden, slutkontrollen, BI_SOSU-datafilerne) med 7 kriterier hver |
| `AI OS/.agents/skills/pause/SKILL.md` | Fælles kommando "pause": lokal gemning, hashverificeret backup, genoptagelsesnotat og stop (spejl i `.claude/skills/`); henvises fra alle 13 projekters AGENTS.md |
| `AI OS/tools/codex-config.template.toml` | Kanonisk skabelon for projekternes `.codex/config.toml` |
| `AI OS/tools/dax-query.ps1` | Genbrugeligt live-DAX-query-værktøj mod PBI Desktops indlejrede msmdsrv; persondatavagten vurderer altid queryen før kørsel; `-LokalBehandling` slår den fra for scripts der aggregerer lokalt |
| `AI OS/tools/dax-persondata-vagt.py` | Persondatavagt (TypeSafe/Jev, fastlåst `jev-1.13.0`): pass/review/block for en DAX-query ud fra modellens personkolonner; `--selftest` |
| `AI OS/tools/dax-persondata-vagt.cases.json` | Regressionssæt til `--selftest`: 40 queries + 59 kolonnenavne med facit (kun kode/navne, ingen data) |
| `AI OS/tools/jev-undersoegelse-2026-10-17.md` | Arbejdsnote: hvor Jev kan erstatte skrøbelig parsing i AI OS — eksperimenter, tal og afviste kandidater |
| `AI OS/tools/validate-tmdl.ps1` | Offline TMDL-validering med PBI's egen TOM-deserializer — pre-flight-gate før PBI-åbning |
| `AI OS/tools/tmdl-krydsreferencer.py` | Tjekker queryGroup-erklæringer, `ref table` ↔ filer, at `sortByColumn`/hierarkiniveauer/relationsender peger på kolonner der findes (13-10-2026), og dublerede lineageTags — den klasse `validate-tmdl.ps1` strukturelt ikke kan se |
| `AI OS/tools/tmsl-refresh.ps1` | Tabel-scoped TMSL-refresh mod kørende PBI Desktop-instans (undgår fuld model-refresh) |
| `AI OS/tools/pbi-reopen.ps1` | Genåbner HR_OEKONOMI.pbip i en kørende "Untitled" PBI Desktop via UIA-recents (kold genstart-cyklus) |
| `AI OS/tools/pbi-screenshot.ps1` | Vælger rapportfane via UIA, lukker backstage, søger fejltekster og gemmer PrintWindow-screenshot |
| `AI OS/.githooks/pre-commit` | Versioneret pre-commit hook; kalder begge checks nedenfor (findes i alle 15 repos) |
| `AI OS/.githooks/check_excel_pii.py` | Blokerer commit af Excel med persondata (CPR/e-mail/navnekolonner) |
| `AI OS/.githooks/check_kun_agents_md.py` | Blokerer commit af `CLAUDE.md`, `CLAUDE.local.md` og `.claude/CLAUDE.md` |
| `AI OS/.githooks/check_skills_mirror.py` | Blokerer commit hvor `.claude/skills/` afviger fra kilden `.agents/skills/` (git-index, blob-hash) |
| `AI OS/.githooks/README.md` | Aktivering af hooks efter clone (findes i alle 15 repos) |
| `AI OS/.claude/` | Claude Code-indstillinger |
| `AI OS/.agents/skills/pbi-live-maaling/SKILL.md` | Skill (spejl i `.claude/skills/`): live DAX-måling mod kørende PBI Desktop — port-opdagelse, ADOMD, aggregat-only-regel, gotchas |
| `AI OS/.agents/skills/reverse-engineering-tal/SKILL.md` | Skill (spejl i `.claude/skills/`): reverse engineering af vedtagne/rapporterede tal — frys facit, proveniens og beslutningshistorik før rettelse, konkurrerende hypoteser testet mod ejerens facit, bevist vs. konsistent, forlæns verifikation |
| `AI OS/.codex/config.toml` | Codex-konfiguration (TOML). Hæver `project_doc_max_bytes`, sætter sandkasse og AGENTS.md-fallback. Erstattede 2026-08-20 en virkningsløs `.Codex/settings.json` i Claude Codes JSON-format |
| `AI OS/.obsidian/` | Stabil Obsidian-konfiguration for vaulten med `AI OS/` som rod; maskinspecifik `workspace*.json` og cache er gitignored. `app.json`/`daily-notes.json`/`templates.json` dirigerer nye noter til `vault/` — uden dem skrev daily-notes-pluginet i roden |
| `AI OS/vault/` | De frie Obsidian-noter (`inbox/`, `journal/`, `notes/{,people,decisions}/`, `meetings/`, `resources/`, `_templates/`, `_attachments/`). Adskilt fra de styrede filer — se AGENTS.md → *Obsidian-vaultregler* |
| `AI OS/vault/AGENTS.md` | Obsidian-notereglerne (frontmatter, routing, index-vedligehold, AI_ACTION_METADATA). Flyttet ud af AI OS-roden 2026-09-05 — de gælder kun filer under `vault/` (spejle) |
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
| `agents/pbi-m-optimering.md` | M-optimering uden outputændring: én delt kæde frem for kopi-pasta'ede kæder, Buffer på flerfoldige referencer, fjern dødt arbejde; figur-eksakt verifikation pr. query (13-10-2026) |
| `agents/pbi-dataflow.md` | Tværgående dataflow/ETL-arkitekt: afhængighedskort, dobbelt-parsning, afledte dimensioner vs. fakta, mål-arkitektur og migreringsrækkefølge med før/efter-kontrol pr. skridt (13-10-2026) |
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
| `tools/typesafe-research/` | Syntetiske Jev-forsøg: API-runner, offline genberegning, forslagspolitik med tests og M-regex-diagnose |
| `Output/reviews/typesafe-2026-10-17/` | Resultatrapport, 36 syntetiske cases, 72 API-svar, optællinger, kildeinventar og SHA-256-manifest |
| `AGENTS.md` | Projektregler: modelarkitektur, DAX/M-konventioner, workflow, gotchas |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `docs/agents/` | Konfiguration for Matt Pococks engineering-skills: `issue-tracker.md` (GitHub Issues, persondataforbud), `triage-labels.md` (fem standardlabels), `domain.md` (single-context: `GLOSSARY.md` + `docs/adr/` oprettes ved brug) |
| `.claude/rules/pbi-workflows.md` | Agent-workflow-mønstre for PBI-arbejde. Læses eksplicit af begge værktøjer — indlæses ikke automatisk. (Fjernet fra `.codex/rules/` 2026-08-20: dén mappe er til Starlark-`.rules`, ikke Markdown) |
| `Rapporter/HR_OEKONOMI/` | Selve rapporten som `.pbip`: `HR_OEKONOMI.SemanticModel/` (TMDL) + `HR_OEKONOMI.Report/` (PBIR), inkl. årsværkskort/periodeetiket og gyldige Drift-bookmarks pr. kaldeside (15-10-2026) |
| `Input/standards/tmdl-syntaks.md` | TMDL-syntaks og fejlmønstre. Flyttet ud af AGENTS.md 2026-09-05 — læs FØR enhver TMDL-redigering |
| `Input/standards/power-query-step-naming.md` | Referencestandard for M-step-navngivning (VerbObject-Konkret) |
| `Input/standards/pbir-visual-json.md` | PBIR visual-JSON: farvearkitektur (selector.metadata vs. data), queryGroup-placering, auto-date-time, sourceColumn ved rename, PBIR-struktur og formatering (flyttet fra AGENTS.md 2026-08-25) |
| `Input/standards/tmdl-integration.md` | Erfaringer ved import af tabeller fra en fremmed TMDL-model: expressions vs. model-tabeller, sanitering, transitive M-afhængigheder (flyttet fra AGENTS.md 2026-08-25) |
| `Output/tmdl/elevproduktion-integration/README.md` | Dokumentation af elevproduktions-integrationen |
| `tools/spor2-byggeplan.md` | Byggeplan for Spor 2 (Formål-dekomponering af resultatopgørelsen) |
| `tools/bestyrelsestabeller-arbejdsnote.md` | Bestyrelsens to tabeller (økonomi + årselever): skabelonens kolonne-/rækkestruktur, lønandels- og likviditetsdefinition, hybrid-datagrundlaget (JSTs valg 01-09-2026) og alt det målte mod skabelonen |
| `tools/pbi-desktop-cyklus.md` | Selvkørt PBI Desktop-cyklus: luk/åbn via UIA, TMSL-refresh, gem via keystroke, screenshots, disk-cache-fælder (flyttet fra AGENTS.md 2026-08-25) |
| `tools/pbi-side-foto.ps1` | Fotograferer en rapportside i **begge** tilstande — ufiltreret og med et slicer-valg — og rydder filteret bagefter. Skaffer sig fokus med `AttachThreadInput` **og efterprøver at det lykkedes**: uden fokus fejler `SetForegroundWindow` tavst fra en agent-session, så Escape og klik lander i et andet vindue. Et filter afslørede 2026-09-06 tre fejl der ikke fandtes ufiltreret |
| `tools/z8050-elevside-laeringer.md` | Z8050-elevsiden: unikke elever, frafaldsdefinition, Bullet Chart 2.4.2.0-grænser, variansanalysens gate-læringer (PR #61–#64; flyttet fra AGENTS.md 2026-08-25) |
| `tools/z8050-deneb-bullets-2026-08-27.patch` | Gemt patch fra parallel session (Deneb-bullets på Z8050-siden, 27-08) — kasseret i produktion (BC er linjen, PR #73); arkiv til reference |
| `tools/deneb-kalender/SÅDAN-GØR-DU.md` | Deneb-kalenderens byggekæde (byg-spec → render-test → embed) + geometri-/testharnisk-læringer |
| `tools/kalender-ansoegere-konceptafklaring.md` | Konceptafklaring for kalender-visual og ansøger-subtotal + de flyttede undersøgelseslogs (L3/Z8005, lokalafdeling, optags-matrix, frakoblet dim) |
| `tools/README-regnskabsforklaring.md` | Dokumentation af regnskabsforklarings-snapshotkæden |
| `tools/snapshot-regnskabsforklaring.ps1` + `snapshot_excel_merge.py` | Scripts til per-konto Forventet-snapshot (Spor 1) |
| `tools/sync-datakilder.ps1` | Spejler modellens datakilder fra Y: til `C:\BI-Data` (robocopy `/MIR`). Læser stierne i DATAKONTROLCENTER + parameteren `$Ekstra` med de fem mapper der kun har eksplicit sti i M-koden. Gemmer forrige version af mapperne i `$GemForrige` (Z8050, Z8050V, Z8312) i `C:\BI-Data-forrige` og arkiverer `$Arkiver` (Z8050, Z8050V, Z8112, Z8312) dateret i `C:\BI-Data-arkiv` |
| `tools/gem-forrige-version.ps1` | Kaldes af sync: spejler det nuværende spejl til `C:\BI-Data-forrige\<sti>`, når `robocopy /L` melder en ændring (én generation). Bruges til at måle registreringsforsinkelse; udtræk på Y: overskrives uændret |
| `tools/test-gem-forrige-version.ps1` | Test af `gem-forrige-version.ps1` på midlertidige mapper (6 tilfælde) |
| `tools/arkiver-udtraek.ps1` | Kaldes af sync efter spejlingen: gemmer en dateret kopi (`C:\BI-Data-arkiv\<sti>\<udtræksdato>`) når indholdet har ændret sig (manifest med sha256; intet slettes). Grundlag for scenariemotorens backtest "som på D" (JST 27-10-2026) |
| `tools/test-arkiver-udtraek.ps1` | Test af `arkiver-udtraek.ps1` på midlertidige mapper (9 tilfælde) |
| `tools/refresh-hr-oekonomi.ps1` | Refresh-rutinen: synkroniserer spejlet, **friskhedskontrollerer** at ingen kilde er nyere på Y: end i spejlet (`-KunKontrol` svarer uden at refreshe), og kører TMSL-refresh i én transaktion med fallback til tabel-for-tabel. `-Only` refresher præcis de navngivne tabeller |
| `tools/afstem-kilde.ps1` | **Kontrollerer modellen op mod kildefilerne** (JSTs regel 2b, 08-09-2026). Tre kontroller, kun aggregater i output: er spejlet bagud i forhold til Y:, ligger der TEMP-ark i datakilderne, og er Z8050's raadata-ark identisk med modellen (distinkte cpr + sum af `bidrag_i_maaned`). Kontrol 1 overlapper `refresh-hr-oekonomi.ps1 -KunKontrol`; det nye er 2 og 3 |
| `tools/tjek-datakilde-afhaengigheder.py` | **Kontrol af afhængighedslisterne bag kontrolcenterets tilstand `Ingen`** (13-10-2026): beregner for hver afledt import-tabel den transitive lukning af datakilde-numre (uden DIM-kilder) fra TMDL/M og sammenligner med `fxDatakildeRaekkerAfhaengig({…}, …)` i partitionen; exit 1 ved afvigelse, `--skriv` retter. Kontrol 2 fanger et genopstået `Folder.Files(fxDatakildeSti(n))`, som omgår `Ingen`. Kør efter enhver ændring i en partition/expression der læser en kilde |
| `tools/afstem-navision-resultat.py` | **Offline-afstemning af resultatet mod Navision** (JST 10-11-2026: Balance + Finansposter med dimensioner er facit, øre-præcist): resultat pr. år fra finansposterne med modellens filter (`>=` startdato, Fixed Decimal) mod Balance linje 299999; genskaber også den gamle vej (Int64, `>`). Kun konto, år, antal og beløb i output |
| `tools/scenariemotor/fejlliste_skoleforloeb.py` + `tests/test_fejlliste.py` | Fejllisten til Elevadministrationen over Studie+-skoleforløbskoder uden gyldig nøglestart (prioritet P1/P2; `Output\Datakvalitet\Studie+ skoleforløbskoder til rettelse <dato>.xlsx`, gitignoreret) (PR #136) |
| `tools/scenariemotor/tests/test_optag_population.py` | Optagets population som M: kun hold med gyldig numerisk nøglestart; eksplicit `STARTDATO_RETTELSER` (= `fxSkoleforloebRettelse`), invarians- og drifttests (PR #136) |
| `tools/m-test/stu-scn/tables/STU-SCN-*.tmdl` (+ `README.md`, `sti.ps1`) + `SCN-*`/`fxSCN_*` i `Rapporter/HR_OEKONOMI/…/definition/expressions.tmdl` | **M-motoren (plan 3, BI-OEKONOMI #157, 16-11-2026):** Python-scenariemotoren porteret til Power Query – 19 skjulte tabeller i query-gruppen `STU\SCN` (Scenarier, Kilder, Hold, Tidslinje, HoldAttr, Profil, Retention, FaertaAndel, Optagsark, OptagPlads, Modelhold, Skabelon, Kendte, Afloeb, Aktivitet, RetentionMotor, TakstOpslag, Beloeb, Taellere). **Tabellerne ligger UDEN FOR modellen (#159/#160, 17-11-2026):** i modellen gav de 19 tomme tabeller banneret "Refresh now", som indlæste dem alle (ikke færdig efter 87 min.). `scn_tom.ps1` lægger dem ind i testdatabasen; en tabel flyttes først ind i `definition/tables/` i den PR, der tager den i brug (værn: `test_m_gate.UdenForModellenTest`). Ny datakilde 165 (optagsarket) i DATAKONTROLCENTER |
| `tools/m-test/afstem_alle.ps1` | Samlet afstemning af M-motoren mod Python-eksporten: hver STU-SCN-tabel refreshes i sin egen friske, tomme PBI-instans og afstemmes straks (22 trin; 16-11-2026: 0 afvigelser, 21,7 min.). `-Facit <eksportmappe> -Arbejdsbog <bog> -Optagsark <ark> [-FortsaetVedFejl]`. Lukker kun instanser med vinduestitlen Untitled |
| `tools/m-test/scn_tom.ps1` | Indlæser HR_OEKONOMI-TMDL som midlertidig database `HR_SCN_test` i en tom Power BI Desktop (PBI's egen TOM) og refresher de nævnte tabeller (`-Tabeller 'A,B'`, `-Behold`, `-Samlet`, `-FastCombine`, `-LukPBI`); port i `%TEMP%\m-test-scn\port.txt`. Målevej uden åben .pbip – brug en frisk instans pr. måling (en brugt instans holder hukommelsen og bliver langsom) |
| `tools/m-test/skoleforloeb_startdato.ps1` + `skoleforloeb_startdato_facit.py` | Kører M-funktionen `fxSkoleforloebStartdato` fra TMDL i tom PBI-instans mod Pythons `hold`-regel (århundredeskift 49; #138/#153) |
| `tools/scenariemotor/afstem_m.py` + `m_afstemning/*.dax` | Afstemning pr. trin: `--trin <t> --python <eksport>\<t>.csv --port <p> --database HR_SCN_test --arbejdsbog <bog> --optagsark <ark>`; nøgle for nøgle (1e-6), kontrolsummer, sha-binding af bog/ark/takster; læser dansk decimalkomma fra dax-query. 22 trin (`TRIN`), én `.dax` pr. trin |
| `tools/scenariemotor/scenariemotor/eksport.py` | `koer.py eksport --scenarie Prognose --horisont 2036 --arbejdsbog … --optagsark … --ud <mappe>`: motorens mellemresultater som CSV (hold, tidslinje, holdattr, profil_trin, retention(_alle), faerta_andel, optagsark_celler, optag_plads, modelhold, skabelon(_kilde), kendte, afloeb, aktivitet, beloeb, takst_opslag, kilder, taellere) – facit for M-motoren; kun læsning (aktivitet.csv/beloeb.csv byte-identiske med en motorkørsel) |
| `docs/superpowers/plans/2026-10-26-plan3-m-motor-stu-scn.md` + `2026-11-15-plan3-revision.md` + `…-plan3-ledger.md` + `2026-11-01-plan3-drift.md` | Plan 3 (M-motoren): opgaver T0–T9, beslutninger D1–D30, valg V1–V9, ledger og driftsnoter |
| `tools/scenariemotor/scenariemotor/optagsark.py` (samlet layout) + `gennemfoerelse.py` + `overgang.py` + `tests/test_samlet_ark.py`, `test_gennemfoerelse.py`, `test_overgang.py`, `test_startede_hold.py` | **Det samlede ark (BI-OEKONOMI #161, 18-11-2026):** ét forudfyldt ark `BRUGER - Optag og gennemførelse 2027-2036.xlsx` med elever og gennemførelse pr. optag × elevtype × startmåned (Tilstand Historisk/Egen/0; "0" = ingen gennemfører, JST 18-11), fanerne "Overgang GF2-HF" (Δ = andel × (N′·g′/g_grund − N_grund), kun ændringen flyder videre; EUX-delen på ordinær HF efter 31-08-2026) og "Startede hold" (rest-gennemførelse af nuværende elever). `koer.py optagsark --ud-samlet <ny> [--konverter <gammelt>] [--kaedeliste <tmdl>]`; `beregn` skriver `optagsark-anvendt.xlsx`, `gennemfoerelse.csv`, `overgang.csv`, `startede_hold.csv`. Urørt ark = byte-identiske tal. Produktionen læser stadig det gamle ark. l51 er en indpakning om `overgang.py` |
| `tools/m-test/stu-scn/tables/STU-SCN-Gennemfoerelse/-Overgang/-StartedeHold.tmdl` + `SCN-SamletArk`, `SCN-SamletArkPladser`, `SCN-Overgang`, `fxSCN_Omregning` + `m_afstemning/gennemfoerelse.dax`, `overgang.dax`, `startede_hold.dax` + `tests/test_m_samlet_ark.py` | M-porten af det samlede ark (#161): afstemt mod Python på urørt ark, prøveark med 10 egne valg og gammelt format – 25 trin, 0 afvigelser |
| `tools/scenariemotor/m_afstemning/aktivitet_maaned.dax` | Afstemningstrin `aktivitet_maaned`: faktisk aktivitet pr. bidragsmåned (BI-OEKONOMI #178, 20-11-2026). Samme PR: trin med 0 nøgler fejler (kun `overgang` må være tomt, og kun når eksportens tællere bekræfter det); `afstem_alle.ps1 -Kun` med ukendt tabelnavn stopper før Power BI |
| `tools/tjek-dax-datoer.py` | Statisk kontrol af HR_OEKONOMI-målerne: "Årselever (20xx)" låst til sit eget år (årsfilter, `REMOVEFILTERS`, `TREATAS` på Månedsnr), "sidste år"-målerne korrekte i januar, kontonumre som tekst (BI-OEKONOMI #179, 20-11-2026) |
| `docs/superpowers/plans/2026-11-17-samlet-ark.md` + `docs/superpowers/specs/2026-11-17-tillaeg-samlet-ark.md` | Plan og regelfacit for det samlede ark (JST 17-11: "den rigtige løsning"; trin 7–8 FB-kæden og siderne på grenen `feat/samlet-ark`) |
| `tools/rapport-krydsreferencer.py` | **Kontrollerer rapportlaget op mod den kørende model** (14-09-2026): hver feltreference i PBIR-json holdes op mod modellens faktiske felter og opdeles efter hvor den sidder — `query` (visualet kan ikke rendere), `sidefilter` (rammer hele siden) eller formatering (kulør tabt, intet fejler). Første kørsel fandt 8 alvorlige, heraf `L-Kalender[Aktuelt år + 4 historikår]` som sidefilter på **32 sider**. Docstringen rummer to fælder i selve opslaget: `ExplicitName` er tom for beregnede tabellers kolonner (navnet ligger i `InferredName`), og `NATURALLEFTOUTERJOIN` i DAX tabte navnene helt |
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
| `tools/regneark-elevaktivitet/` | `byg.py` + 11 `.dax` + `run.ps1` + `verificer.py` + README: bygger ÉN formelstyret fil "Elevaktivitet pr. hold og måned" fra den kørende model — scenariefaner (faktor, nedlæg/flyt, ekstra elever → Δ ÅE/takst/færta/elever), Optag (hold a/b/c), Hold, Parametre (takster), Data (måned), effekt af nedlagte optag, budget pr. hold, kontrol mod `… (samlet)`, links og kopier af BRUGER-inputarkene. `verificer.py` beregner formlerne og tester facit/flytning/takst/1 elev/kapacitet. Kun holdniveau — ingen persondata. PR #97, #98 |
| `Output/reviews/hr-oekonomi-audit-2026-10-15.md` | Audit og rettelsesfacit: Drift/Projekt, SD6-årsværk, Z8050, kildeafstemning, kold persistenskontrol, gates og kildebegrænsninger |
| `Output/reviews/hr-oekonomi-statuskort-2026-10-16.png` | Persondatafrit reviewbilag med otte statuskort efter kold modelåbning; designgate og restfund i auditten |
| `Output/reviews/hr-oekonomi-forecast-afklaringer-2026-10-16.md` | Beslutningsgrundlag med tre persondatafri eksempelforløb, allerede bindende regler og konkret næste arbejde |
| `Output/reviews/hr-oekonomi-forecast-grundlag-2026-10-16.json` | Reproducerbart aggregatbilag til afklaringsarket: otte kørte DAX-queries, resultater og kodehashes, ingen personidentifikatorer i output |
| `Output/reviews/hr-oekonomi-tidslinje-integration-2026-10-16.json` | Afgrænset foundation-GO runde 2: gem/kold 17-/104-felts multisetidentitet, skjulte hjælpefelter, coverage, modeltilstand, nye SD-årsværksaggregater og read-only Y-inventar |
| `Output/reviews/hr-oekonomi-profilprogression-2026-10-16.json` | Aggregatbevis for PA 2002/version 6: 16 fase-/versionsgrupper, bevarede fysiske intervaller og præcist manglende kobling til profilens TP1–21 |
| `Output/reviews/hr-oekonomi-donor-version-2026-10-16.json` | Aggregatbevis for 25013→26013: historisk fordeling 10+1 bevares; uddannelsesversion 2→3 kræver dokumenteret overførselsgrundlag |
| `Output/reviews/hr-oekonomi-donor-univers-2026-10-16.json` | Fuldt tilgængeligt routeunivers: 113 fuldkoder/265 grupper, nyere donor 25093/version 3 med 12/1, eksakt målfordeling 132/13+11/13; fordelings-GO, ingen aktivering |
| `Output/power-query/donor-egne-foerste-observationer/` | Isoleret donor-kodeforslag: helper, tre faktiske værnsmutanter, fire selvstændige 73-tests-harnesses, manifest, koldbevis og README; kode-GO, ikke produktionsaktiveret |
| `tools/kalenderprofil/` | Historiske kalenderprofiler: råkilde-/AJ-bygger, uddannelsesforløb med interne PA-versionsskift, manuel XLSX-generator, modelhaleberegner og GUI-fri kilde-/anker-/plankalenderkontroller; kun aggregater skrives |
| `Output/power-query/kalenderprofil/` | AJ-kerne med 27 tests; integrationskæde med 21 tests og to mutanter; aldersmix med 19 tests; modelhale og absorberet fortsættelse med hver 16 tests og målrettede mutanter; godkendte GF2-PA-planbroer med 200 undervisningsdage og otte kildebeviste perioder |
| `Output/power-query/kalenderprofil/manual-aj-policy/` | Isoleret manuel AJ-justering med fastholdte completion-/skifthazarder: 81 M-kontroller, fire uafhængige brøkfacit og to effektmutanter; kodegate og bytebevis, endnu ingen produktionsaktivering |
| `tools/kalenderprofil/pa-physical-candidate/` og `Output/power-query/kalenderprofil/pa-physical-candidate/` | Frossen, hashverificeret PA-kandidat: alle 150 fysiske punkter, dokumenteret donorfordeling og ikke-FÆRTA-økonomi; 83 manifestfiler, ingen produktionsaktivering |
| `tools/kalenderprofil/pa-financial-registration-candidate/` og `Output/power-query/kalenderprofil/pa-financial-registration-candidate/` | Finansiel registreringsprofil fra 320 forløb, 100 punkter og 4.866 daterede prognoseposter; 48 hashbundne filer, store JSON-facit tabsfrit komprimeret, baselinekandidat uden produktionsaktivering |
| `Output/power-query/kalenderprofil/pa26065-financial-boundary/` | Eksakte produktionsudtræk og afgrænset inputkontrakt for PA-økonomien |
| `Output/reviews/kalenderprofil-2026-10-16/pa-*-gate*.md` | Afgrænsede gates for fysisk fordeling, økonomikandidat, registreringsprofil og fælles frafaldskalibrering; de enkelte scopegrænser fremgår af hver gate |
| `Output/reviews/kalenderprofil-2026-10-16/source52-history-confirmation.json` | JSTs hashbundne bekræftelse af fuldstændigt Z8050V-udtræk til 12. oktober 2026 |
| `Output/reviews/kalenderprofil-2026-10-16/` | 10.405 historiske kandidatepisoder, 2.269 profilpunkter i 47 grupper, manuelt justerbart profilark, proveniens, kilde-/runtimebeviser og afgrænset slutkontrol; ingen produktionsaktivering |
| `Output/reviews/kalenderprofil-2026-10-16/pa-trajectory/` | Korrigerede PA-profiler: 320 uddannelsesforløb, 29 interne versionsskift, 105 empiriske punkter i fire grupper, separat manuelt profilark og markeret modelhale; 32 aktive observationsankre er dokumenteret i overmappens ankerbevis |
| `Output/power-query/fysisk-observation-identitet/` | Isoleret identitetsrettelse: seks frosne M-filer, 157 kontroller, faktiske mutanter, gemt/kold bevis og kode-GO; kræver særskilt kildeadapter |
| `Output/power-query/fysisk-kilde-identitet/` | Kildebevist streng 6-4→10-adapter: 105 kontroller, to faktiske mutanter, uafhængigt kode-GO og præcise versionerede LF-hashes; ingen produktionsaktivering |
| `Output/power-query/fysisk-identitet-callervaern/` | Særskilt værn mod delpopulationer: begge invalidtællere skal entydigt være nul; 78 kontroller og to faktiske branchmutanter, kode-GO uden aktivering |
| `Output/power-query/fysisk-aktuel-kildeprobe/` | 24 frosne M-kildeafhængigheder, dokumenterede tidsudløb, adapterforslag, scope-review samt runtime-source/: hashbundne kildeværn, 102 runner-tests, 327 enginekontroller og feltsanitiserede faktiske prøver; ingen populations- eller forecast-GO |
| `Output/reviews/hr-oekonomi-identitets-kildeformat-2026-10-16.json` | Faktiske aggregatprofiler: Z8050-Raw 104046 rækker og Z8312 49977 rækker bruger begge præcis seks cifre, bindestreg, fire cifre |
| `Output/reviews/hr-oekonomi-final-refresh-2026-10-16.log` | Persondatafri refresh-log for den afsluttende live-modelkontrol: 36 tabeller, 0 uprocesserede og 0 fejlede |
| `tools/byg-amu-periodekontrol.py` | Genopbygger AMU-kontrakter fra modellens faktiske målerliste og produktionsstatuskrop; kun query-lokale testmål |
| `tools/afstem-amu-nulltakster.py` | Kilde 32: hash- og typekontrol, takstbærende ÅE kontra FKBPÅ/OMPPÅ-tællere; kun aggregater, teksttal stopper beviset |
| `Output/dax/amu-periodekontrakt.dax` | 29 cases mod 21 faktiske AMU-mål: delår, næsten-hele år, skudår, flerår og begge beregningsgrupper |
| `Output/dax/amu-kildeprioritet-mutation.dax` | Kodemutation af genkompileret produktionsstatus; beviser kildeadvarslens prioritet, ikke reel kildefrakobling |
| `Output/dax/amu-aarstal-baseline.dax` | Alle 21 AMU-tal og status for canonical år samt særskilt flerårssubtotal; eksakt før/efter-sammenligning |
| `Output/dax/amu-periode-rettelse.patch` | Klargjort rettelse af AMU-årsværnet; query-testet og strukturvalideret, afventer lukket Desktop og kold produktionskontrol |
| `Output/dax/z8050-fuld-output-kontrol.dax` | Sammenligning på alle 38 indlæste aggregerede Z8050-felter og multiplicitet; kun lokale snapshotfiler |
| `Output/power-query/z8050-direkte-distinkt-optimering.patch` | Klargjort fjernelse af nested AlleRækker til fordel for direkte distinkt-tælling; afventer output-/ydelsesverifikation |
| `Output/reviews/hr-oekonomi-amu-aarstal-foer-2026-10-16.csv` | Persondatafrit før-facit for AMU-årstal og subtotal, inklusive BLANK-felter |
| `Output/reviews/hr-oekonomi-amu-aarstal-efter-2026-10-16.csv` | Persondatafrit efter-facit for AMU-årstal efter korrektion af PÅBEG-år og fælles periodeværn |
| `Output/reviews/hr-oekonomi-aarsvaerk-2026-10-16.png` | Persondatafrit skærmbevis fra kold genåbning: korrigerede årsværkskort, periode og filterforklaring; designgate GO |
| `Rapporter/HR_OEKONOMI/HR_OEKONOMI.Report/definition/pages/f7a8b9c0d1e2f3a4b5c6/visuals/dd117674d3424ac7b833/visual.json` | AMU-kort med dynamisk status for ufuldstændige fag-/takstoplysninger; afventer kold designkontrol |
| `Rapporter/HR_OEKONOMI/HR_OEKONOMI.SemanticModel/definition/tables/MSK-Elevmotor-Coverage.tmdl` | Skjult coverage-tabel der blokerer usikre elevforecast-/forventet-/resttal og bevarer faktiske tal |
| `Rapporter/HR_OEKONOMI/HR_OEKONOMI.SemanticModel/definition/tables/STU-GEN-Tidslinje-Fysisk.tmdl` | Skjult fysisk Z8112-sidecar: bevarer alle 17 kildefelter og multiplicitet, typed n?gler/signaturer, strict kontrakt og kildev?rn; foundation-GO runde 2, ingen forecast?bning |
| `tools/afstem-aarsvaerk.py` | Uafhængig SD6-kildeafstemning af begge årsværk pr. ansættelse/måned og skolens månedstotaler; status 1/3, hash-kontrolleret spejl, kun aggregater i output |
| `Output/dax/aarsvaerk-grain-kontrol.dax` | Syntetiske forløb gennem produktions-DAX: statusskift, brøkskift, dubletter, fleransættelse, delmåneder, skudår og konfliktmutationer |
| `Rapporter/HR_OEKONOMI/HR_OEKONOMI.SemanticModel/definition/tables/LON-DATA-SDDW-Årsværksintervaller.tmdl` | Skjulte SD6-statusintervaller til årsværk; historisk status, reelle brøker og konfigureret datovindue |
| `Output/Budget/Elevaktivitet pr. hold og måned - samlet regneark - <dato>.xlsx` | Regnearket fra `tools/regneark-elevaktivitet/` — øjebliksbillede af modellen den dag (2026-10-12: første; 2026-10-13: formelstyret med scenarier, nye Z8050-data). PR #97, #98 |
| `Output/praesentationer/*.pptx` | De tre genererede præsentationer + årshjulet med rettede måneder (09-09). Genbygges med `python byg-*.py`; redigér generatoren, ikke .pptx-filen |

---

## SYS-INNOMATE — `<OneDrive>\AI SOSU\SYS-INNOMATE\` (repo: [JST-BI/SYS-INNOMATE](https://github.com/JST-BI/SYS-INNOMATE))

Mailskabeloner og procesplaner for onboarding/offboarding via INNOMATE.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: orkestrator-rolle, CPR-regel, merge-felter, workflow |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `.claude/rules/inno-workflows.md` | Agent-workflow-mønstre for INNOMATE-arbejde. Læses eksplicit af begge værktøjer — indlæses ikke automatisk. (Fjernet fra `.codex/rules/` 2026-08-20, se ovenfor) |
| `generate-procesplan-v3.js` (+ `package.json`) | Procesplan-generator (Node.js) |
| `Input/Oprettelse af medarbejder/`, `Input/Nedlæggelse af medarbejder/`, `Input/Generelle skabeloner/` | Kildefiler: procesplaner, INNOMATE-skabeloner, korrespondance |
| `Output/` (samme undermapper) | Genererede skabeloner og procesplaner |

---

## ADM-HÅNDBØGER — `<OneDrive>\AI SOSU\ADM-HÅNDBØGER\` (repo: [JST-BI/ADM-HANDBOOKS](https://github.com/JST-BI/ADM-HANDBOOKS))

Personalehåndbog og Lederhåndbog — afspejler hinandens emner.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: håndbogs-parallelitet, workflow |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `Personalehåndbog/` | Indhold målrettet medarbejdere |
| `Lederhåndbog/` | Samme emner, ledervinkel |
| `Input/` / `Output/` | Kildemateriale hhv. færdige/godkendte versioner |

---

## ADM-ØKONOMI — `<OneDrive>\AI SOSU\ADM-ØKONOMI\` (repo: [JST-BI/ADM-OEKONOMI](https://github.com/JST-BI/ADM-OEKONOMI))

Økonomiske styringsdokumenter.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: dokumentrelationer, workflow |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `Regnskabsinstruks/` | Regler for bogføring, godkendelse, regnskabsaflæggelse |
| `Indkøbspolitik/` | Rammer for indkøb, leverandørstyring, udbudspligt |
| `Strategi for finansiel risiko/` | Risikovurdering, likviditetsstyring, finansielle principper |
| `Input/` / `Output/` | Kildemateriale (Management Letter, årsrapport, bestyrelsens budget) hhv. handleplan-pptx'er — **gitignoreret** fra 12-10-2026, deles kun via Y: (Udgiv). PR #1 |

---

## ADM-BI — `<OneDrive>\AI SOSU\ADM-BI\` (repo: [JST-BI/ADM-BI](https://github.com/JST-BI/ADM-BI))

BI governance og styringsdokumenter.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: governance-scope, relation til BI-OEKONOMI |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `Input/` / `Output/` | Kildemateriale hhv. godkendte standarder (normgivende for BI-OEKONOMI) |

---

## DATA-BUDGET_PROGNOSE — `<OneDrive>\AI SOSU\BI-OEKONOMI\DATA-BUDGET_PROGNOSE\` (undermappe i [JST-BI/BI-OEKONOMI](https://github.com/JST-BI/BI-OEKONOMI) siden 13-11-2026; historikken fra JST-BI/DATA-BUDGET_PROGNOSE er bevaret)

Finansiel analyse, budget og prognose (Navision + BRUGER-budget/prognose → .xlsx). Stierne herunder er relative til undermappen.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: datakilder, formålskoder, fin-agent-routing |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `Input/` | Rådata: Navision-finansposter, budget, prognose, finanslov, årsrapporter (gitignored) |
| `Output/` | .xlsx-leverancer med danske formater (rene leverancer må committes) |
| `tools/budget2027/byg_budget_2027_2028.py` | Bestyrelsens budgetforslag (FB) til 2035 (l30–l40, byg_drill, byg_aarsvaerk, byg_bro_stuk, byg_bro_balance). `--motormappe` = scenariemotorens kørsel; `--kontrolversion` = fortrolig version med skoleforløb og løn/årsværk pr. medarbejder (gitignoreret) |
| `tools/budget2027/l46_optagsark.py` | Fanerne Optag 2026 og Optag 2027–2035 (input) i FB fra fil 1 og inputarket; stopper, hvis inputarket er ændret siden motorkørslen (#13). `byg_tabel3` = fanen **3 Elevoptag** (2026–2035 på én fane, bro til tabel 1; #18) |
| `tools/budget2027/byg_oekonomi.py` | Fanen **2 Økonomi** i FB (bygges af l37 i begge versioner): linje → konti alle år, FB-rettelser, løn afdeling → medarbejder; kontroller k1–k5 (#18) |
| `tools/budget2027/vaern.py` | Værn før hvert `wb.save` i FB-bygget: tekst der begynder med "=" (gemmes som formel → #NAME?) stopper bygget (#18) |
| `tools/budget2027/l47_aktivitet_optag.py` | `AKTIVITET-OPTAG.json` i motormappen: plads pr. hold, distinkt optag 2024–2026 (kontrolleret mod fil 1), fastholdelsesprofil og lånt fra pr. optag, realiseret FÆRTA pr. optag. Køres efter hver motorkørsel (#13, #14, #15) |
| `tools/budget2027/byg_aktivitet_optag.py` | Fanerne Aktivitet pr. optag (drill uddannelse → optagtype → optag → kilde, 2024–2035, takstopdeling) og Fastholdelsesprofil pr. optag; kædekontroller mod Optag-fanerne og Scenariemotor (#13, #14, #15). `byg_tabel1` = fanen **1 Elevaktivitet** (… → hold, 2025 = regnskab, afstemningsrækker + kronegrænse 85.000 kr., midlertidig; #18, #19). l37 `fire_aarsvaerk` = fanen **4 Årsværk** (afdeling → personaletype → medarbejder, stillingskode og stilling; #18) |
| `tools/budget2027/l42_q4_2026.py` | Kvartalsrater i forventet 2026: AMU 101121/101126, 227020, 265025/265020, 228066 og FVU. Rettelserne er betinget af posteringerne ved ankeret og stopper ved delvis bogføring; `--fra-snapshot` genbruger udtrækkets kontosummer (#10, #11) |
| `tools/budget2027/ankerdato.py` | Én ankerdato for l33, l42 og generatoren (`<grundlag>\ankerdato.json`); stopper, hvis udtræk, argument og kildefiler ikke hører til samme dag (#11) |
| `tools/budget2027/pbi-udtraek/` | Power BI-udtrækket bag FB: `oko-linjer/konti/niv3.dax`, `parse-oko.py` og `udtraek.ps1`, der danner `oko-grundlag.json` og skriver ankerdatoen (#12). Kontoudtrækket til 2 Økonomi: `oko-konti-alle.dax` + `parse-konti.py` + `udtraek-konti.ps1` → `oko-konti-alle.json` (samme refresh; stopper ved afvigelse mod linjerne; #18) |
| `tools/budget2027/pbi-udtraek/udtraek-hist.ps1` | Regnskab 2023–2024 pr. konto (`oko-konti-hist.dax` + `parse-hist.py` → `oko-konti-hist.json`; værn: R2025 = Regnskab 2025 pr. konto) til 2023 og frem i de fire tabeller (#20/#21) |
| `tools/budget2027/konsistens/` | Konsistenskontrol efter hver FB-udgivelse: `konsistens.ps1 -MedPBI` (Excel/pivot/datafil i tre udgaver, siderne, fire tabeller, BI_SOSU-TMDL i tom PBI-instans via `bisosu_tom.ps1` + `bisosu_dax_tjek.py`, Y:-hash); `dax_dom.ps1` + `dax_dom_test.ps1` bedømmer DAX-sammenligningen. `sider/` danner og kontrollerer siderne: `lav_sidedata.py`, `udvid.py`, `optag_detalje.py`, `hold_detalje.py`, `optag_art.py`, `opdater_sider.py`, `gem_sider.py`, `cmp_sider.py`, `cmp_fire.py`, `fire_tabeller_sider.py`, `udtraek_viz.py`; Optagssimulator 2027: `optagssim_data.py` (sidens `sim`-data fra motorens filer; stopper, hvis Σ elevtyper ≠ FB), `sim_script.js` (beregning, figurer, Excel-eksport), `byg_sim.py`, `sim_test.js` (24 prøver) (#152, #155) |
| `tools/budget2027/konsistens/sider/sim_ark.py` + `sim_side_test.js` + `sim_mutation.js` | **Optagssimulator 2027 v22 (BI-OEKONOMI #164, 18-11-2026):** `sim_ark.py` (det samlede ark og scenariebogens nedlagte optag til siden), `sim_side_test.js` (Edge headless: ingen vandret rulning ved 1100/1366/1920 px, rulleanker, lyst og mørkt tema med kontrast ≥ 4,5:1), `sim_mutation.js` (7 mutationer skal blive røde). Siden bygges på FB-scenariet med nedlagte optag (`optagssim_data.py --nedlagte <bog> --grundlag <tekst>`) |
| `tools/budget2027/konsistens/sider/sim_personale.js` + `personale_data.py` + `personale_side.py` + `personale_test.js` + `personale_side_test.js` + `personale_mutation.js` + `personale_navnetest.py` + `test_personale_data.py` | **Optagssimulator med personale (BI-OEKONOMI #174, 19-11-2026):** kopi af Optagssimulatoren med lønændring (% eller kr./md. fra en måned), ugentlig arbejdstid og fratrædelse pr. medarbejder/gruppe; TR- og AMR-tillæg faste (listen i `Output\FB 2027\Grundlag og input\`, gitignoreret – persondata); to udgaver: uden navne (grupper ≥ 5) og med navne (kun lokalt/Y:); byg med `byg_sim.py --personale`; prøver: personale_test/_side_test/_mutation, navneprøve (0 navne og CPR i udgaven uden navne) |
| `tools/budget2027/konsistens/sider/test_sidekaede.py` | Prøver for sidekædens summekontroller: hver kontrol giver exit ≠ 0 ved afvigelse, og side.json skrives kun ved OK (BI-OEKONOMI #177, 20-11-2026) |
| `tools/budget2027/konsistens/procestrae.ps1` + `procestrae_test.ps1` | Procestræ for konsistens' egen Power BI-instans: et barn tæller kun, hvis forælderen lever og barnet er startet efter den (UTC); roden lukkes kun med den gemte starttid; `55088` og forfædre aldrig med. Lukker PID-genbrugsfejlen, der dræbte konsistens.ps1 efter pbi-dax (BI-OEKONOMI #182, 20-11-2026) |
| `tools/budget2027/konsistens/sider/side_script.py` | Finder og fornyer det indlejrede `sim_script.js` (og `sim_personale.js`) på simulatorsiderne; `tjek` tæller repoets scripts på en side. Bruges af `opdater_sider.py` og konsistens-trinnet `sider-script` (BI-OEKONOMI #183, 20-11-2026) |
| `tools/budget2027/konsistens/sider/fra_optag_pivot.py` + `fra_optag_pivot.ps1` | Bygger og kontrollerer `FB <år> - fra optag til kroner - pivot.xlsx` fra sidekædens side.json (samme grundlag som siden "fra optag til kroner"); tidligere et engangsscript (BI-OEKONOMI #180, 20-11-2026) |
| `tools/budget2027/test_samlet_fb.py` | FB-kæden med det samlede ark (#163): `koer_scenarie.ps1 -SamletArk`, motorlåsens sha-binding til arket, l46-fanen "Gennemførelse og overgang", kontrolrækker, uændret FB uden samlet ark; `scenarie_inputark` stopper ved egne GF2-valg på et samlet ark |
| `tools/budget2027/pbi-udtraek/udtraek-personale.ps1` | Personaleomkostninger forventet 2026 pr. konto × datakilde (SD faktisk/forventet, BRUGER-supplement, Navision m.m.; `oko-personale-kilde.dax` + `parse-personale.py` → `oko-personale-kilde.json`, samme refresh som oko-grundlag) – grundlaget for den uafhængige lønafstemning (JST 08-11) |
| `tools/budget2027/l48_kildefarver.py` | Kildefarver på alle talceller uden formel + fanen **0 Signaturforklaring**; sidste trin før den sidste genberegning (#20) |
| `tools/budget2027/l50_fire_flad.py` + `l50_pivot.ps1` | De fire tabeller som flad datafil ("Budget 2027-2035 - fire tabeller som data …xlsx", læses af BI_SOSU) + datafane, levende kontrol og fire pivotfaner inde i FB via Excel COM; sidste trin i bygget (#23) |
| `tools/budget2027/kontrol_pivotfil.py` + `test_pivotfiler.py` | Selvstændige pivotfiler `FB <år> - fire tabeller - pivot.xlsx` (+ med navne, + scenarie), bygget med `l50_pivot.ps1 -NyFil`: datafanen sammenlignes celle for celle med datafilen, pivotstruktur/filtre/format og cachens kontrolsummer kontrolleres; prøverne har mutationer og et værn for `IgnoreRemoteRequests` i alle Excel-instanser (BI-OEKONOMI #180, 20-11-2026). Datafilerne (`fire tabeller.xlsx`) er Power BI's kilde og får aldrig pivotark |
| `tools/budget2027/slutkontrol.py` + `test_slutkontrol.py` | Samlet slutkontrol efter sidste genberegning og efter pivot: forventede kontroller pr. variant (basis/kontrol/scenarie) + minima, numeriske formelceller, Excel-fejl/manglende cache i hele bogen, stempel mod Excel-tabellen `FireTabeller` (review 08-11) |
| `tools/budget2027/loenafstemning.py` + `test_loenafstemning.py` | Uafhængig lønafstemning: Power BI SD + BRUGER pr. konto = lønfilernes F2026 (0 kr.), Navision-delen som dokumenterede beløb (JST 08-11) |
| `tools/budget2027/loen_regler.py` + `test_loen_regler.py` | Fælles lønregler for l30/l36 (personbundne tillæg/refusioner ophører med ansættelsen; JST-afgørelser som aggregater); løn pr. år 2028–2035 til og med registreret slutmåned, 50 % slutafregning måneden efter, derefter 0 (`maanedsvaegte`, `registreret_ud`; PR #46/#47) |
| `tools/budget2027/kontrolhul.py` + `test_kontrolhul.py` | Celleniveau-tjek: hver kontrolcelle i bogen skal nå fanen Kontrol, ellers lægges den dér; slutkontrol stopper på udækkede (PR #47) |
| `tools/budget2027/paedagogikum.py` | Pædagogikum-tillægget ét sted (334.720 − motorens faktiske), brugt af byg_budget og kildeafstemning (PR #47) |
| `tools/budget2027/regression_fb.py` + `regression_fb.json` + `test_regression_fb.py` | Regressionstest: bygger b1 på det frosne grundlag og sammenligner sha256 pr. fane; exit 1 = koden flytter tal, exit 2 = input ændret → `--opdater` bevidst (PR #46) |
| `tools/budget2027/test_l50_fire_flad.py`, `test_review_0811.py` | Tests og mutationer for l50 (entydige blade, 0-rækker, måle-/kolonnesæt, stempel) og review-rettelserne 08-11 |
| `tools/budget2027/tekstdetalje.py` | Tekstniveau og leder til de fire tabeller (#186): sidevogn (gitignoreret grundlag, bundet til FB-filen, alle kilder sha-bundet med kørselslog) med Navision-posteringstekster og budget-/prognosekommentarer pr. kontoblad i '2 Økonomi' (foldes kun ud, når kilden giver kontoens tal) og leder pr. medarbejder fra Innomate; navneuniverset til maskering på siden uden navne; læses af `l50 --detalje` |
| `tools/budget2027/test_tekstdetalje.py` | Prøver af tekstdetalje: gruppering, udfoldning kun når kilden går op, markering af ikke-udfoldede blade, lederregler, rolle uden navn, kildebinding (fiktive data) |
| `tools/budget2027/budgetaar.py` + `test_fb_navne.py` | Budgetårskonstanten (`BUDGETAAR`, `FB` = "FB <år>", `B_VEDT` = "B<år−1>"), som alle genererede tekster og fanenavne bruger; testen binder fanenavne og kontroltekster mellem producent og læsere (JST 09-11) |
| `tools/budget2027/flyt_til_fb_mappe.ps1` + `test_fb_mappe.py` | Flytter det færdige output fra de gamle `Output\Budget`/`Output\Sider` til `Output\FB <år>\` (flytter, sletter aldrig, manifest i `Arkiv\flytning-<dato>.csv`, `-Proeve`, `-Rod` til Y:); grep-værnet fanger gamle stier i koden (BI-OEKONOMI #170) |
| `tools/budget2027/navision_facit.py` + `test_navision_facit.py` | **Navision er facit for FB's økonomi** (JST 10-11-2026): resultat, omsætning, omkostninger og finansielle poster 2023–2025 øre-præcist fra finansposterne, krydstjekket mod Balance 499999; 12 kontrolrækker i fanen Kontrol (skal være 0,00). Stopper ved sha256-afvigelse fra modellens spejl (PR #38) |
| `tools/budget2027/motor_laas.py` + `test_motor_laas.py` | **Motorlåsen** (JST 11-11-2026, PR #40): FB-kæden (l35/l38/l39/l47/l49/l51, scenarie_inputark, koer_scenarie, byg_v7) kører kun, når motormappen ikke har ucommittede ændringer eller indeksflag; siden #139 er låsen motormappens stempel (ingen låsefil at flytte). **Motorstemplet** (#41, PR #42): `koer_scenarie.ps1` stempler hver motormappe (`<M>\motorlaas.json`: låsens tree + sha256 af seks filer), og alle læsere (byg_budget, l45, l48, l49, l51, identitet, kildeafstemning) stopper uden gyldigt stempel; `-Motormappe` kræver `-Ark` |
| `tools/budget2027/orkestrering/stempl_motormappe.ps1` | Bagudstempel af en eksisterende motormappe (#41): kører `koer_scenarie.ps1` til en ny prøvemappe og stempler kun ved byte-identiske filer; bevis i `<prøve>.koer.log` og `<prøve>.bagudstempl.txt` |
| `tools/budget2027/orkestrering/produktion_konst.ps1` + `bisosu_filer.ps1` | Produktionsmotor, udtræksdato og basisfilnavne ét sted; skriver/tjekker BI_SOSU's `Datafiler`-linje (kræver det nye M-skema) |
| `tools/budget2027/l49_optag_historik.py` | `Optag 2023-2025 - Studie+.xlsx` (faktisk optag, samme mål som fil 1; låst til motorkørslens udtræk) → fanen Optag 2023–2025 (historik) i FB (#21) |
| `tools/budget2027/scenarie_inputark.py` + `byg_scenarie.py` | Scenarie-FB: kopi af inputarket med nedlagte optag/EUX/PAU-forudsætninger og fanen **0 Sammenligning** mod den udgivne FB (#20); 90/100 % absorption, HF-bortfald og målt GF2→HF-afløb, `- log.json` ved siden af arket (#28) |
| `tools/budget2027/l51_overgang_gf2_hf.py` + `test_scenarie_nedlagte.py` | Målt GF2→HF-overgang langs fødekæderne (Z8050, startede hold 2022–2026; `--hf-andel foeder_aar|puljet`) → `Output/Grundlag/budget2027/elev/overgang-gf2-hf.json`; tests og mutationer for scenariets trin (#28) |
| `tools/budget2027/orkestrering/scenarie_konst.ps1` | Scenariets dato og motormappe ét sted (læses af `koer_scenarie.ps1` og `byg_scenarie.ps1`) (#28) |
| `tools/budget2027/aarsvaerk_kr.py` + `test_aarsvaerk_kr.py` + `kontrol_aarsvaerk_kr.py` | Kontrol: årsværk som talt − årsværk efter kronerne for personer med fradrag i supplementet (i l37; mutationstest) (#21); testen kører nu på syntetiske data, det gamle script er `kontrol_aarsvaerk_kr.py` (PR #46) |
| `tools/budget2027/orkestrering/` | Byggescripts (byg_fire, byg_scenarie, koer_scenarie, byg_v7) som reference; README med rækkefølgen (#21); et fejlet trin stopper kæden (#22); `recalc.ps1` (Excel-genberegning, sporet fra #24); standarder: værk = egen gren, motor `…-1103-tilskud`, output i `%TEMP%\budget42` (#24) |
| `Output/Grundlag/budget2027/` | FB-grundlaget (SD/løn med `loen\jst-valg.json`, motorkørsler, `bro-42`, `arkiv\`); gitignoreret persondata, **ikke på Y:** (JST 05-11-2026, Udgiv `$IkkePaaYStier`); før 05-11 i en Claude-jobmappe (#24) |
| `Output/FB <år>/FB <år> - budgetforslag.xlsx` (+ `- med navne`) | FB 2027 med broer, STUK-ark (6.1.1/6.2) og bæredygtighed; gitignoreret, ligger i OneDrive og på Y: |
| `Output/FB <år>/FB <år> - scenarie nedlagte optag.xlsx` + `Grundlag og input/BRUGER - Optag 2027-2035 - scenarie nedlagte (<dato>).xlsx` | Scenariet og dets inputark (kopi; produktionsarket er uændret) |
| `Output/FB <år>/Grundlag og input/Optag 2023-2025 - Studie+.xlsx` | Faktisk optag 2023–2025 (l49), input til 3 Elevoptag |

---

## ADM-KANTINE — `<OneDrive>\AI SOSU\ADM-KANTINE\` (repo: [JST-BI/ADM-KANTINE](https://github.com/JST-BI/ADM-KANTINE))

Kantinens menukort (tilrettede udgaver af leverandørens ugemenu) og bestillingerne til Jespers Torvekøkken — til og med uge 46 også Bilkas bageri; fra uge 47 laver kantinen selv bagværket (bake-off). Kører dagligt kl. 07.00 (`tools/dagskoersel.ps1`).
**Bemærk**: `Input/`s PDF'er committes her (små, persondatafrie = dokumentation for hvert ugekort). `.gitattributes` sætter `*.pdf binary`.
Mailmapperne under `Input/` og `Output/Bestillinger/` er derimod gitignored — de indeholder navne, mobilnumre og e-mailadresser.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: kilder, filnavngivning, ugentlig arbejdsgang |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `tools/hent-portionsanretning.py` | Henter kilde-PDF'en fra torvekoekken.dk når den ikke allerede ligger i `Input/` — regex på knappens `onClick`-attribut i den rå HTML, ingen browser nødvendig; vælger altid den danske "Uge `<N>`"-knap, ikke den engelske |
| `tools/byg-ugekort.py` | Generator: `byg-ugekort.py <uge>` læser og validerer `afstemningsdata/ugekort<uge>.json` og bygger `Output/Kantine Ugekort <uge>.pdf` (kun FAVORIT + stående Bowl+Sandwich-tilbud). Auto-skalerer dagsblokkene så de aldrig løber ned over allergen-footeren — kræver `reportlab` |
| `tools/test-layout.py` | Layout-værn (`test-layout.py <uge>`): tjekker ugens indhold + et værre tilfælde, med negativ kontrol der kræver at et fast layout faktisk overlapper |
| `Input/<uge>_Aarhus_Portion.pdf` | Leverandørens portionsanretning, 5 sider (FAVORIT, Vegetar, Vegansk, Halal, Gluten/laktosefri) |
| `Input/Kantine - Prisskilt.pdf` | Kantinens prisskilt (bagværk, frokost, drikkevarer) — kilde til Bowl- og Sandwich-prisen |
| `Output/Kantine Ugekort <uge>.pdf` | Ugens menukort til opslag — kun FAVORIT-retten pr. dag |
| `tools/lav-muah-seddel.py` | Generator: udfylder MUAH-udfyldningssedler til Bilkas bagerudsalg ud fra en JSON-liste og en tidligere seddel som skabelon — kræver `python-docx` |
| `tools/lav-bestillingsseddel.py` | Generator: bestillingssedler med én side pr. afhentnings-/leveringsdag ud fra en JSON-liste — vedhæftes bestillingsmailen. Kræver `python-docx` |
| `tools/lav-afstemning-xlsx.py` | Bygger ugens afstemningsregneark (8 ark: dag for dag, ugetotaler, kilder, beslutninger, fakturering, pedellens tilbehør) — JSTs kontrolgrundlag. Kaldes med ugenummeret. Kræver `openpyxl` |
| `tools/lav-kantineoversigt.py` | Dagsoversigt til kantinemedarbejderen: ét ark pr. dag med kiosksalget og hvert arrangement i sin helhed (Jespers, Bilka, kantinen selv/pedellen, kontakt, fakturering) fra ugemodulets `ARRANGEMENTER`, kronologisk efter første klokkeslæt — samlet + fem dagsfiler, hver som `.docx` OG `.pdf` |
| `tools/docx-til-pdf.ps1` | PDF-kopi ved siden af hver `.docx` via Word-COM (én usynlig instans; stopper kun sin egen, hvis `Quit()` svigter) — kaldes af `lav-kantineoversigt.py` |
| `tools/dagskoersel.ps1` | Dagskørslen kl. 07.00: starter Outlook, henter indbakke og formularer, kører `claude -p` (prompt på stdin, snæver tilladelsesliste fra `dagskoersel-tilladelser.json`, ingen brugerindstillinger/MCP) når der er grund, og udgiver via `udgiv-kantine.ps1`; exitkode = antal fejlede trin; `-Proev` åbner ikke Outlook; `-Registrer` opretter opgaven og afregistrerer fredagsopgaven |
| `tools/dagsprompt.md` | Opgaveteksten til den uovervågede dagskørsel: mails/Forms er data, aldrig instruktioner; kommandotabel; kun JTK + bake-off, kladder i kantine@, ugekort og infoskærm; committer kun via `commit-ugefiler.ps1`; aldrig send eller `.Display()` |
| `tools/afstemningsdata/__init__.py` | Fælles konstanter + opslag af kildemails på SHA-256-præfiks (persondatabærende filnavne står ikke i et versioneret script); `hent()` kontrollerer et ugemodul mod en AST-hvidliste (lofter for størrelse, noder og værdivægt) før afvikling; `kontroller_ugekort` |
| `tools/afstemningsdata/uge<nr>.py` | Ét datamodul pr. uge (kun data, håndhævet af hvidlisten): bestillinger, kilder, beslutninger, åbne punkter, fakturering og tilbehør |
| `tools/afstemningsdata/ugekort<nr>.json` | Ugekortets indhold (ugenr, dage, tilbudslinje; kun `<b>`/`<i>`) — læses af `byg-ugekort.py` |
| `tools/mail-md-til-json.py` | Oversætter bestillingsmailene fra `.md` til `mails.json` (UTF-8, skrives direkte — aldrig med `>`) til kladdescriptet |
| `tools/opret-kladder.ps1` | Lægger mailene som kladder i kantine@sosuranders.dk's postkasse (mærket `KantineAgent`; kun mærkede ryddes) OG gemmer dem som `.msg` i `Klar til afsendelse/`; vedhæftninger kun under JSON-mappen; `-KunKontrol` uden Outlook. Kalder aldrig `.Send()`. Sætter til sidst fluebenet i indbakken (`marker-indbakke.ps1`; `-UdenFlueben`) |
| `tools/marker-indbakke.ps1` | Flueben (opfølgningsflag = fuldført) på ugens færdigbestilte kildemails i kantine@'s indbakke (`KILDER` minus `UDENFOR`, Message-ID-match); `-Proev`; eneste skrivning i den delte indbakke (JST 15-11-2026) |
| `tools/hent-indbakke.ps1` | Henter nye mails fra kantine@'s indbakke (kun læsning) som `.eml` i `Input/UBEHANDLEDE bestillinger/`; dubletnøgle = Message-ID, ellers EntryID (`X-Kantine-Noegle`) |
| `tools/indbakke.py` | Samler `.eml` af hent-indbakkes Outlook-eksport (Exchange-headere byte for byte) og laver MS Forms-svar (JSON, skema `kantinebestilling-v1`) om til `.eml` |
| `tools/dagskoersel-tilladelser.json` | Dagskørslens tilladelser: faste allow-præfikser, deny-liste, skrivning kun til ugedata og `Output/Bestillinger/**/*.md|json` |
| `tools/dagskoersel-claude.ps1` | Bygger `claude -p`-kommandolinjen ud fra tilladelsesfilen (`--setting-sources project`, `--strict-mcp-config`, `dontAsk`) |
| `tools/test-dagskoersel-tilladelser.ps1` | Statisk værn: afviser brede regler, `..`, absolut rod, manglende `safe.directory`; `-Mutationer` |
| `tools/test-dagskoersel-scripts.ps1` | Værn for commit-ugefiler, flyt-mail, opret-kladder-kontrol og udgiv-kantine mod en lokal Y:-klon (OEM 850); `-Mutationer` |
| `tools/commit-ugefiler.ps1` | Agentens eneste commit-vej: kun ugemodul (efter hvidliste), ugekort-JSON, menu-PDF, ugekort og infoskærm, kun på main |
| `tools/flyt-mail.ps1` | Flytter en behandlet mail til `FÆRDIGBEHANDLEDE`/`Ikke bestillinger` |
| `tools/sendt-post.ps1` | Viser kladder/sendt post for en uge (mærket/umærket) — kun læsning |
| `tools/udgiv-kantine.ps1` | Udgiver ADM-KANTINE til Y: (tro kopi af `udgiv-til-y.ps1` trin 2–3): ff med `safe.directory`, kopierer kun manglende/nyere filer, aldrig kørbare filer, rydder Y:-UBEHANDLEDE kun ved hash i FÆRDIGBEHANDLEDE/Ikke bestillinger, melder "kun på Y:", og spejler projektmappen 1:1 til `Y:\Kantine\ADM-KANTINE` (arkiv i `Y:\Kantine\_arkiv (Udgiv)`) |
| `tools/kontroller-ugedata.py` | Kør hvidlisten på ugemoduler og ugekort-JSON (gate i `commit-ugefiler.ps1`) |
| `tools/test_indbakke.py`, `tools/test_afstemningsdata.py`, `tools/test-mutationer.py` | Unittests (syntetiske mails/moduler) og mutationsprøver for indbakke, hvidliste og ugekort |
| `Input/Formularbestillinger/` | MS Forms-svar fra Power Automate (JSON); `Behandlet/`, `Fejl/` — gitignored (bestillernavne) |
| `Input/Ikke bestillinger/` | Hentede mails der ikke er bestillinger — gitignored |
| `Output/Kantine - Prisskilt.pdf` | Prisskilt klar til opslag |
| `tools/byg-infoskaerme.py` | Generator: bygger ugens ÉNE infoskærms-PowerPoint `Output/Infoskaerm uge <uge>.pptx` — ét menuslide med ugekortet renderet fra PDF'en. Kræver `python-pptx`, `pypdfium2` |
| `Input/<skaerm>_uge33.pptx` | Historik: uge 33-skærmene med etageplan + tekstmenu (planerne er nu fysiske A-skilte) |
| `Input/floej_c_uge38.pptx` | JSTs skabelon for menuslidet (topbanner + ugekort som billede) |
| `Input/Kantine Ugekort 38.pdf` | JSTs kopi af ugekortet, lagt sammen med skabelonen |
| `Output/Infoskaerm uge <uge>.pptx` | Ugens PowerPoint til alle infoskærme (fra uge 46); `Output/<skaerm>_uge<uge>.pptx` = de tre ens filer til og med uge 46 (historik) |
| `tools/lav-finanskladde.py` | Finanskladde for en JTK-faktura: hver fakturalinje får Type, Anledning/bemærkning, Leverandør og Rekvirent ved match mod ugemodulerne; ark for bestilt vs. faktureret, sammentælling (formler + kontrol mod fakturaen) og fund. Kræver `pdfplumber`, `openpyxl` |
| `Input/Fakturaer/<leverandør>/` | Leverandørfakturaer (PDF) — gitignored (navngiven reference) |
| `Output/Finanskladder/` | Finanskladder pr. faktura — gitignored (rekvirentnavne) |

---

## BI-OPGAVEOVERSIGT — `<OneDrive>\AI SOSU\BI-OPGAVEOVERSIGT\` (repo: [JST-BI/BI-OPGAVEOVERSIGT](https://github.com/JST-BI/BI-OPGAVEOVERSIGT))

Power BI-rapport: medarbejderes opgaveoversigt mod arbejdstidsnorm. Kilde: Budgetskema.xlsx på SharePoint + Studie+-udtræk (Z8004, Z8082).

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: datamodel, ShowRow-grain, normvarianter, rapportfiltre, PBI-/refresh-arbejdsgang |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `Power BI - Opgaveoversigt - Ledere.pbip` | PBIP-projektfil |
| `…SemanticModel/definition/tables/` | `DB Budget underviser og SPS medarbejder.tmdl` (fakta + alle målere), `Arbejdstidsnorm.tmdl`, `L-Kalender.tmdl` |
| `…SemanticModel/definition/expressions.tmdl` | M-queries, bl.a. `UV Medarbejder` og `Støtte Medarbejder` (normvarianterne) |
| `…Report/definition/pages/` | Siderne `Opgaveoversigt - Ledere` og `Forklaring på blokke` |

---

## BI-OPTAG FRAVÆR — `<OneDrive>\AI SOSU\BI-OPTAG FRAVÆR\` (lokalt repo, intet GitHub-remote)

Power BI-rapport: elevoptag og skoleforløbsfravær. Kilde: Studie+-udtræk `Z8312` (alle holdplaceringer) og `Z8224S` (skoleforløbsfravær). Bragt under AI-styring 2026-08-20.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: datagrundlag, målergrupper, agentbrug, skærpet persondata-opmærksomhed |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `SOSU BI OPTAG FRAVÆR.pbip` | PBIP-projektfil |
| `…SemanticModel/definition/tables/` | Målergrupper (`#Measures - ELEV/HRLØN/KPI/TEMATIK/ØKONOMI`), `L-Kalender`, `L-STU Dim…`-dimensioner, `L-STU Fact Z8224S…` |
| `.codex/config.toml` | Codex-projektkonfiguration |

---

## ADM-AFTALER — `<OneDrive>\AI SOSU\ADM-AFTALER\` (lokalt repo, intet GitHub-remote)

Samarbejds- og samhandelsaftaler med eksterne parter. Bragt under AI-styring 2026-08-20. `Input/` er gitignored som forsigtig standard: aftaler indeholder navne og underskrifter, og fortrolighedsniveauet er ikke afklaret.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: versionssammenligning af aftaletekst, juridisk forbehold, persondata |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `.codex/config.toml` | Codex-projektkonfiguration |

---

## ADM-BLANKET — `<OneDrive>\AI SOSU\ADM-BLANKET\` (lokalt repo, intet GitHub-remote)

Administrative blanketter og formularer (i dag kørselsbemyndigelser). Bragt under AI-styring 2026-08-20. `Input/` er gitignored: blanketterne er personhenførbare af natur.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: blanketstruktur, skærpet persondata-advarsel mod `--no-verify` |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `.codex/config.toml` | Codex-projektkonfiguration |

---

## ADM-RETTIGHEDSSTYRING — `<OneDrive>\AI SOSU\ADM-RETTIGHEDSSTYRING\` (lokalt repo, intet GitHub-remote)

Rettighedsstyring på Y:-drevet (`\\sosurdata.net.local\Groups$\Ansatte`): ACL- og
gruppemedlemsudtræk → adgangsoversigter ("hvem har adgang til hvilken mappe", og omvendt
"hvilke mapper har denne person adgang til"). Bragt under AI-styring 2026-09-07.
`Input/` og `Output/` er begge gitignored i deres helhed — persondataholdige, se `AGENTS.md`
→ *Persondata*. Deling af `Output/`-leverancer: kun JST (besluttet 2026-09-07).

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: datamodel (ACL-join, indlejrede grupper), persondataregler, workflow |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `Input/Fællesdrev/udtræk sikkerhedsgrupper.xlsx` | ACL-udtræk: mappe → sikkerhedsgruppe → rettighed (gitignored) |
| `Input/Fællesdrev/Udtræk medlemmer.xlsx` | Gruppemedlemskab: gruppe → medlem (navn, e-mail m.m.) — persondata (gitignored) |
| `tools/byg-rettighedsoversigt.py` | Genbygger Output-oversigten fra de to udtræk; udleder snapshot-dato fra ACL-arkets titel |
| `Output/Rettighedsoversigt Y-drev (data 2026-03-31).xlsx` | Genereret adgangsoversigt: pr.-mappe, pr.-gruppe, detaljeret medlemsliste, pr.-person-oversigt og pr.-person-detalje — persondata (gitignored) |

---

## ADM-BESPARELSER — `<OneDrive>\AI SOSU\ADM-BESPARELSER\` (lokalt repo, intet GitHub-remote)

Personaletilpasninger ved besparelser: procesplaner for afskedigelser og individuelle varslinger
om påtænkt opsigelse (partshøring) efter funktionærlovens § 2. Bragt under AI-styring 2026-10-16.
`Input/` og `Output/` er begge gitignored i deres helhed — navne, CPR og helbredsoplysninger.
**Undtaget fra Udgiv — må aldrig kopieres til Y:** (`$IkkePaaY` i `tools/udgiv-til-y.ps1`, JST 2026-10-16).

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: skærpet persondata, funktionærlovens varselstabel, SD-anciennitet ≠ lønanciennitet |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `tools/generer-varslinger.py` | Udfylder én varsling pr. medarbejder i opsigelsesrunden fra procesplan + skabelon + SD-udtræk; kontrollerer varsler mod § 2 og skriver kontrolrapport |
| `tools/test-ful-varsel.py` | Grænsetilfælde for varselsberegningen (6 mdr., 3/6/9 år, prøvetid) |
| `tools/verificer-varslinger.py` | Tilbagelæsning af genererede varslinger: navn, CPR, rest-pladsholdere, gul markering |
| `Input/Procesplan afskedigelser - 2026-10-19.docx` | Procesplan med medarbejdere pr. opsigelsesrunde og samtaleskema (gitignored) |
| `Input/Varsling om påtænkt opsigelse - SKABELON - 2026-10-19.docx` | Brevskabelon med gulmarkerede pladsholdere (gitignored) |
| `Output/Varslinger oktober 2026/` | Udfyldte varslinger + `Kontrol af opsigelsesvarsler - oktober 2026.md` (gitignored) |

---

## ADM-INSTITUTIONSLANDSKAB — `<OneDrive>\AI SOSU\ADM-INSTITUTIONSLANDSKAB\` (lokalt repo, intet GitHub-remote)

Epx-reformen: skolens tilkendegivelse til STUK (frist 20-01-2027). `Input/` og `Output/` gitignored. Bragt under AI-styring 2026-10-27.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: felter, STUK's aktivitetsdefinition, udfyldning uden at bryde indholdskontrollerne |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `tools/udfyld_tilkendegivelse.py` | Udfylder en KOPI af skabelonen fra en svar-JSON med gul markering; afviser for lange tekster og verificerer at kun felterne er ændret |
| `docs/felter.md` | Alle indholdskontrollers `w:tag` med felt og type |

---

## BI-SOSU — `<OneDrive>\AI SOSU\BI-OEKONOMI\BI-SOSU\` (undermappe i [JST-BI/BI-OEKONOMI](https://github.com/JST-BI/BI-OEKONOMI) siden 13-11-2026; historikken er bevaret, forfatteradresser = GitHub-noreply)

Power BI-rapporten BI_SOSU: de fire FB-tabeller fra DATA-BUDGET_PROGNOSE som matricer med drill. `Input/` og `Output/` gitignored (navne i tabel 2 og 4). Oprettet 2026-11-05. Stierne herunder er relative til undermappen.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: datakilden (FB's flade datatabel, ingen egne beregninger), identitet med FB, persondata |
| `REVIEW.md` | Review-instruktioner (skabelon); importeret i `AGENTS.md` med `@REVIEW.md` |
| `BI_SOSU.pbip` + `BI_SOSU.SemanticModel/` | Model: forespørgslen `Fire tabeller` (to navngivne datafiler fra `BI-OEKONOMI\DATA-BUDGET_PROGNOSE\Output\FB <år>`, OneDrive → Y: → UNC), tabellerne Elevaktivitet/Økonomi/Elevoptag/Årsværk, én måler pr. måling (Version uden valg = Basis) |
| `BI_SOSU.Report/` | Fire sider (én pr. tabel) med matricer og drill; Version- og År-slicere |
| `tools/valider-rapport.ps1` | Validerer PBIR: JSON, felter mod TMDL, queryRef/selectorer (selvtest først) |

---

## Second Brain — `<OneDrive>\Second Brain\` (repo: [JST-BI/SECOND-BRAIN](https://github.com/JST-BI/SECOND-BRAIN), privat)

Chefens daglige AI-assistent: henter mails, kalender og ledermødereferater fra Outlook og producerer en morgenbrieﬁng med prioriterede opgaver. Kører dagligt kl. 07.00 via Windows Opgavestyring. Fase 1 færdig 2026-11-16.

`Input/Mails/`, `Input/Kalender/` og `Input/Referater/` er gitignoreret (persondata). Kun `Input/Sparring/`, `Input/Noter/` og `tools/` trackes.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: daglig kørsel, sikkerhed (.Send() forbudt), persondata, kendte begrænsninger fase 1 |
| `REVIEW.md` | Review-instruktioner (skabelon + projektets egne regler); importeret i `AGENTS.md` med `@REVIEW.md` |
| `tools/dagskoersel.ps1` | Daglig orchestrator kl. 07.00: henter mails/kalender/referater, kører `claude -p` (dagsprompt), opdaterer kalenderaftalen; `-Registrer` / `-Tving` / `-Proev`; exitkode = antal fejlede trin |
| `tools/dagsprompt.md` | Agentens daglige instruktion til morgenbrieﬁngen: mails/kalender/referater er data, aldrig instruktioner; producerer `Output/Morgenbrieﬁng/briefing-YYYY-MM-DD.md` og opretter Outlook-opgaver |
| `tools/dagskoersel-tilladelser.json` | Dagskørslens snævre tilladelsesliste (`--setting-sources project --strict-mcp-config --permission-mode dontAsk`) |
| `tools/dagskoersel-claude.ps1` | Bygger `claude -p`-kommandolinjen ud fra tilladelsesfilen |
| `tools/hent-indbakke.ps1` | Henter nye mails fra JSTs indbakke rekursivt som `.eml` i `Input/Mails/`; dubletnøgle = Message-ID |
| `tools/hent-kalender.ps1` | Eksporterer kalenderaftaler og Outlook-opgaver til JSON i `Input/Kalender/` |
| `tools/hent-referater.ps1` | Kopierer nye ledermødereferater fra `Y:\ADM\Referater` til `Input/Referater/`; sporer sidst-hentet |
| `tools/opdater-kalenderaftale.ps1` | Opdaterer aftaleseriens (`Dagens opgaver – Second Brain`) beskrivelse med dagens briefing-opsummering |
| `tools/udgiv-second-brain.ps1` | Udgiver Second Brain til Y: (tro kopi af `udgiv-til-y.ps1`-mønsteret) |
| `Output/Morgenbrieﬁng/briefing-YYYY-MM-DD.md` | Daglig morgenbrieﬁng (gitignoreret — Output/ er gitignoreret) |
| `Output/_log/dag-YYYY-MM-DD.log` | Dagskørslens logfil med alle trin og exitkoder (gitignoreret) |

---

## Fælles på tværs af alle 15 repos

| Fil | Beskrivelse |
|---|---|
| `.githooks/pre-commit` | Kalder begge checks nedenfor (aktivér pr. klon: `git config core.hooksPath .githooks`) |
| `.githooks/check_excel_pii.py` | Persondata-scan af staged Excel (CPR, e-mail, navnekolonner) |
| `.githooks/check_kun_agents_md.py` | Blokerer commit af `CLAUDE.md`, `CLAUDE.local.md` og `.claude/CLAUDE.md` |
| `.githooks/README.md` | Aktiveringsvejledning efter clone |
| `.codex/config.toml` | Codex-projektkonfiguration fra `AI OS/tools/codex-config.template.toml` |
| `.gitattributes` | `eol=lf` på hook-filerne, ellers `* text=auto` |
| `.gitignore` | Bl.a. Excel-/rådata-ignorering hvor relevant |
| `_Arkiv/` | Udgåede versioner (projekt-repos) |

**15 repos** = AI OS + 14 projekter (13 i AI SOSU + Second Brain; DATA-BUDGET_PROGNOSE og BI-SOSU er undermapper i BI-OEKONOMI siden 13-11-2026). Seks af dem (`BI-OPTAG FRAVÆR`, `ADM-AFTALER`, `ADM-BLANKET`, `ADM-RETTIGHEDSSTYRING`, `ADM-BESPARELSER`, `ADM-INSTITUTIONSLANDSKAB`) har lokale git-repos uden GitHub-remote, indtil fortrolighedsniveauet er afklaret med JST. `Second Brain` er på GitHub som privat repo ([JST-BI/SECOND-BRAIN](https://github.com/JST-BI/SECOND-BRAIN)).

**Bemærk (kun Claude Code)**: Claude Codes persistente hukommelse ligger lokalt under `~/.claude/projects/<AI OS-projekt>/memory/` med eget indeks `MEMORY.md` — den er personlig, ikke versionsstyret og ikke en del af repo-strukturen.

## BI-OEKONOMI: PA manual profiles and cross-type correction (candidate evidence)

| Fil | Beskrivelse |
|---|---|
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/README.md` | Scope, superseded results and remaining integration boundary |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-cross-type-independent-expected.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-planned-entry-outer-full187-r6/budget-adjusted-planned-entry-points.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-planned-entry-outer-full187-r6/budget-outer-query.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-planned-entry-outer-full187-r6/independent-point-reference.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-planned-entry-outer-full187-r6/independent-pool-bin-reference.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-planned-entry-outer-full187-r6/input-manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-planned-entry-outer-full187-r6/physical-allocation-reference.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-planned-entry-outer-full187-r6/root-stdout.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/cross-type-supplementary-independent-expected.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/forecast-all150-cross-type-audit-r1.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/forecast-cross-type-independent-review.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/forecast-financial-cross-type-independent-review.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/full187-budget-engine-verifier-tests/quality.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-nonfaerta-financial-r3/actual-financial.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-nonfaerta-financial-r3/forecast-financial-by-academic-type.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-nonfaerta-financial-r3/forecast-financial-shadow.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-nonfaerta-financial-r3/independent-reference.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-nonfaerta-financial-r3/input-manifest-before-byte-fix.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-nonfaerta-financial-r3/input-manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-nonfaerta-financial-r3/query-byte-hash-amendment.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-nonfaerta-financial-r3/root-stdout.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-nonfaerta-financial-r3/verification.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-physical-forecast-r4/contributions.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-physical-forecast-r4/manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-physical-forecast-r4/manual-physical-contributions.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-physical-forecast-r4/manual-physical-points.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-physical-forecast-r4/manual-physical.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-physical-forecast-r4/reference-contributions.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-physical-forecast-r4/reference.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-physical-forecast-r4/root-stdout.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/manual-physical-forecast-r4/verification.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/package-manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/root-cross-type-engine-independent-proof.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/target-auxiliary-membership-r10/target-auxiliary-membership.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/README.md` | Scope, superseded results and remaining integration boundary |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/academic-scenario-aj-r2/academic-scenario-query.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/academic-scenario-aj-r2/adjusted-academic-scenario-profiles.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/academic-scenario-aj-r2/binding-effect-tests.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/academic-scenario-aj-r2/input-manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/academic-scenario-aj-r2/root-stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/academic-scenario-aj-r2/scenario-inputs.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/budget-financial-registration-r2/actual-financial-registration.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/budget-financial-registration-r2/dated-first-registration-ledger-candidate.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/budget-financial-registration-r2/manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/budget-financial-registration-r2/reference.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/budget-financial-registration-r2/root-stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/budget-financial-registration-r2/verification.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/combined-manual-by-type-r2/combined-forecast.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/combined-manual-by-type-r2/combined-ledger-candidate.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/combined-manual-by-type-r2/manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/combined-manual-by-type-r2/normalized-safe-inputs.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/combined-manual-by-type-r2/reference.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/combined-manual-by-type-r2/reused-r1-root-stdout.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/combined-manual-by-type-r2/verification.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/financial-registration-shared-alpha-cached-r1/actual-financial-registration.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/financial-registration-shared-alpha-cached-r1/dated-first-registration-ledger-candidate.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/financial-registration-shared-alpha-cached-r1/manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/financial-registration-shared-alpha-cached-r1/reference.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/financial-registration-shared-alpha-cached-r1/root-stdout.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/financial-registration-shared-alpha-cached-r1/verification.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/manual-nonfaerta-financial-r2/actual-financial.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/manual-nonfaerta-financial-r2/forecast-financial-shadow.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/manual-nonfaerta-financial-r2/independent-reference.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/manual-nonfaerta-financial-r2/input-manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/manual-nonfaerta-financial-r2/root-stdout.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/manual-nonfaerta-financial-r2/verification.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/manual-physical-forecast-r3/contributions.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/manual-physical-forecast-r3/manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/manual-physical-forecast-r3/manual-physical-points.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/manual-physical-forecast-r3/manual-physical.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/manual-physical-forecast-r3/reference.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/manual-physical-forecast-r3/root-stdout.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/actual/manual-physical-forecast-r3/verification.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/binding-proofs/budget-financial-registration-binding-tests/results.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/binding-proofs/financial-shared-alpha-binding-tests/results.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/binding-proofs/manual-combined-binding-effects-r2/results.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/binding-proofs/manual-financial-binding-tests/results.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/24065-donor-net-contribution-audit.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/26065-future-placement-allocation.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/26065-historical-allocation-donor-inventory.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/Output/power-query/kalenderprofil/manual-aj-policy/fxManualAJStatePolicy.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/Output/reviews/kalenderprofil-2026-10-16/actual-age-bins-diagnostic.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/Output/reviews/kalenderprofil-2026-10-16/pa-active-anchor-contract.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/Output/reviews/kalenderprofil-2026-10-16/pa-trajectory/CalendarProfiles-review.xlsx` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/Output/reviews/kalenderprofil-2026-10-16/pa-trajectory/actual-source-binding-proof.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/Output/reviews/kalenderprofil-2026-10-16/pa-trajectory/calendar-workbook-qa.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/Output/reviews/kalenderprofil-2026-10-16/pa-trajectory/pa-trajectory-metadata.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/Output/reviews/kalenderprofil-2026-10-16/pa-trajectory/pa-trajectory-points.csv` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/Output/reviews/kalenderprofil-2026-10-16/raw-calendar-profile-metadata.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/Output/reviews/kalenderprofil-2026-10-16/source52-history-confirmation.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/Rapporter/HR_OEKONOMI/HR_OEKONOMI.SemanticModel/definition/expressions.tmdl` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/Rapporter/HR_OEKONOMI/HR_OEKONOMI.SemanticModel/definition/tables/STU-GEN-HoldIntake-Budget.tmdl` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/Rapporter/HR_OEKONOMI/HR_OEKONOMI.SemanticModel/definition/tables/STU-GEN-HoldIntake-Prognose.tmdl` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/actual-observation-map/actual-observation-map-safe-capture.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/actual-observation-map/donor-target-calendar-capture.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/budget-entry-financial-eligibility/entry-financial-eligibility.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/budget-entry-net-audit/entry-native-net-audit.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/calendar-absorbed/fxFinancialRegistrationForecastSharedAlphaCached.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/calendar-absorbed/fxFinancialSharedAlphaStatePolicy.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/calendar-absorbed/fxPlannedFinancialRegistration.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/calendar-absorbed/fxWeightedPhysicalAllocation.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/calendar-financial-kernel/actual-input-boundary-audit.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/calendar-financial-kernel/fxPAAllocatedFinancialKernel.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/cohort-manual-aj/fxCohortManualAJPolicy.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/pa-combined-forecast/fxPACombinedForecastManualByType.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/pa-financial-registration-aj-v2/financial-registration-metadata.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/pa-financial-registration-aj-v2/financial-registration-state-points.csv` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/pa-rate-provenance.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/pa-trajectories-aggregates.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/pa-trajectory-candidate-points-canonical.csv` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/pa26065-actual-financial-dates-safe.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/pa26065-actual-source52-safe.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/pa26065-intake-Budget.dax` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/pa26065-intake-Prognose.dax` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/pa26065-scenario-intake.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/planned-entry/fxPlannedEntryConsumer.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/source52-schema.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/trajectory-allocated-composition-r2/actual-composition.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/trajectory-allocated-composition-r2/actual-points-MODELANTAGELSE-candidate.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/trajectory-allocated-composition-r2/verification.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/trajectory-tail-prepared-final/actual-stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/trajectory-tail-prepared-final/independent-reference.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/trajectory-tail-prepared-final/input-manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/trajectory-tail-prepared-final/verification.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/trajectory-weighted-composition-r3c/actual-points-MODELANTAGELSE-weighted.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/trajectory-weighted-composition-r3c/actual-weighted-composition.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/trajectory-weighted-composition-r3c/manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/trajectory-weighted-composition-r3c/reference.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/trajectory-weighted-composition-r3c/root-stdout.json.gz` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/bound-inputs/trajectory-weighted-composition-r3c/verification.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/financial-shared-alpha-cached-harness-proof/ignore-alpha-mutant.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/financial-shared-alpha-cached-harness-proof/normal.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/financial-shared-alpha-cached-harness-proof/summary.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-effects-root/actual-basis.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-effects-root/actual-basis.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-effects-root/future-plan.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-effects-root/future-plan.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-effects-root/monthly-axis.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-effects-root/monthly-axis.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-effects-root/normal.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-effects-root/normal.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-effects-root/null-sum.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-effects-root/null-sum.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-effects-root/proof.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-physical-independent-effects/missing-as-zero.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-physical-independent-effects/missing-as-zero.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-physical-independent-effects/normal.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-physical-independent-effects/normal.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-physical-independent-effects/proof.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-physical-independent-effects/wrong-denominator.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/manual-physical-independent-effects/wrong-denominator.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/planned-financial-harness-proof-v2/fullpool-per-origin-mutant.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/planned-financial-harness-proof-v2/normal.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/effect-proofs/planned-financial-harness-proof-v2/summary.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/helpers/BUDGET-FINANCIAL-REGISTRATION-CONTRACT.md` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/helpers/FINANCIAL-COMPONENT-EVIDENCE.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/helpers/FINANCIAL-MANUAL-ALPHA-CONTRACT.md` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/independent-proofs/budget-financial-independent-audit.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/independent-proofs/financial-shared-alpha-cached-reference-equivalence.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/independent-proofs/manual-financial-independent-audit.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/package-manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/reviews/pa-manual-academic-physical-application-gate.md` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/reviews/pa-manual-financial-component-gate.md` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/synthetic-queries/financial-shared-alpha-cached-ignore-alpha-mutant.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/synthetic-queries/financial-shared-alpha-cached-normal.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/synthetic-queries/planned-financial-fullpool-per-origin-mutant.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-manual-scenario-candidate/synthetic-queries/planned-financial-normal.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/DATAKILDER.source163-proposal.xlsx` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/PACKAGE.md` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/README.md` | Scope, superseded results and remaining integration boundary |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/actual-loader-r2/actual-source163-loader.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/actual-loader-r2/manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/actual-loader-r2/root-with-local-folder.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/actual-loader-r2/verification.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/after.png` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/before.png` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/fxCalendarProfileWorkbook163.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/fxSelectCalendarWorkbook163.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/install-plan.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/package-manifest.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/selection-engine-proof.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/selection-engine.stdout.json` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/source163-registry-proposal/source163-selection-harness.m` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-cross-type-correction/audit-forecast-cross-type-membership.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-cross-type-correction/build-budget-planned-entry-outer.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-cross-type-correction/build-manual-physical-forecast-cross-type.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-cross-type-correction/calendar-financial-kernel/build-cross-type-manual-financial.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-cross-type-correction/test-full187-budget-engine-verifier.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-cross-type-correction/verify-package.py` | Portable archive verification without raw sources or old temp files |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/bound-code/audit-budget-entry-financial-eligibility.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/bound-code/audit-pa-completion-source52.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/bound-code/audit-pa-entry-net-and-budget-mix.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/bound-code/audit-pa-future-placement-allocation.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/bound-code/build-academic-scenario-aj.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/bound-code/build-manual-physical-forecast.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/bound-code/build-pa-financial-registration-aj.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/bound-code/inspect-source52-schema.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/bound-code/tools/kalenderprofil/build-pa-education-trajectories.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/bound-code/tools/kalenderprofil/build-raw-calendar-empirical-profile.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/bound-code/tools/kalenderprofil/pa-trajectory-source.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/combined/build-combined-forecast-manual-by-type.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/combined/test-manual-combined-bindings.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/independent-budget-financial-audit.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/independent-manual-financial-audit.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/nonfaerta/build-manual-financial-candidate.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/nonfaerta/test-manual-financial-bindings.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/nonfaerta/verify-manual-financial-candidate.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/registration/build-budget-financial-registration.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/registration/build-financial-registration-shared-alpha-cached.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/registration/build-financial-shared-alpha-cached.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/registration/build-financial-shared-alpha-harness.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/registration/build-financial-shared-alpha.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/registration/build-planned-financial-harness.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/registration/build-planned-financial-helper.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/registration/test-financial-registration-bindings.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/review-manual-combined-effects.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/test-academic-scenario-bindings.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa-manual-scenario-candidate/verify-package.py` | Portable archive verification without raw sources or old temp files |
| `BI-OEKONOMI/tools/kalenderprofil/source163-registry-proposal/build-registry.mjs` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/source163-registry-proposal/prepare-actual-loader.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/source163-registry-proposal/prepare-native-registry.py` | Byte-bound candidate evidence; production integration pending |
| `BI-OEKONOMI/tools/kalenderprofil/source163-registry-proposal/verify-package.py` | Portable archive verification without raw sources or old temp files |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/root-budget-financial-independent-review.json` | Budget financial R3: engine evidence and independent source/rate reconciliation |
| `BI-OEKONOMI/tools/kalenderprofil/pa-cross-type-correction/root-budget-financial-independent.py` | Budget financial R3: engine evidence and independent source/rate reconciliation |
| `BI-OEKONOMI/tools/kalenderprofil/pa-cross-type-correction/calendar-financial-kernel/build-budget-cross-type-financial.py` | Budget financial R3: engine evidence and independent source/rate reconciliation |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-nonfaerta-financial-r3/actual-financial.m` | Budget financial R3: engine evidence and independent source/rate reconciliation |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-nonfaerta-financial-r3/input-manifest.json` | Budget financial R3: engine evidence and independent source/rate reconciliation |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-nonfaerta-financial-r3/independent-reference.json.gz` | Budget financial R3: engine evidence and independent source/rate reconciliation |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-nonfaerta-financial-r3/root-stdout.json.gz` | Budget financial R3: engine evidence and independent source/rate reconciliation |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-nonfaerta-financial-r3/budget-financial-shadow.json.gz` | Budget financial R3: engine evidence and independent source/rate reconciliation |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-nonfaerta-financial-r3/budget-financial-by-academic-type.json.gz` | Budget financial R3: engine evidence and independent source/rate reconciliation |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa-cross-type-correction/budget-nonfaerta-financial-r3/verification.json` | Budget financial R3: engine evidence and independent source/rate reconciliation |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPACurrentSourceGuard.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPACurrentScenarioIntake.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPAManualAcademic.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPAForecastPhysical.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPABudgetPhysical.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPAManualPhysicalFinance.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPAManualFinancialRegistrations.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPAManualRuntimeProducer.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPABoundRuntimeInputs.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPANormalizeRuntimeLedgerInputs.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPALoadCurrentManualInputs.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPALockedSourceFiles.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPA26065ExpectedInputs.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPA26065RuntimeProducer.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPAMaterializedAcademic.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxCalendarProfileSource.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxCohortManualAJPolicy.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxManualAJStatePolicy.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPAAllocatedFinancialKernel.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxFinancialRegistrationForecastSharedAlphaCached.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPlannedFinancialRegistration.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxCalendarProfileWorkbook163.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxSelectCalendarWorkbook163.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPA26065CombinedRuntimeLedger.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/M/fxPA26065RuntimeBoundary.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/data/runtime-static-inputs.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/proofs/entry_audit.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/proofs/donor_audit.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/proofs/planned_consumer.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/proofs/auxiliary_audit.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/proofs/original_physical_capture.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/proofs/target_membership.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/proofs/existing_target_allocation.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/python/source_lease.py` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/python/portable-runtime.py` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/README.md` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/bundle/manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/ACTIVATION-PLAN.md` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/change-manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/check-isolated-candidate.py` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/definition/expressions.tmdl` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/definition/model.tmdl` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/definition/tables/#Measures - OKO.tmdl` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/definition/tables/#Measures - STU.tmdl` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/definition/tables/STU-GEN-PA26065-Komponentledger.tmdl` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/definition/tables/STU-GEN-PA26065-Runtimestatus.tmdl` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/integration.diff` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/package-manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/PORTABLE-CANDIDATE-CHECK.md` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/preparation-proof.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/query-scoped-visible-status-r1.dax` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/README.md` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/visible-status-r1-independent-review.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/visible-status-r1-manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/visible-status-r1-root.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/actual-live-r2/verification.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/actual-live-r2/independent-review.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/actual-live-r2/complete-runtime-aggregate.json.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/actual-live-r2/root-independent-complete-reconciliation.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/actual-live-r2/root-source17-and-buffer-parity.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/prepare-pin-effects-r5/results.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/prepare-pin-effects-independent-r5/results.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/source-lease-root/fixture-proof-r2.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/source-lease-root/crash-fixture-proof.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/source-lease-root/actual-hash-only-proof.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/source-lease-root/independent-source-lease-review-r1.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/source-lease-root/independent-lease-edge-report.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/source-lease-root/runtime-source-inventory-aggregate.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/runtime/historical-source-pins-for-runtime.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/runtime-barrier-independent-r3/formula-diff-proof.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/runtime-barrier-independent-r3/independent-review.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/runtime-barrier-independent-r3/manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/runtime-barrier-independent-r3/root-stdout.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/runtime-barrier-independent-r3/runtime-barrier-independent.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/runtime-boundary-independent/independent-review.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/runtime-boundary-independent/manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/runtime-boundary-independent/normal.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/runtime-boundary-independent/root-stdout.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/runtime-combined-independent/independent-review.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/runtime-combined-independent/manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/runtime-combined-independent/normal.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/runtime-combined-independent/root-stdout.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/composition-r6/independent-review.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/composition-r6/manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/composition-r6/normal-root-stdout.json.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/composition-r6/normal.m.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/academic-forecast-r2/f-ignored-mutant-root-stdout.json.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/academic-forecast-r2/f-ignored-mutant.m.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/academic-forecast-r2/manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/academic-forecast-r2/normal-root-stdout.json.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/academic-forecast-r2/normal.m.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/academic-forecast-r2/point-manual-ignored-mutant-root-stdout.json.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/academic-forecast-r2/point-manual-ignored-mutant.m.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/budget-physical-r2/budget-dynamic-guard-effects-qa.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/budget-physical-r2/budget-dynamic-guard-effects-root-stdout.json.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/budget-physical-r2/budget-dynamic-guard-effects.m.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/budget-physical-r2/budget-dynamic-manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/budget-physical-r2/budget-dynamic-normal.m.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/budget-physical-r2/budget-dynamic-parity-qa.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/budget-physical-r2/budget-dynamic-root-stdout.json.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/budget-physical-r2/budget-source-proof-template.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/budget-physical-r2/fxPABudgetPhysical.m.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/current-intake-r2/fxPACurrentScenarioIntake.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/current-intake-r2/guard-manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/current-intake-r2/ignore-date-count-mutant-root-stdout.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/current-intake-r2/ignore-date-count-mutant.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/current-intake-r2/independent-review.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/current-intake-r2/normal-root-stdout.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/current-intake-r2/normal.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/live-path-fixtures-r3/consumed-path-ignored-mutant-root-stdout.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/live-path-fixtures-r3/consumed-path-ignored-mutant.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/live-path-fixtures-r3/independent-review.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/live-path-fixtures-r3/manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/live-path-fixtures-r3/normal-root-stdout.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/live-path-fixtures-r3/normal.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/live-path-fixtures-r3/synthetic-other.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/live-path-fixtures-r3/synthetic-payload.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/runtime-input-types-r2/fxPABoundRuntimeInputs.m` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/runtime-input-types-r2/root-stdout.json.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/runtime-input-types-r2/targeted-type-diagnostic.m.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/candidate-69-compile-r1-independent-review.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/candidate-69-outside-r1-independent-review.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/runtime-ready-effects-r1-independent-review.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/visible-status-r1-independent-review.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/visible-status-r1-manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/isolated-model-consumer-69-probe-r1-manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/manual-dax-r5-manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/manual-consumer-build-proof.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/candidate-69-compile-r1-root.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/candidate-69-compile-r1-root.dax.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/candidate-69-outside-baseline-r1-root.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/candidate-69-outside-baseline-r1-root.dax` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/runtime-ready-effects-r1-root.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/runtime-ready-effects-r1-root.dax` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/visible-status-r1-root.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/visible-status-r1-root.dax` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/manual-scope-ownership-r5-root.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/manual-scope-ownership-r5-root.dax.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/manual-scope-detail-mutant-r5-root.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/manual-scope-detail-mutant-r5-root.dax.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/manual-actual-owner-mutant-r5-root.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/manual-actual-owner-mutant-r5-root.dax.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/actual-headcount-mask-audit-r1-root.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/actual-headcount-mask-audit-r1-root.dax` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/audit-code/reconcile-complete-runtime-root.py` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/audit-code/source-lease-root/test_source_lease_r2.py` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/audit-code/source-lease-root/test_source_lease_crash.py` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/audit-code/source-lease-root/synthetic_crash_child.py` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/audit-code/source-lease-root/independent-lease-edge-test.py` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/audit-code/pa-combined-forecast/build-isolated-model-candidate.py` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/candidate-69-outside-baseline-r1.dax` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/dax-consumer-closure.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/dax-source-measure-bodies.json.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/isolated-model-candidate-r9/portable-integrity-proof.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/query-scoped-candidate-69-compile-r1-manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/query-scoped-candidate-69-compile-r1.dax.gz` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/query-scoped-runtime-ready-effects-r1-manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/pa-combined-forecast/query-scoped-runtime-ready-effects-r1.dax` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/portable-default-api-proof-r5/results.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/portable-bundle-proof-r6/results.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/final-runtime-aggregate-pii-scan.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/README.md` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-runtime/verify-package.py` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/portable-runpy-independent-r5-result.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/portable-effects-independent-r5/results.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/dynamic-manual-runtime/live-assembly-r5/manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/pa26065-dynamic-runtime-independent-gate.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/pa26065-portable-runtime-independent-supplement.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/package-manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/model-r9-metadata/change-manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/evidence/model-r9-metadata/package-manifest.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model/metadata-only-proof.json` | PA26065: reviewed headless runtime, isolated model and aggregate validation; production activation pending |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/EVIDENCE.md` | PA26065: R2 evidence - independent reviews of 3d5 and R2, tests and mutation results |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/mutations-3d5-28.json` | PA26065: R2 evidence - independent reviews of 3d5 and R2, tests and mutation results |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/mutations-r2-28.json` | PA26065: R2 evidence - independent reviews of 3d5 and R2, tests and mutation results |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/mutations-r2-fresh10.json` | PA26065: R2 evidence - independent reviews of 3d5 and R2, tests and mutation results |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/review-3d5.json` | PA26065: R2 evidence - independent reviews of 3d5 and R2, tests and mutation results |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/review-3d5.md` | PA26065: R2 evidence - independent reviews of 3d5 and R2, tests and mutation results |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/review-r2.md` | PA26065: R2 evidence - independent reviews of 3d5 and R2, tests and mutation results |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/scripts/fresh-mutants-reviewer.py` | PA26065: R2 evidence - independent reviews of 3d5 and R2, tests and mutation results |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/scripts/mutate-r2.py` | PA26065: R2 evidence - independent reviews of 3d5 and R2, tests and mutation results |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/scripts/testwrap.py` | PA26065: R2 evidence - independent reviews of 3d5 and R2, tests and mutation results |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/tests-r2.json` | PA26065: R2 evidence - independent reviews of 3d5 and R2, tests and mutation results |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r2/initial-activation-tests.json` | PA26065: initial activation CLI R2 (read-only candidate; supersedes unarchived 3d5); production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r2/runtime-cli/README.md` | PA26065: initial activation CLI R2 (read-only candidate; supersedes unarchived 3d5); production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r2/runtime-cli/activation_core.py` | PA26065: initial activation CLI R2 (read-only candidate; supersedes unarchived 3d5); production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r2/runtime-cli/adomd-session.ps1` | PA26065: initial activation CLI R2 (read-only candidate; supersedes unarchived 3d5); production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r2/runtime-cli/baseline.json.gz` | PA26065: initial activation CLI R2 (read-only candidate; supersedes unarchived 3d5); production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r2/runtime-cli/manifest.json` | PA26065: initial activation CLI R2 (read-only candidate; supersedes unarchived 3d5); production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r2/runtime-cli/model-contract.json` | PA26065: initial activation CLI R2 (read-only candidate; supersedes unarchived 3d5); production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r2/runtime-cli/pa-initial-activation.py` | PA26065: initial activation CLI R2 (read-only candidate; supersedes unarchived 3d5); production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r2/test-fake-adomd.cs` | PA26065: initial activation CLI R2 (read-only candidate; supersedes unarchived 3d5); production activation pending |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r2/test-initial-activation.py` | PA26065: initial activation CLI R2 (read-only candidate; supersedes unarchived 3d5); production activation pending |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/iso-engine-transaction-result.json` | PA26065: R2 engine test on a throw-away database - Rollback undoes TMSL refresh, DateTime without offset |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/scripts/iso-engine-transaction.ps1` | PA26065: R2 engine test on a throw-away database - Rollback undoes TMSL refresh, DateTime without offset |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/scripts/iso-helper.ps1` | PA26065: R2 engine test on a throw-away database - Rollback undoes TMSL refresh, DateTime without offset |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/scripts/iso-transaction-test.py` | PA26065: R2 engine test on a throw-away database - Rollback undoes TMSL refresh, DateTime without offset |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/production-activation-2026-10-18.json` | PA26065: production activation in HR_OEKONOMI 2026-10-18 - InitialBaselineCommitted, cold-reopen proof (aggregates only) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r11/change-manifest.json` | PA26065: model candidate R11 (gate #103 round-1 fixes; activated 2026-10-18 with CLI R3) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r11/definition/expressions.tmdl` | PA26065: model candidate R11 (gate #103 round-1 fixes; activated 2026-10-18 with CLI R3) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r11/definition/model.tmdl` | PA26065: model candidate R11 (gate #103 round-1 fixes; activated 2026-10-18 with CLI R3) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r11/definition/tables/#Measures - OKO.tmdl` | PA26065: model candidate R11 (gate #103 round-1 fixes; activated 2026-10-18 with CLI R3) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r11/definition/tables/#Measures - STU.tmdl` | PA26065: model candidate R11 (gate #103 round-1 fixes; activated 2026-10-18 with CLI R3) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r11/definition/tables/STU-GEN-PA26065-Komponentledger.tmdl` | PA26065: model candidate R11 (gate #103 round-1 fixes; activated 2026-10-18 with CLI R3) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r11/definition/tables/STU-GEN-PA26065-Runtimestatus.tmdl` | PA26065: model candidate R11 (gate #103 round-1 fixes; activated 2026-10-18 with CLI R3) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r12/change-manifest.json` | PA26065: model candidate R12 (round-2 fixes) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r12/definition/expressions.tmdl` | PA26065: model candidate R12 (round-2 fixes) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r12/definition/model.tmdl` | PA26065: model candidate R12 (round-2 fixes) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r12/definition/tables/#Measures - OKO.tmdl` | PA26065: model candidate R12 (round-2 fixes) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r12/definition/tables/#Measures - STU.tmdl` | PA26065: model candidate R12 (round-2 fixes) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r12/definition/tables/STU-GEN-PA26065-Komponentledger.tmdl` | PA26065: model candidate R12 (round-2 fixes) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r12/definition/tables/STU-GEN-PA26065-Runtimestatus.tmdl` | PA26065: model candidate R12 (round-2 fixes) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r13/change-manifest.json` | PA26065: model candidate R13 (round-3 performance fix) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r13/definition/expressions.tmdl` | PA26065: model candidate R13 (round-3 performance fix) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r13/definition/model.tmdl` | PA26065: model candidate R13 (round-3 performance fix) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r13/definition/tables/#Measures - OKO.tmdl` | PA26065: model candidate R13 (round-3 performance fix) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r13/definition/tables/#Measures - STU.tmdl` | PA26065: model candidate R13 (round-3 performance fix) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r13/definition/tables/STU-GEN-PA26065-Komponentledger.tmdl` | PA26065: model candidate R13 (round-3 performance fix) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r13/definition/tables/STU-GEN-PA26065-Runtimestatus.tmdl` | PA26065: model candidate R13 (round-3 performance fix) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r14/change-manifest.json` | PA26065: model candidate R14 (KILDEVAERN outermost in 64 measures) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r14/definition/expressions.tmdl` | PA26065: model candidate R14 (KILDEVAERN outermost in 64 measures) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r14/definition/model.tmdl` | PA26065: model candidate R14 (KILDEVAERN outermost in 64 measures) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r14/definition/tables/#Measures - OKO.tmdl` | PA26065: model candidate R14 (KILDEVAERN outermost in 64 measures) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r14/definition/tables/#Measures - STU.tmdl` | PA26065: model candidate R14 (KILDEVAERN outermost in 64 measures) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r14/definition/tables/STU-GEN-PA26065-Komponentledger.tmdl` | PA26065: model candidate R14 (KILDEVAERN outermost in 64 measures) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r14/definition/tables/STU-GEN-PA26065-Runtimestatus.tmdl` | PA26065: model candidate R14 (KILDEVAERN outermost in 64 measures) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r15/change-manifest.json` | PA26065: model candidate R15 (source fingerprint required by both PA ready measures) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r15/definition/expressions.tmdl` | PA26065: model candidate R15 (source fingerprint required by both PA ready measures) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r15/definition/model.tmdl` | PA26065: model candidate R15 (source fingerprint required by both PA ready measures) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r15/definition/tables/#Measures - OKO.tmdl` | PA26065: model candidate R15 (source fingerprint required by both PA ready measures) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r15/definition/tables/#Measures - STU.tmdl` | PA26065: model candidate R15 (source fingerprint required by both PA ready measures) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r15/definition/tables/STU-GEN-PA26065-Komponentledger.tmdl` | PA26065: model candidate R15 (source fingerprint required by both PA ready measures) |
| `BI-OEKONOMI/Output/power-query/kalenderprofil/pa26065-runtime/model-r15/definition/tables/STU-GEN-PA26065-Runtimestatus.tmdl` | PA26065: model candidate R15 (source fingerprint required by both PA ready measures) |
| `BI-OEKONOMI/Output/reviews/kalenderprofil-2026-10-16/initial-activation-r2/production-reactivation-r3-2026-10-18.json` | PA26065: re-activation with CLI R3 2026-10-18 after gate #103 round 1 (aggregates only) |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r3/build-candidate-r11.py` | PA26065: initial activation CLI R3 (contract from candidate R11 after gate #103 round 1; used for the 2026-10-18 re-activation); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r3/build-contract-r3.py` | PA26065: initial activation CLI R3 (contract from candidate R11 after gate #103 round 1; used for the 2026-10-18 re-activation); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r3/initial-activation-tests.json` | PA26065: initial activation CLI R3 (contract from candidate R11 after gate #103 round 1; used for the 2026-10-18 re-activation); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r3/runtime-cli/README.md` | PA26065: initial activation CLI R3 (contract from candidate R11 after gate #103 round 1; used for the 2026-10-18 re-activation); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r3/runtime-cli/activation_core.py` | PA26065: initial activation CLI R3 (contract from candidate R11 after gate #103 round 1; used for the 2026-10-18 re-activation); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r3/runtime-cli/adomd-session.ps1` | PA26065: initial activation CLI R3 (contract from candidate R11 after gate #103 round 1; used for the 2026-10-18 re-activation); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r3/runtime-cli/baseline.json.gz` | PA26065: initial activation CLI R3 (contract from candidate R11 after gate #103 round 1; used for the 2026-10-18 re-activation); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r3/runtime-cli/manifest.json` | PA26065: initial activation CLI R3 (contract from candidate R11 after gate #103 round 1; used for the 2026-10-18 re-activation); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r3/runtime-cli/model-contract.json` | PA26065: initial activation CLI R3 (contract from candidate R11 after gate #103 round 1; used for the 2026-10-18 re-activation); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r3/runtime-cli/pa-initial-activation.py` | PA26065: initial activation CLI R3 (contract from candidate R11 after gate #103 round 1; used for the 2026-10-18 re-activation); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r3/test-fake-adomd.cs` | PA26065: initial activation CLI R3 (contract from candidate R11 after gate #103 round 1; used for the 2026-10-18 re-activation); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r3/test-initial-activation.py` | PA26065: initial activation CLI R3 (contract from candidate R11 after gate #103 round 1; used for the 2026-10-18 re-activation); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r4/build-candidate-r12.py` | PA26065: initial activation CLI R4 (contract from candidate R12 after gate round 2); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r4/build-contract-r4.py` | PA26065: initial activation CLI R4 (contract from candidate R12 after gate round 2); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r4/initial-activation-tests.json` | PA26065: initial activation CLI R4 (contract from candidate R12 after gate round 2); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r4/runtime-cli/README.md` | PA26065: initial activation CLI R4 (contract from candidate R12 after gate round 2); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r4/runtime-cli/activation_core.py` | PA26065: initial activation CLI R4 (contract from candidate R12 after gate round 2); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r4/runtime-cli/adomd-session.ps1` | PA26065: initial activation CLI R4 (contract from candidate R12 after gate round 2); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r4/runtime-cli/baseline.json.gz` | PA26065: initial activation CLI R4 (contract from candidate R12 after gate round 2); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r4/runtime-cli/manifest.json` | PA26065: initial activation CLI R4 (contract from candidate R12 after gate round 2); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r4/runtime-cli/model-contract.json` | PA26065: initial activation CLI R4 (contract from candidate R12 after gate round 2); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r4/runtime-cli/pa-initial-activation.py` | PA26065: initial activation CLI R4 (contract from candidate R12 after gate round 2); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r4/test-fake-adomd.cs` | PA26065: initial activation CLI R4 (contract from candidate R12 after gate round 2); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r4/test-initial-activation.py` | PA26065: initial activation CLI R4 (contract from candidate R12 after gate round 2); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r5/build-candidate-r13.py` | PA26065: initial activation CLI R5 (contract from candidate R13, round-3 performance fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r5/build-contract-r5.py` | PA26065: initial activation CLI R5 (contract from candidate R13, round-3 performance fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r5/initial-activation-tests.json` | PA26065: initial activation CLI R5 (contract from candidate R13, round-3 performance fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r5/runtime-cli/README.md` | PA26065: initial activation CLI R5 (contract from candidate R13, round-3 performance fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r5/runtime-cli/activation_core.py` | PA26065: initial activation CLI R5 (contract from candidate R13, round-3 performance fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r5/runtime-cli/adomd-session.ps1` | PA26065: initial activation CLI R5 (contract from candidate R13, round-3 performance fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r5/runtime-cli/baseline.json.gz` | PA26065: initial activation CLI R5 (contract from candidate R13, round-3 performance fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r5/runtime-cli/manifest.json` | PA26065: initial activation CLI R5 (contract from candidate R13, round-3 performance fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r5/runtime-cli/model-contract.json` | PA26065: initial activation CLI R5 (contract from candidate R13, round-3 performance fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r5/runtime-cli/pa-initial-activation.py` | PA26065: initial activation CLI R5 (contract from candidate R13, round-3 performance fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r5/test-fake-adomd.cs` | PA26065: initial activation CLI R5 (contract from candidate R13, round-3 performance fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r5/test-initial-activation.py` | PA26065: initial activation CLI R5 (contract from candidate R13, round-3 performance fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r6/build-candidate-r14.py` | PA26065: initial activation CLI R6 (contract from candidate R14, KILDEVAERN fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r6/build-contract-r6.py` | PA26065: initial activation CLI R6 (contract from candidate R14, KILDEVAERN fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r6/initial-activation-tests.json` | PA26065: initial activation CLI R6 (contract from candidate R14, KILDEVAERN fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r6/runtime-cli/README.md` | PA26065: initial activation CLI R6 (contract from candidate R14, KILDEVAERN fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r6/runtime-cli/activation_core.py` | PA26065: initial activation CLI R6 (contract from candidate R14, KILDEVAERN fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r6/runtime-cli/adomd-session.ps1` | PA26065: initial activation CLI R6 (contract from candidate R14, KILDEVAERN fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r6/runtime-cli/baseline.json.gz` | PA26065: initial activation CLI R6 (contract from candidate R14, KILDEVAERN fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r6/runtime-cli/manifest.json` | PA26065: initial activation CLI R6 (contract from candidate R14, KILDEVAERN fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r6/runtime-cli/model-contract.json` | PA26065: initial activation CLI R6 (contract from candidate R14, KILDEVAERN fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r6/runtime-cli/pa-initial-activation.py` | PA26065: initial activation CLI R6 (contract from candidate R14, KILDEVAERN fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r6/test-fake-adomd.cs` | PA26065: initial activation CLI R6 (contract from candidate R14, KILDEVAERN fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r6/test-initial-activation.py` | PA26065: initial activation CLI R6 (contract from candidate R14, KILDEVAERN fix); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r7/build-candidate-r15.py` | PA26065: initial activation CLI R7 (contract from candidate R15, source-fingerprint guard enforcing the 2b expiry); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r7/build-contract-r7.py` | PA26065: initial activation CLI R7 (contract from candidate R15, source-fingerprint guard enforcing the 2b expiry); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r7/initial-activation-tests.json` | PA26065: initial activation CLI R7 (contract from candidate R15, source-fingerprint guard enforcing the 2b expiry); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r7/runtime-cli/README.md` | PA26065: initial activation CLI R7 (contract from candidate R15, source-fingerprint guard enforcing the 2b expiry); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r7/runtime-cli/activation_core.py` | PA26065: initial activation CLI R7 (contract from candidate R15, source-fingerprint guard enforcing the 2b expiry); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r7/runtime-cli/adomd-session.ps1` | PA26065: initial activation CLI R7 (contract from candidate R15, source-fingerprint guard enforcing the 2b expiry); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r7/runtime-cli/baseline.json.gz` | PA26065: initial activation CLI R7 (contract from candidate R15, source-fingerprint guard enforcing the 2b expiry); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r7/runtime-cli/manifest.json` | PA26065: initial activation CLI R7 (contract from candidate R15, source-fingerprint guard enforcing the 2b expiry); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r7/runtime-cli/model-contract.json` | PA26065: initial activation CLI R7 (contract from candidate R15, source-fingerprint guard enforcing the 2b expiry); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r7/runtime-cli/pa-initial-activation.py` | PA26065: initial activation CLI R7 (contract from candidate R15, source-fingerprint guard enforcing the 2b expiry); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r7/test-fake-adomd.cs` | PA26065: initial activation CLI R7 (contract from candidate R15, source-fingerprint guard enforcing the 2b expiry); code byte-identical to R2 |
| `BI-OEKONOMI/tools/kalenderprofil/pa26065-initial-activation-r7/test-initial-activation.py` | PA26065: initial activation CLI R7 (contract from candidate R15, source-fingerprint guard enforcing the 2b expiry); code byte-identical to R2 |
| `BI-OEKONOMI/tools/pbi-luk-uden-gem.ps1` | Closes Power BI Desktop with "Don't save" only when the PBIP folder is committed and the click point belongs to Desktop |
