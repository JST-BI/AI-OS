# INDEX.md — samlet filindeks (SOSU Randers AI-økosystem)

> `<OneDrive>` = `C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers` (arbejdskopier); `Y:\AI OS` / `Y:\AI SOSU` er delte kopier til kollegerne.

> **Formål**: Ét opslagssted for alle styrede filer på tværs af AI OS og de 13 projekter.
> **Vedligehold**: Opdatér dette indeks når filer tilføjes, fjernes eller omdøbes i ethvert repo (se Selvvedligehold i `AGENTS.md`).
> **Instruktionsfil**: I alle repos er `AGENTS.md` den eneste instruktionsfil (uafhængig af AI-model); `CLAUDE.md` er kun pegefilen `@AGENTS.md`, som Claude Code indlæser som import. `tools/sync-agents-md.ps1` skriver pegefilerne; `.githooks/check_md_mirror.py` håndhæver det ved commit.
> **Obsidian**: Vault-roden er `<OneDrive>\AI OS\`. De fysiske projektfiler ligger separat og kanonisk i `<OneDrive>\AI SOSU\`; der findes ingen junction eller særskilte Obsidian-kopier af projektfilerne.
> **Stier**: AI OS ligger i `<OneDrive>\AI OS\`, og alle arbejdsprojekter ligger i den separate kanoniske projektrod `<OneDrive>\AI SOSU\`.
> Rådata i projekternes `Input/`-mapper (xlsx/pdf m.m.) er gitignored og indekseres ikke enkeltvis — **undtagen `ADM-KANTINE`**, hvor de små, persondatafrie menu-PDF'er committes.

---

## AI OS — `AI OS/` (repo: [JST-BI/AI-OS](https://github.com/JST-BI/AI-OS))

Infrastruktur: agentdefinitioner, AI-konfiguration, fælles værktøjer.

| Fil | Beskrivelse |
|---|---|
| `AI OS/AGENTS.md` (+ `CLAUDE.md`-pegefil) | Overordnede agentregler: startkontrol, routing, sikkerhedsregler, datagovernance, TMDL/PBIR-gotchas |
| `AI OS/INDEX.md` | Dette indeks |
| `AI OS/tools/setup-new-repo.ps1` | Opsætning af nyt repo: begge pre-commit hooks, `.gitattributes`, `.codex/config.toml`, `core.hooksPath` |
| `AI OS/tools/session-start-kontrol.ps1` | Deterministisk session-startkontrol (SessionStart-hook): pegefil, rodrenhed, INDEX.md, projektfiler. Tavs ved succes |
| `AI OS/tools/codex-opsaetning.md` | Codex på en ny maskine: trust, `project_doc_max_bytes`, hooks, `.codex/rules/`. Flyttet ud af AGENTS.md 2026-09-05 |
| `AI OS/tools/sync-agents-md.ps1` | Skriver `CLAUDE.md`-pegefilen (`@AGENTS.md`) i alle mapper; `-Check` rapporterer drift (exit 1) |
| `AI OS/tools/udgiv-til-y.ps1` | "Udgiv": spejler `<OneDrive>\AI OS` → `Y:\AI OS` og ff-puller `Y:\AI SOSU\<repo>` fra GitHub (kollegernes kopier); skill `/udgiv` |
| `AI OS/.claude/skills/udgiv/SKILL.md` | Skill bag kodeordet "Udgiv" |
| `AI OS/.claude/skills/pause/SKILL.md` | Fælles kommando "pause": lokal gemning, hashverificeret backup, genoptagelsesnotat og stop; henvises fra alle 13 projekters AGENTS.md |
| `AI OS/tools/codex-config.template.toml` | Kanonisk skabelon for projekternes `.codex/config.toml` |
| `AI OS/tools/dax-query.ps1` | Genbrugeligt live-DAX-query-værktøj mod PBI Desktops indlejrede msmdsrv |
| `AI OS/tools/validate-tmdl.ps1` | Offline TMDL-validering med PBI's egen TOM-deserializer — pre-flight-gate før PBI-åbning |
| `AI OS/tools/tmdl-krydsreferencer.py` | Tjekker queryGroup-erklæringer, `ref table` ↔ filer, at `sortByColumn`/hierarkiniveauer/relationsender peger på kolonner der findes (13-10-2026), og dublerede lineageTags — den klasse `validate-tmdl.ps1` strukturelt ikke kan se |
| `AI OS/tools/tmsl-refresh.ps1` | Tabel-scoped TMSL-refresh mod kørende PBI Desktop-instans (undgår fuld model-refresh) |
| `AI OS/tools/pbi-reopen.ps1` | Genåbner HR_OEKONOMI.pbip i en kørende "Untitled" PBI Desktop via UIA-recents (kold genstart-cyklus) |
| `AI OS/tools/pbi-screenshot.ps1` | Vælger rapportfane via UIA, lukker backstage, søger fejltekster og gemmer PrintWindow-screenshot |
| `AI OS/.githooks/pre-commit` | Versioneret pre-commit hook; kalder begge checks nedenfor (findes i alle 12 repos) |
| `AI OS/.githooks/check_excel_pii.py` | Blokerer commit af Excel med persondata (CPR/e-mail/navnekolonner) |
| `AI OS/.githooks/check_md_mirror.py` | Blokerer commit hvor CLAUDE.md er andet end pegefilen `@AGENTS.md` |
| `AI OS/.githooks/README.md` | Aktivering af hooks efter clone (findes i alle 12 repos) |
| `AI OS/.claude/` | Claude Code-indstillinger |
| `AI OS/.claude/skills/pbi-live-maaling/SKILL.md` | Skill (kun Claude Code): live DAX-måling mod kørende PBI Desktop — port-opdagelse, ADOMD, aggregat-only-regel, gotchas |
| `AI OS/.codex/config.toml` | Codex-konfiguration (TOML). Hæver `project_doc_max_bytes`, sætter sandkasse og AGENTS.md-fallback. Erstattede 2026-08-20 en virkningsløs `.Codex/settings.json` i Claude Codes JSON-format |
| `AI OS/.obsidian/` | Stabil Obsidian-konfiguration for vaulten med `AI OS/` som rod; maskinspecifik `workspace*.json` og cache er gitignored. `app.json`/`daily-notes.json`/`templates.json` dirigerer nye noter til `vault/` — uden dem skrev daily-notes-pluginet i roden |
| `AI OS/vault/` | De frie Obsidian-noter (`inbox/`, `journal/`, `notes/{,people,decisions}/`, `meetings/`, `resources/`, `_templates/`, `_attachments/`). Adskilt fra de styrede filer — se AGENTS.md → *Obsidian-vaultregler* |
| `AI OS/vault/AGENTS.md` (+ `CLAUDE.md`-pegefil) | Obsidian-notereglerne (frontmatter, routing, index-vedligehold, AI_ACTION_METADATA). Flyttet ud af AI OS-roden 2026-09-05 — de gælder kun filer under `vault/` (spejle) |
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
| `AGENTS.md` (+ `CLAUDE.md`-pegefil) | Projektregler: modelarkitektur, DAX/M-konventioner, workflow, gotchas |
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
| `tools/sync-datakilder.ps1` | Spejler modellens datakilder fra Y: til `C:\BI-Data` (robocopy `/MIR`). Læser stierne i DATAKONTROLCENTER + parameteren `$Ekstra` med de fem mapper der kun har eksplicit sti i M-koden |
| `tools/refresh-hr-oekonomi.ps1` | Refresh-rutinen: synkroniserer spejlet, **friskhedskontrollerer** at ingen kilde er nyere på Y: end i spejlet (`-KunKontrol` svarer uden at refreshe), og kører TMSL-refresh i én transaktion med fallback til tabel-for-tabel. `-Only` refresher præcis de navngivne tabeller |
| `tools/afstem-kilde.ps1` | **Kontrollerer modellen op mod kildefilerne** (JSTs regel 2b, 08-09-2026). Tre kontroller, kun aggregater i output: er spejlet bagud i forhold til Y:, ligger der TEMP-ark i datakilderne, og er Z8050's raadata-ark identisk med modellen (distinkte cpr + sum af `bidrag_i_maaned`). Kontrol 1 overlapper `refresh-hr-oekonomi.ps1 -KunKontrol`; det nye er 2 og 3 |
| `tools/tjek-datakilde-afhaengigheder.py` | **Kontrol af afhængighedslisterne bag kontrolcenterets tilstand `Ingen`** (13-10-2026): beregner for hver afledt import-tabel den transitive lukning af datakilde-numre (uden DIM-kilder) fra TMDL/M og sammenligner med `fxDatakildeRaekkerAfhaengig({…}, …)` i partitionen; exit 1 ved afvigelse, `--skriv` retter. Kontrol 2 fanger et genopstået `Folder.Files(fxDatakildeSti(n))`, som omgår `Ingen`. Kør efter enhver ændring i en partition/expression der læser en kilde |
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
| `tools/kalenderprofil/` | Historiske kalenderprofiler: råkilde-/AJ-bygger, manuel XLSX-generator, godkendelsesskabelon og GUI-fri kilde-/plankalenderkontroller; kun aggregater skrives |
| `Output/power-query/kalenderprofil/` | AJ-kerne med 27 tests; separat integrationskæde med 21 tests og to mutanter; godkendte GF2-PA-planbroer med 200 undervisningsdage og otte kildebeviste perioder |
| `Output/reviews/kalenderprofil-2026-10-16/` | 10.405 historiske kandidatepisoder, 2.269 profilpunkter i 47 grupper, manuelt justerbart profilark, proveniens, kilde-/runtimebeviser og afgrænset slutkontrol; ingen produktionsaktivering |
| `Output/power-query/fysisk-observation-identitet/` | Isoleret identitetsrettelse: seks frosne M-filer, 157 kontroller, faktiske mutanter, gemt/kold bevis og kode-GO; kræver særskilt kildeadapter |
| `Output/power-query/fysisk-kilde-identitet/` | Kildebevist streng 6-4→10-adapter: 105 kontroller, to faktiske mutanter, uafhængigt kode-GO og præcise versionerede LF-hashes; ingen produktionsaktivering |
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
| `AGENTS.md` (+ `CLAUDE.md`-pegefil) | Projektregler: orkestrator-rolle, CPR-regel, merge-felter, workflow |
| `.claude/rules/inno-workflows.md` | Agent-workflow-mønstre for INNOMATE-arbejde. Læses eksplicit af begge værktøjer — indlæses ikke automatisk. (Fjernet fra `.codex/rules/` 2026-08-20, se ovenfor) |
| `generate-procesplan-v3.js` (+ `package.json`) | Procesplan-generator (Node.js) |
| `Input/Oprettelse af medarbejder/`, `Input/Nedlæggelse af medarbejder/`, `Input/Generelle skabeloner/` | Kildefiler: procesplaner, INNOMATE-skabeloner, korrespondance |
| `Output/` (samme undermapper) | Genererede skabeloner og procesplaner |

---

## ADM-HÅNDBØGER — `<OneDrive>\AI SOSU\ADM-HÅNDBØGER\` (repo: [JST-BI/ADM-HANDBOOKS](https://github.com/JST-BI/ADM-HANDBOOKS))

Personalehåndbog og Lederhåndbog — afspejler hinandens emner.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` (+ `CLAUDE.md`-pegefil) | Projektregler: håndbogs-parallelitet, workflow |
| `Personalehåndbog/` | Indhold målrettet medarbejdere |
| `Lederhåndbog/` | Samme emner, ledervinkel |
| `Input/` / `Output/` | Kildemateriale hhv. færdige/godkendte versioner |

