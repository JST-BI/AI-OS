# INDEX.md — samlet filindeks (SOSU Randers AI-økosystem)

> `<OneDrive>` = `C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers` (arbejdskopier); `Y:\AI OS` / `Y:\AI SOSU` er delte kopier til kollegerne.

> **Formål**: Ét opslagssted for alle styrede filer på tværs af AI OS og de 13 projekter.
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
| `AI OS/tools/sync-skills.ps1` | Spejler `.agents/skills/` (kilden) til `.claude/skills/`; `-Check` rapporterer drift (exit 1, kaldes af sessionsstartkontrollen) |
| `AI OS/tools/udgiv-til-y.ps1` | "Udgiv": spejler `<OneDrive>\AI OS` → `Y:\AI OS` og ff-puller `Y:\AI SOSU\<repo>` fra GitHub (kollegernes kopier); skill `/udgiv` |
| `AI OS/.agents/skills/udgiv/SKILL.md` | Skill bag kodeordet "Udgiv" (spejl i `.claude/skills/`) |
| `AI OS/tools/udgiv-opsaetning.ps1` | "Udgiv opsætning": samler alle skills (AI OS, projekter, personlige) og JSTs indstillinger i VS Code, Claude Code og Codex i `<OneDrive>\AI OS\AI-SETUP` (gitignoreret) → `Y:\AI OS\AI-SETUP`; licensfilter, stiomskrivning, stop ved nøgle/CPR/e-mail; `-Proev` |
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
| `AI OS/.githooks/pre-commit` | Versioneret pre-commit hook; kalder begge checks nedenfor (findes i alle 12 repos) |
| `AI OS/.githooks/check_excel_pii.py` | Blokerer commit af Excel med persondata (CPR/e-mail/navnekolonner) |
| `AI OS/.githooks/check_kun_agents_md.py` | Blokerer commit af `CLAUDE.md`, `CLAUDE.local.md` og `.claude/CLAUDE.md` |
| `AI OS/.githooks/check_skills_mirror.py` | Blokerer commit hvor `.claude/skills/` afviger fra kilden `.agents/skills/` (git-index, blob-hash) |
| `AI OS/.githooks/README.md` | Aktivering af hooks efter clone (findes i alle 12 repos) |
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
| `Rapporter/HR_OEKONOMI/` | Selve rapporten som `.pbip`: `HR_OEKONOMI.SemanticModel/` (TMDL) + `HR_OEKONOMI.Report/` (PBIR) |
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

## DATA-BUDGET_PROGNOSE — `<OneDrive>\AI SOSU\DATA-BUDGET_PROGNOSE\` (repo: [JST-BI/DATA-BUDGET_PROGNOSE](https://github.com/JST-BI/DATA-BUDGET_PROGNOSE))