---

## ADM-ØKONOMI — `<OneDrive>\AI SOSU\ADM-ØKONOMI\` (repo: [JST-BI/ADM-OEKONOMI](https://github.com/JST-BI/ADM-OEKONOMI))

Økonomiske styringsdokumenter.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` (+ `CLAUDE.md`-pegefil) | Projektregler: dokumentrelationer, workflow |
| `Regnskabsinstruks/` | Regler for bogføring, godkendelse, regnskabsaflæggelse |
| `Indkøbspolitik/` | Rammer for indkøb, leverandørstyring, udbudspligt |
| `Strategi for finansiel risiko/` | Risikovurdering, likviditetsstyring, finansielle principper |
| `Input/` / `Output/` | Kildemateriale (Management Letter, årsrapport, bestyrelsens budget) hhv. handleplan-pptx'er — **gitignoreret** fra 12-10-2026, deles kun via Y: (Udgiv). PR #1 |

---

## ADM-BI — `<OneDrive>\AI SOSU\ADM-BI\` (repo: [JST-BI/ADM-BI](https://github.com/JST-BI/ADM-BI))

BI governance og styringsdokumenter.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` (+ `CLAUDE.md`-pegefil) | Projektregler: governance-scope, relation til BI-OEKONOMI |
| `Input/` / `Output/` | Kildemateriale hhv. godkendte standarder (normgivende for BI-OEKONOMI) |