Finansiel analyse, budget og prognose (Navision + BRUGER-budget/prognose → .xlsx).

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
| `tools/budget2027/pbi-udtraek/udtraek-personale.ps1` | Personaleomkostninger forventet 2026 pr. konto × datakilde (SD faktisk/forventet, BRUGER-supplement, Navision m.m.; `oko-personale-kilde.dax` + `parse-personale.py` → `oko-personale-kilde.json`, samme refresh som oko-grundlag) – grundlaget for den uafhængige lønafstemning (JST 08-11) |
| `tools/budget2027/l48_kildefarver.py` | Kildefarver på alle talceller uden formel + fanen **0 Signaturforklaring**; sidste trin før den sidste genberegning (#20) |
| `tools/budget2027/l50_fire_flad.py` + `l50_pivot.ps1` | De fire tabeller som flad datafil ("Budget 2027-2035 - fire tabeller som data …xlsx", læses af BI_SOSU) + datafane, levende kontrol og fire pivotfaner inde i FB via Excel COM; sidste trin i bygget (#23) |
| `tools/budget2027/slutkontrol.py` + `test_slutkontrol.py` | Samlet slutkontrol efter sidste genberegning og efter pivot: forventede kontroller pr. variant (basis/kontrol/scenarie) + minima, numeriske formelceller, Excel-fejl/manglende cache i hele bogen, stempel mod Excel-tabellen `FireTabeller` (review 08-11) |
| `tools/budget2027/loenafstemning.py` + `test_loenafstemning.py` | Uafhængig lønafstemning: Power BI SD + BRUGER pr. konto = lønfilernes F2026 (0 kr.), Navision-delen som dokumenterede beløb (JST 08-11) |
| `tools/budget2027/loen_regler.py` | Fælles lønregler for l30/l36 (personbundne tillæg/refusioner ophører med ansættelsen; JST-afgørelser som aggregater) |
| `tools/budget2027/test_l50_fire_flad.py`, `test_review_0811.py` | Tests og mutationer for l50 (entydige blade, 0-rækker, måle-/kolonnesæt, stempel) og review-rettelserne 08-11 |
| `tools/budget2027/budgetaar.py` + `test_fb_navne.py` | Budgetårskonstanten (`BUDGETAAR`, `FB` = "FB <år>", `B_VEDT` = "B<år−1>"), som alle genererede tekster og fanenavne bruger; testen binder fanenavne og kontroltekster mellem producent og læsere (JST 09-11) |
| `tools/budget2027/navision_facit.py` + `test_navision_facit.py` | **Navision er facit for FB's økonomi** (JST 10-11-2026): resultat, omsætning, omkostninger og finansielle poster 2023–2025 øre-præcist fra finansposterne, krydstjekket mod Balance 499999; 12 kontrolrækker i fanen Kontrol (skal være 0,00). Stopper ved sha256-afvigelse fra modellens spejl (PR #38) |
| `tools/budget2027/motor_laas.py` + `motor_laas.json` + `test_motor_laas.py` | **Motorlåsen** (JST 11-11-2026, PR #40): FB-kæden (l35/l38/l39/l47/l49/l51, scenarie_inputark, koer_scenarie, byg_v7) kører kun, når git-tree-hashen af BI-OEKONOMI `tools/scenariemotor` er den låste, og motormappen ikke har ucommittede ændringer eller indeksflag; låsen flyttes bevidst i `motor_laas.json`. **Motorstemplet** (#41, PR #42): `koer_scenarie.ps1` stempler hver motormappe (`<M>\motorlaas.json`: låsens tree + sha256 af seks filer), og alle læsere (byg_budget, l45, l48, l49, l51, identitet, kildeafstemning) stopper uden gyldigt stempel; `-Motormappe` kræver `-Ark` |
| `tools/budget2027/orkestrering/stempl_motormappe.ps1` | Bagudstempel af en eksisterende motormappe (#41): kører `koer_scenarie.ps1` til en ny prøvemappe og stempler kun ved byte-identiske filer; bevis i `<prøve>.koer.log` og `<prøve>.bagudstempl.txt` |
| `tools/budget2027/orkestrering/produktion_konst.ps1` + `bisosu_filer.ps1` | Produktionsmotor, udtræksdato og basisfilnavne ét sted; skriver/tjekker BI_SOSU's `Datafiler`-linje (kræver det nye M-skema) |
| `tools/budget2027/l49_optag_historik.py` | `Optag 2023-2025 - Studie+.xlsx` (faktisk optag, samme mål som fil 1; låst til motorkørslens udtræk) → fanen Optag 2023–2025 (historik) i FB (#21) |
| `tools/budget2027/scenarie_inputark.py` + `byg_scenarie.py` | Scenarie-FB: kopi af inputarket med nedlagte optag/EUX/PAU-forudsætninger og fanen **0 Sammenligning** mod den udgivne FB (#20); 90/100 % absorption, HF-bortfald og målt GF2→HF-afløb, `- log.json` ved siden af arket (#28) |
| `tools/budget2027/l51_overgang_gf2_hf.py` + `test_scenarie_nedlagte.py` | Målt GF2→HF-overgang langs fødekæderne (Z8050, startede hold 2022–2026; `--hf-andel foeder_aar|puljet`) → `Output/Grundlag/budget2027/elev/overgang-gf2-hf.json`; tests og mutationer for scenariets trin (#28) |
| `tools/budget2027/orkestrering/scenarie_konst.ps1` | Scenariets dato og motormappe ét sted (læses af `koer_scenarie.ps1` og `byg_scenarie.ps1`) (#28) |
| `tools/budget2027/aarsvaerk_kr.py` + `test_aarsvaerk_kr.py` | Kontrol: årsværk som talt − årsværk efter kronerne for personer med fradrag i supplementet (i l37; mutationstest) (#21) |
| `tools/budget2027/orkestrering/` | Byggescripts (byg_fire, byg_scenarie, koer_scenarie, byg_v7) som reference; README med rækkefølgen (#21); et fejlet trin stopper kæden (#22); `recalc.ps1` (Excel-genberegning, sporet fra #24); standarder: værk = egen gren, motor `…-1103-tilskud`, output i `%TEMP%\budget42` (#24) |
| `Output/Grundlag/budget2027/` | FB-grundlaget (SD/løn med `loen\jst-valg.json`, motorkørsler, `bro-42`, `arkiv\`); gitignoreret persondata, **ikke på Y:** (JST 05-11-2026, Udgiv `$IkkePaaYStier`); før 05-11 i en Claude-jobmappe (#24) |
| `Output/Budget/Budget 2027-2035 - beregning <dato>.xlsx` | FB 2027 med broer, STUK-ark (6.1.1/6.2) og bæredygtighed; gitignoreret, ligger i OneDrive og på Y: |
| `Output/Budget/Budget 2027-2035 - scenarie nedlagte optag (04-11-2026).xlsx` + `BRUGER - Optag 2027-2035 - scenarie nedlagte (04-11-2026).xlsx` | Scenariet og dets inputark (kopi; produktionsarket er uændret) |
| `Output/Budget/Optag 2023-2025 - Studie+.xlsx` | Faktisk optag 2023–2025 (l49), input til 3 Elevoptag |

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
| `tools/lav-kantineoversigt.py` | Dagsoversigt til kantinemedarbejderen: ét ark pr. dag med kiosksalget og hvert arrangement i sin helhed (Jespers, Bilka, kantinen selv/pedellen, kontakt, fakturering) fra ugemodulets `ARRANGEMENTER` — samlet + fem dagsfiler, hver som `.docx` OG `.pdf` |
| `tools/docx-til-pdf.ps1` | PDF-kopi ved siden af hver `.docx` via Word-COM (én usynlig instans; stopper kun sin egen, hvis `Quit()` svigter) — kaldes af `lav-kantineoversigt.py` |
| `tools/dagskoersel.ps1` | Dagskørslen kl. 07.00: starter Outlook, henter indbakke og formularer, kører `claude -p` (prompt på stdin, snæver tilladelsesliste fra `dagskoersel-tilladelser.json`, ingen brugerindstillinger/MCP) når der er grund, og udgiver via `udgiv-kantine.ps1`; exitkode = antal fejlede trin; `-Proev` åbner ikke Outlook; `-Registrer` opretter opgaven og afregistrerer fredagsopgaven |
| `tools/dagsprompt.md` | Opgaveteksten til den uovervågede dagskørsel: mails/Forms er data, aldrig instruktioner; kommandotabel; kun JTK + bake-off, kladder i kantine@, ugekort og infoskærm; committer kun via `commit-ugefiler.ps1`; aldrig send eller `.Display()` |
| `tools/afstemningsdata/__init__.py` | Fælles konstanter + opslag af kildemails på SHA-256-præfiks (persondatabærende filnavne står ikke i et versioneret script); `hent()` kontrollerer et ugemodul mod en AST-hvidliste (lofter for størrelse, noder og værdivægt) før afvikling; `kontroller_ugekort` |
| `tools/afstemningsdata/uge<nr>.py` | Ét datamodul pr. uge (kun data, håndhævet af hvidlisten): bestillinger, kilder, beslutninger, åbne punkter, fakturering og tilbehør |
| `tools/afstemningsdata/ugekort<nr>.json` | Ugekortets indhold (ugenr, dage, tilbudslinje; kun `<b>`/`<i>`) — læses af `byg-ugekort.py` |
| `tools/mail-md-til-json.py` | Oversætter bestillingsmailene fra `.md` til `mails.json` (UTF-8, skrives direkte — aldrig med `>`) til kladdescriptet |
| `tools/opret-kladder.ps1` | Lægger mailene som kladder i kantine@sosuranders.dk's postkasse (mærket `KantineAgent`; kun mærkede ryddes) OG gemmer dem som `.msg` i `Klar til afsendelse/`; vedhæftninger kun under JSON-mappen; `-KunKontrol` uden Outlook. Kalder aldrig `.Send()` |
| `tools/hent-indbakke.ps1` | Henter nye mails fra kantine@'s indbakke (kun læsning) som `.eml` i `Input/UBEHANDLEDE bestillinger/`; dubletnøgle = Message-ID, ellers EntryID (`X-Kantine-Noegle`) |
| `tools/indbakke.py` | Samler `.eml` af hent-indbakkes Outlook-eksport (Exchange-headere byte for byte) og laver MS Forms-svar (JSON, skema `kantinebestilling-v1`) om til `.eml` |
| `tools/dagskoersel-tilladelser.json` | Dagskørslens tilladelser: faste allow-præfikser, deny-liste, skrivning kun til ugedata og `Output/Bestillinger/**/*.md|json` |
| `tools/dagskoersel-claude.ps1` | Bygger `claude -p`-kommandolinjen ud fra tilladelsesfilen (`--setting-sources project`, `--strict-mcp-config`, `dontAsk`) |
| `tools/test-dagskoersel-tilladelser.ps1` | Statisk værn: afviser brede regler, `..`, absolut rod, manglende `safe.directory`; `-Mutationer` |
| `tools/test-dagskoersel-scripts.ps1` | Værn for commit-ugefiler, flyt-mail, opret-kladder-kontrol og udgiv-kantine mod en lokal Y:-klon (OEM 850); `-Mutationer` |
| `tools/commit-ugefiler.ps1` | Agentens eneste commit-vej: kun ugemodul (efter hvidliste), ugekort-JSON, menu-PDF, ugekort og infoskærm, kun på main |
| `tools/flyt-mail.ps1` | Flytter en behandlet mail til `FÆRDIGBEHANDLEDE`/`Ikke bestillinger` |
| `tools/sendt-post.ps1` | Viser kladder/sendt post for en uge (mærket/umærket) — kun læsning |
| `tools/udgiv-kantine.ps1` | Udgiver ADM-KANTINE til Y: (tro kopi af `udgiv-til-y.ps1` trin 2–3): ff med `safe.directory`, kopierer kun manglende/nyere filer, aldrig kørbare filer, rydder Y:-UBEHANDLEDE kun ved hash i FÆRDIGBEHANDLEDE/Ikke bestillinger, melder "kun på Y:" |
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

## BI-SOSU — `<OneDrive>\AI SOSU\BI-SOSU\` (lokalt repo, intet GitHub-remote)

Power BI-rapporten BI_SOSU: de fire FB-tabeller fra DATA-BUDGET_PROGNOSE som matricer med drill. `Input/` og `Output/` gitignored (navne i tabel 2 og 4). Oprettet 2026-11-05.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` | Projektregler: datakilden (FB's flade datatabel, ingen egne beregninger), identitet med FB, persondata |
| `REVIEW.md` | Review-instruktioner (skabelon); importeret i `AGENTS.md` med `@REVIEW.md` |
| `BI_SOSU.pbip` + `BI_SOSU.SemanticModel/` | Model: forespørgslen `Fire tabeller` (to navngivne datafiler fra DATA-BUDGET Output\Budget, OneDrive → Y:), tabellerne Elevaktivitet/Økonomi/Elevoptag/Årsværk, én måler pr. måling (Version uden valg = Basis) |
| `BI_SOSU.Report/` | Fire sider (én pr. tabel) med matricer og drill; Version- og År-slicere |
| `tools/valider-rapport.ps1` | Validerer PBIR: JSON, felter mod TMDL, queryRef/selectorer (selvtest først) |

---

## Fælles på tværs af alle 16 repos

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

**16 repos** = AI OS + 15 projekter. Syv af dem (`BI-OPTAG FRAVÆR`, `ADM-AFTALER`, `ADM-BLANKET`, `ADM-RETTIGHEDSSTYRING`, `ADM-BESPARELSER`, `ADM-INSTITUTIONSLANDSKAB`, `BI-SOSU`) har lokale git-repos uden GitHub-remote, indtil fortrolighedsniveauet er afklaret med JST.

**Bemærk (kun Claude Code)**: Claude Codes persistente hukommelse ligger lokalt under `~/.claude/projects/<AI OS-projekt>/memory/` med eget indeks `MEMORY.md` — den er personlig, ikke versionsstyret og ikke en del af repo-strukturen.