---

## DATA-BUDGET_PROGNOSE — `<OneDrive>\AI SOSU\DATA-BUDGET_PROGNOSE\` (repo: [JST-BI/DATA-BUDGET_PROGNOSE](https://github.com/JST-BI/DATA-BUDGET_PROGNOSE))

Finansiel analyse, budget og prognose (Navision + BRUGER-budget/prognose → .xlsx).

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` (+ `CLAUDE.md`-pegefil) | Projektregler: datakilder, formålskoder, fin-agent-routing |
| `Input/` | Rådata: Navision-finansposter, budget, prognose, finanslov, årsrapporter (gitignored) |
| `Output/` | .xlsx-leverancer med danske formater (rene leverancer må committes) |

---

## ADM-KANTINE — `<OneDrive>\AI SOSU\ADM-KANTINE\` (repo: [JST-BI/ADM-KANTINE](https://github.com/JST-BI/ADM-KANTINE))

Kantinens menukort (tilrettede udgaver af leverandørens ugemenu) og de ugentlige bestillingssedler til Jespers Torvekøkken og Bilkas bageri.
**Bemærk**: `Input/`s PDF'er committes her (små, persondatafrie = dokumentation for hvert ugekort). `.gitattributes` sætter `*.pdf binary`.
Mailmapperne under `Input/` og `Output/Bestillinger/` er derimod gitignored — de indeholder navne, mobilnumre og e-mailadresser.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` (+ `CLAUDE.md`-pegefil) | Projektregler: kilder, filnavngivning, ugentlig arbejdsgang |
| `tools/hent-portionsanretning.py` | Henter kilde-PDF'en fra torvekoekken.dk når den ikke allerede ligger i `Input/` — regex på knappens `onClick`-attribut i den rå HTML, ingen browser nødvendig; vælger altid den danske "Uge `<N>`"-knap, ikke den engelske |
| `tools/byg-ugekort.py` | Generator: bygger `Output/Kantine Ugekort <uge>.pdf` (kun FAVORIT + stående Bowl+Sandwich-tilbud). Auto-skalerer dagsblokkene så de aldrig løber ned over allergen-footeren — kræver `reportlab` |
| `tools/test-layout.py` | Layout-værn: tjekker ugens indhold + et værre tilfælde, med negativ kontrol der kræver at et fast layout faktisk overlapper |
| `Input/<uge>_Aarhus_Portion.pdf` | Leverandørens portionsanretning, 5 sider (FAVORIT, Vegetar, Vegansk, Halal, Gluten/laktosefri) |
| `Input/Kantine - Prisskilt.pdf` | Kantinens prisskilt (bagværk, frokost, drikkevarer) — kilde til Bowl- og Sandwich-prisen |
| `Output/Kantine Ugekort <uge>.pdf` | Ugens menukort til opslag — kun FAVORIT-retten pr. dag |
| `tools/lav-muah-seddel.py` | Generator: udfylder MUAH-udfyldningssedler til Bilkas bagerudsalg ud fra en JSON-liste og en tidligere seddel som skabelon — kræver `python-docx` |
| `tools/lav-bestillingsseddel.py` | Generator: bestillingssedler med én side pr. afhentnings-/leveringsdag ud fra en JSON-liste — vedhæftes bestillingsmailen. Kræver `python-docx` |
| `tools/lav-afstemning-xlsx.py` | Bygger ugens afstemningsregneark (8 ark: dag for dag, ugetotaler, kilder, beslutninger, fakturering, pedellens tilbehør) — JSTs kontrolgrundlag. Kaldes med ugenummeret. Kræver `openpyxl` |
| `tools/lav-kantineoversigt.py` | Dagsoversigt til kantinemedarbejderen: ét ark pr. dag med kiosksalget og hvert arrangement i sin helhed (Jespers, Bilka, kantinen selv/pedellen, kontakt, fakturering) fra ugemodulets `ARRANGEMENTER` |
| `tools/fredagskoersel.ps1` | Fredagskørslen: starter Outlook, kører `claude -p` med `fredagsprompt.md`, logger til `Output/Bestillinger/_log/`; `-Registrer` opretter opgaven i Opgavestyring (fredag kl. 10.00) |
| `tools/fredagsprompt.md` | Opgaveteksten til den uovervågede fredagskørsel: næste uges kladder, grænser (aldrig send, kun aggregater), afsluttende statuslinjer |
| `tools/afstemningsdata/__init__.py` | Fælles konstanter til regnearket + opslag af kildemails på SHA-256-præfiks, så persondatabærende filnavne ikke står i et versioneret script |
| `tools/afstemningsdata/uge<nr>.py` | Ét datamodul pr. uge: bestillinger, kilder, beslutninger, åbne punkter, fakturering og tilbehør — så en tidligere uge kan genskabes uændret |
| `tools/mail-md-til-json.py` | Oversætter bestillingsmailene fra `.md` til `mails.json` (UTF-8, skrives direkte — aldrig med `>`) til kladdescriptet |
| `tools/opret-kladder.ps1` | Lægger mailene som kladder i JSTs egen Outlook-postkasse OG gemmer dem som `.msg` i `Klar til afsendelse/`. Kalder aldrig `.Send()` |
| `Output/Kantine - Prisskilt.pdf` | Prisskilt klar til opslag |
| `tools/byg-infoskaerme.py` | Generator: bygger ugens tre infoskærms-PowerPoints (floej_c, reception, showroom) — ét menuslide med ugekortet renderet fra PDF'en. Kræver `python-pptx`, `pypdfium2` |
| `Input/<skaerm>_uge33.pptx` | Historik: uge 33-skærmene med etageplan + tekstmenu (planerne er nu fysiske A-skilte) |
| `Input/floej_c_uge38.pptx` | JSTs skabelon for menuslidet (topbanner + ugekort som billede) |
| `Input/Kantine Ugekort 38.pdf` | JSTs kopi af ugekortet, lagt sammen med skabelonen |
| `Output/<skaerm>_uge<uge>.pptx` | Ugens PowerPoint til de tre infoskærme |

---

## BI-OPGAVEOVERSIGT — `<OneDrive>\AI SOSU\BI-OPGAVEOVERSIGT\` (repo: [JST-BI/BI-OPGAVEOVERSIGT](https://github.com/JST-BI/BI-OPGAVEOVERSIGT))

Power BI-rapport: medarbejderes opgaveoversigt mod arbejdstidsnorm. Kilde: Budgetskema.xlsx på SharePoint + Studie+-udtræk (Z8004, Z8082).

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` (+ `CLAUDE.md`-pegefil) | Projektregler: datamodel, ShowRow-grain, normvarianter, rapportfiltre, PBI-/refresh-arbejdsgang |
| `Power BI - Opgaveoversigt - Ledere.pbip` | PBIP-projektfil |
| `…SemanticModel/definition/tables/` | `DB Budget underviser og SPS medarbejder.tmdl` (fakta + alle målere), `Arbejdstidsnorm.tmdl`, `L-Kalender.tmdl` |
| `…SemanticModel/definition/expressions.tmdl` | M-queries, bl.a. `UV Medarbejder` og `Støtte Medarbejder` (normvarianterne) |
| `…Report/definition/pages/` | Siderne `Opgaveoversigt - Ledere` og `Forklaring på blokke` |

---

## BI-OPTAG FRAVÆR — `<OneDrive>\AI SOSU\BI-OPTAG FRAVÆR\` (lokalt repo, intet GitHub-remote)

Power BI-rapport: elevoptag og skoleforløbsfravær. Kilde: Studie+-udtræk `Z8312` (alle holdplaceringer) og `Z8224S` (skoleforløbsfravær). Bragt under AI-styring 2026-08-20.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` (+ `CLAUDE.md`-pegefil) | Projektregler: datagrundlag, målergrupper, agentbrug, skærpet persondata-opmærksomhed |
| `SOSU BI OPTAG FRAVÆR.pbip` | PBIP-projektfil |
| `…SemanticModel/definition/tables/` | Målergrupper (`#Measures - ELEV/HRLØN/KPI/TEMATIK/ØKONOMI`), `L-Kalender`, `L-STU Dim…`-dimensioner, `L-STU Fact Z8224S…` |
| `.codex/config.toml` | Codex-projektkonfiguration |

---

## ADM-AFTALER — `<OneDrive>\AI SOSU\ADM-AFTALER\` (lokalt repo, intet GitHub-remote)

Samarbejds- og samhandelsaftaler med eksterne parter. Bragt under AI-styring 2026-08-20. `Input/` er gitignored som forsigtig standard: aftaler indeholder navne og underskrifter, og fortrolighedsniveauet er ikke afklaret.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` (+ `CLAUDE.md`-pegefil) | Projektregler: versionssammenligning af aftaletekst, juridisk forbehold, persondata |
| `.codex/config.toml` | Codex-projektkonfiguration |

---

## ADM-BLANKET — `<OneDrive>\AI SOSU\ADM-BLANKET\` (lokalt repo, intet GitHub-remote)

Administrative blanketter og formularer (i dag kørselsbemyndigelser). Bragt under AI-styring 2026-08-20. `Input/` er gitignored: blanketterne er personhenførbare af natur.

| Fil | Beskrivelse |
|---|---|
| `AGENTS.md` (+ `CLAUDE.md`-pegefil) | Projektregler: blanketstruktur, skærpet persondata-advarsel mod `--no-verify` |
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
| `AGENTS.md` (+ `CLAUDE.md`-pegefil) | Projektregler: datamodel (ACL-join, indlejrede grupper), persondataregler, workflow |
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
| `AGENTS.md` (+ `CLAUDE.md`-pegefil) | Projektregler: skærpet persondata, funktionærlovens varselstabel, SD-anciennitet ≠ lønanciennitet |
| `tools/generer-varslinger.py` | Udfylder én varsling pr. medarbejder i opsigelsesrunden fra procesplan + skabelon + SD-udtræk; kontrollerer varsler mod § 2 og skriver kontrolrapport |
| `tools/test-ful-varsel.py` | Grænsetilfælde for varselsberegningen (6 mdr., 3/6/9 år, prøvetid) |
| `tools/verificer-varslinger.py` | Tilbagelæsning af genererede varslinger: navn, CPR, rest-pladsholdere, gul markering |
| `Input/Procesplan afskedigelser - 2026-10-19.docx` | Procesplan med medarbejdere pr. opsigelsesrunde og samtaleskema (gitignored) |
| `Input/Varsling om påtænkt opsigelse - SKABELON - 2026-10-19.docx` | Brevskabelon med gulmarkerede pladsholdere (gitignored) |
| `Output/Varslinger oktober 2026/` | Udfyldte varslinger + `Kontrol af opsigelsesvarsler - oktober 2026.md` (gitignored) |

---

## Fælles på tværs af alle 14 repos

| Fil | Beskrivelse |
|---|---|
| `.githooks/pre-commit` | Kalder begge checks nedenfor (aktivér pr. klon: `git config core.hooksPath .githooks`) |
| `.githooks/check_excel_pii.py` | Persondata-scan af staged Excel (CPR, e-mail, navnekolonner) |
| `.githooks/check_md_mirror.py` | Blokerer commit hvor CLAUDE.md er andet end pegefilen `@AGENTS.md` |
| `.githooks/README.md` | Aktiveringsvejledning efter clone |
| `.codex/config.toml` | Codex-projektkonfiguration fra `AI OS/tools/codex-config.template.toml` |
| `.gitattributes` | `eol=lf` på hook-filerne, ellers `* text=auto` |
| `.gitignore` | Bl.a. Excel-/rådata-ignorering hvor relevant |
| `_Arkiv/` | Udgåede versioner (projekt-repos) |

**14 repos** = AI OS + 13 projekter. Fem af dem (`BI-OPTAG FRAVÆR`, `ADM-AFTALER`, `ADM-BLANKET`, `ADM-RETTIGHEDSSTYRING`, `ADM-BESPARELSER`) har lokale git-repos uden GitHub-remote, indtil fortrolighedsniveauet er afklaret med JST.

**Bemærk (kun Claude Code)**: Claude Codes persistente hukommelse ligger lokalt under `~/.claude/projects/<AI OS-projekt>/memory/` med eget indeks `MEMORY.md` — den er personlig, ikke versionsstyret og ikke en del af repo-strukturen.
