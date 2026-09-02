# AI OS (SOSU Randers) — agentregler (Claude Code + Codex)

> **Spejlprincip — Claude Code + Codex**: `CLAUDE.md` (læses af Claude Code) og `AGENTS.md` (læses af Codex) er identiske spejle af samme indhold. Redigér ALTID `CLAUDE.md` først, og spejl derefter 1:1 til `AGENTS.md`: `Copy-Item CLAUDE.md AGENTS.md` — eller på tværs af alle projekter på én gang med `& "AI OS\tools\sync-agents-md.ps1"`. "Agenten" i teksten betyder den aktive AI-agent, uanset værktøj; funktioner der kun findes i ét værktøj er markeret "(kun Claude Code)" / "(kun Codex)".
>
> **Spejlet håndhæves ved commit** (indført 2026-08-20): `.githooks/check_md_mirror.py` blokerer enhver commit hvor `CLAUDE.md` og `AGENTS.md` i samme mappe ikke er byte-identiske, eller hvor kun den ene halvdel af parret er med. Drift kan altså ikke længere ske ubemærket — men hooken kører kun i kloner hvor `git config core.hooksPath .githooks` er sat.
>
> **Stier**: `<OneDrive>` betyder `C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers`. Arbejdskopierne er `<OneDrive>\AI OS` og `<OneDrive>\AI SOSU`; `Y:\…` er delte kopier (se *Placering* nedenfor).
>
> **Filindeks**: `INDEX.md` (her i AI OS rod) er det samlede indeks over alle styrede filer på tværs af alle 11 projekter (12 repos inkl. AI OS). Holdes opdateret ved enhver fil-tilføjelse/-fjernelse/-omdøbning.
>
> **Én Markdown-kilde — Obsidian + Claude Code + Codex**: De versionsstyrede `.md`-filer i `<OneDrive>\AI OS\` og den fysiske projektmappe `<OneDrive>\AI SOSU\` er de kanoniske kilder. Claude Code læser `CLAUDE.md`, og Codex læser det identiske `AGENTS.md`-spejl direkte fra hvert repo. Obsidian-vaulten har rod i `<OneDrive>\AI OS\`; projektfilerne forbliver i den separate kanoniske projektmappe og må aldrig kopieres eller eksporteres til `.obsidian/`.

## Session-startkontrol — kør ved FØRSTE prompt i hver session

Før du besvarer noget som helst, verificér følgende. Rapportér kun hvis noget **fejler**:

```
[ ] Spejlkontrol på tværs af alle projekter — kør scriptet, gæt ikke:
        & "AI OS\tools\sync-agents-md.ps1" -Check
    Exitkode 0 = alle CLAUDE.md/AGENTS.md-par er identiske. Exitkode 1 = drift; scriptet
    udskriver præcis hvilke projekter der afviger. Scriptet udleder selv projektroden som
    `AI SOSU` ved siden af AI OS — altså ARBEJDSKOPIEN. Indtil 2026-09-02 stod `Y:\AI SOSU`
    hårdkodet som standard (levn fra 20-08), så startkontrollen kontrollerede kollegernes
    forældede Y:-snapshot i stedet for de filer der faktisk redigeres — og kunne melde "OK"
    mens arbejdskopien var i drift. Kræver kontrollen pludselig netværk, er den fejlrettet.
[ ] INDEX.md findes i AI OS rod
[ ] agents/ indeholder: pbi-dax, pbi-powerquery, pbi-tmdl, pbi-performance, pbi-naming, pbi-kritik, pbi-design, inno-hr, inno-system, inno-logistics, inno-mailtemplate, md-optimizer, fin-analysis, fin-patterns, fin-statistics, fin-accounting, fin-data, fin-database, adm-bi
[ ] AI OS rod indeholder KUN: agents/, tools/, vault/, .githooks/, .claude/, .agents/, .codex/, .obsidian/, .codex-tmp/, .vscode/, CLAUDE.md, AGENTS.md, INDEX.md, .gitattributes, .gitignore — ingen fysiske projektmapper, og INGEN loese .md/.canvas/.base-filer (de hoerer i vault/)
[ ] <OneDrive>\AI SOSU findes (omdøbt fra `AI-SOSU` 2026-08-29) og er den ENESTE aktive arbejdskopi. Y:\AI SOSU og Y:\AI OS er delte samarbejdskopier for kollegerne — arbejd ALDRIG direkte i dem (se *Placering*)
[ ] <OneDrive>\AI SOSU\SYS-INNOMATE rod indeholder KUN: Input/, Output/, _Arkiv/, .githooks/, .claude/, .codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore (+ procesplan-generator: node_modules/, package.json, package-lock.json, generate-procesplan-v3.js)
[ ] <OneDrive>\AI SOSU\BI-OEKONOMI rod indeholder: Input/, Output/, Rapporter/, tools/, _Arkiv/, .githooks/, .claude/, .codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore
[ ] <OneDrive>\AI SOSU\ADM-HÅNDBØGER rod indeholder: Personalehåndbog/, Lederhåndbog/, Input/, Output/, _Arkiv/, .githooks/, .claude/, .codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore
[ ] <OneDrive>\AI SOSU\ADM-ØKONOMI rod indeholder: Regnskabsinstruks/, Indkøbspolitik/, Strategi for finansiel risiko/, Input/, Output/, _Arkiv/, .githooks/, .claude/, .codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore
[ ] <OneDrive>\AI SOSU\ADM-BI rod indeholder: Input/, Output/, _Arkiv/, .githooks/, .claude/, .codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore
[ ] <OneDrive>\AI SOSU\DATA-BUDGET_PROGNOSE rod indeholder: Input/, Output/, _Arkiv/, .githooks/, .claude/, .codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore
[ ] <OneDrive>\AI SOSU\ADM-KANTINE rod indeholder: Input/, Output/, tools/, .githooks/, .codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore
[ ] <OneDrive>\AI SOSU\BI-OPGAVEOVERSIGT rod indeholder: .githooks/, .codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore + PBIP-artefakterne
[ ] De tre projekter tilføjet 2026-08-20 har CLAUDE.md + AGENTS.md + .codex/config.toml:
    <OneDrive>\AI SOSU\ADM-AFTALER\, <OneDrive>\AI SOSU\ADM-BLANKET\, <OneDrive>\AI SOSU\BI-OPTAG FRAVÆR\
```

Hvis én eller flere tjek fejler: **stop, rapportér præcist hvad der mangler, og afvent instruktion.**

**Mappenavnet er `.codex` med små bogstaver.** Codex leder kun efter det navn. Windows er
case-insensitivt, så en fejlkapitaliseret `.Codex/` ser rigtig ud lokalt og virker tilfældigvis
— men navnet gemmes med stort C i git, og på ethvert andet system (Linux, CI, en frisk klon)
finder Codex ingenting. Fejlen var reel her indtil 2026-08-20. Opret aldrig `.Codex/` igen.

**Placering — én arbejdskopi, delte kopier på Y: (korrigeret 2026-08-29):** Alt arbejde foregår i OneDrive: `<OneDrive>\AI OS\` (dette repo + Obsidian-vault) og `<OneDrive>\AI SOSU\` (de 11 projektkloner, git + PBIP). `Y:\AI OS\` og `Y:\AI SOSU\` på SMB-drevet er **delte samarbejdskopier** til kollegerne — ikke arbejdsmapper: de holdes ajour fra GitHub (`git pull --ff-only` i hver klon; `Y:\AI OS` er en ren filkopi uden `.git`), og agenten skriver aldrig direkte i dem (git og PBI Desktop over VPN'en til Y: er 6–14× langsommere og filserveren afviser junctions/symlinks). Opdages arbejde der KUN findes på Y: (nyere commits eller ucommitterede ændringer), skal agenten stoppe og rapportere i stedet for at overskrive. Historik: 20-08 blev projektroden erklæret flyttet til `Y:\AI SOSU`, men arbejdet fortsatte i OneDrive (`AI-SOSU`); Y:-kopierne var derfor et 20-08-snapshot indtil 29-08. **Kodeordet "Udgiv"** (indført 2026-08-30, pendant til "Bogfør"): kør `tools\udgiv-til-y.ps1` (skill `/udgiv`) — det spejler `<OneDrive>\AI OS` til `Y:\AI OS` (robocopy, intet slettes) og ff-puller hver `Y:\AI SOSU\<repo>` fra GitHub (lokale ændringer på Y: stashes og rapporteres). Forudsætning: merget til `main` og pushet først. **Kollegerne arbejder i Y:-kopierne** og har ingen adgang til JSTs OneDrive — derfor må intet, kollegerne kører, forudsætte en OneDrive-sti: M-kode bruger lokalt spejl med fallback (`fxDatakildeSti`/`DATAKONTROLCENTER` i BI-OEKONOMI læser `Input\Datakilder` hvis mappen findes, ellers Y:), `DATAKONTROLCENTER` og udtrækkene på Y: er kollegernes datagrundlag og røres aldrig af agenten, og `.codex/config.toml` har begge rødder i `writable_roots`. Kør robocopy/git-scripts fra PowerShell, ikke Bash (stier konverteres forkert).

---

## Selvvedligehold — obligatorisk

Når du:
- **finder og retter en fejl** (konfiguration, routing, agent-opsætning, Git-quirks)
- **opdager ny viden** om projekter, agenter, arbejdsgange eller systemadfærd
- **gennemfører en ændring** der påvirker fremtidige beslutninger

…skal du **straks**:
1. Opdatere det relevante afsnit i denne CLAUDE.md
2. Spejle til AGENTS.md: `Copy-Item CLAUDE.md AGENTS.md` (eller `& "AI OS\tools\sync-agents-md.ps1"` for alle projekter på én gang)
3. Opdatere `INDEX.md` hvis filer er tilføjet, fjernet eller omdøbt
4. Verificere at `CLAUDE.md` og `AGENTS.md` er byte-identiske i det berørte repo — `& "AI OS\tools\sync-agents-md.ps1" -Check` gør det for alle projekter. Obsidian kræver ingen separat synkronisering, fordi vaulten læser de samme filer direkte
5. Committe ændringen: `git add CLAUDE.md AGENTS.md INDEX.md && git commit -m "Opdatér CLAUDE.md/AGENTS.md: <hvad og hvorfor>"`

**Glemmer du trin 2, stopper pre-commit-hooken dig** (`.githooks/check_md_mirror.py`). Ret spejlet
frem for at bruge `--no-verify`: et brudt spejl betyder at Claude Code og Codex arbejder efter
hver sin udgave af reglerne, og forskellen viser sig først når en agent handler forkert.

Dette gælder også de projektspecifikke `CLAUDE.md`/`AGENTS.md`-par i alle projekter under `<OneDrive>\AI SOSU\`. Instruktionsfil-opdateringer (CLAUDE.md, AGENTS.md, INDEX.md) må committes direkte til `main` — det er den etablerede undtagelse fra projekternes PR-regel.

---

## Agentadfærd — grundregler

<!-- Tilføjet efter fejl: agent bad bruger om at udføre manuelle handlinger agenten selv kunne udføre -->

**Agenten udfører ALTID alle opgaver selv. Brugeren må ALDRIG bedes om at udføre manuelle handlinger, som agenten kan udføre via tilgængelige værktøjer (filkopiering, PowerShell, git, filsøgning osv.). Sæt dig over forhindringerne — find en vej.**

Konkrete regler:

- **Filsøgning**: Brug `Glob` eller PowerShell `Get-ChildItem -Recurse` til at finde filer på maskinen — bed aldrig brugeren om at kopiere eller finde filer manuelt.
- **Filkopiering**: Brug PowerShell `Copy-Item` — bed aldrig brugeren om at kopiere filer via Stifinder eller andet.
- **Git-kommandoer**: Kør selv via Bash/PowerShell — bed aldrig brugeren om at køre git-kommandoer.
- **Valgmuligheder**: Når en sub-agent returnerer "Option A/B/C — hvad vil du?", præsentér valgmulighederne for brugeren, men udfør straks den valgte mulighed selv uden yderligere delegation til brugeren.
- **Sub-agent-resultater**: Når en sub-agent returnerer resultater der kræver efterfølgende filkopiering, git-kommandoer, encoding-konvertering eller lignende: udfør dem selv med Bash/PowerShell — gå ikke videre til brugeren.

### Læs kilden — antag aldrig et navn (indført 2026-08-01)

<!-- Tilføjet efter kalender-sessionen 30-07..01-08: fire selvstændige tidsspild, samme rod -->

Alle fire tidsspild i kalender-sessionen havde samme årsag: **jeg skrev et navn eller en egenskab
fra hukommelsen i stedet for at læse det der faktisk stod.** Konkret: PBIR-egenskaber gættet to
gange (`activeProjections` findes ikke og blokerede rapportens åbning), Deneb-feltnavne gættet
gennem fire spec-forsøg og tre forkerte ugedagsformler mens editorens datapanel viste dem hele
tiden, og JST sendt på jagt efter en Deneb-indstilling der ikke eksisterer.

Regler:

- **Feltnavne, kolonnenavne, måler-navne**: læs dem fra kilden (datapanel, TMDL-fil, `dax-query.ps1`) før du skriver dem. Aldrig fra hukommelsen.
- **PBIR-/TMDL-egenskabsnavne**: verificér mod en eksisterende fil der virker, eller mod `validate-tmdl.ps1`. En opfundet egenskab kan blokere hele rapportens åbning — ikke bare fejle stille.
- **Før du erklærer noget løst**: verificér på det tilfælde der FEJLEDE, ikke på et tilfældigt tilfælde der tilfældigvis virker. (Slicer-fejlen blev meldt løst efter ét klik med et periodevalg der lige akkurat ikke udløste scroll.)
- **Mål den metrik grænsen faktisk gælder** — ikke en nærliggende der er lettere at hente. (Målte "rækker med værdi" = 2.867, mens visualets loft gjaldt "rækker sendt til visualet" = 10.000.)
- **Send aldrig brugeren efter en indstilling du ikke selv har set** i UI'et eller i dokumentationen.

### Luk fejlklassen, ikke tilfældet (indført 2026-08-02)

Ti gate-runder på kalenderens testharnisk fandt **hver eneste gang** det næste tilfælde af
den klasse jeg lige havde erklæret lukket — som regel tredive linjer væk i samme fil. Det
gjaldt guard-opslag der kaster, håndkoblede konstantpar, krav over tomme mængder og negative
sammenligninger der bliver sande på `NaN`. Fra femte runde lå fundene i kode jeg havde
skrevet netop for at lukke klassen.

- **Erklær aldrig en fejlklasse lukket uden at have søgt hele filen** for samme mønster.
  Skriver commit-beskeden "klassen er lukket", så skal det være efterprøvet, ikke antaget.
- **Et krav der ikke kan fejle er intet værn.** Verificér for hvert nyt krav at det FAKTISK
  fejler, ved at mutere det led det vogter og køre hele kæden. Kodelæsning finder det ikke.
  De syv former: `Math.abs(NaN) > tol` er falsk (skriv positivt); `[].every()` er sand
  (bind til det forventede ANTAL); literal mod literal; ensidet grænse; `!== null` fanger
  ikke `undefined`; et kastende opslag i selve **kravteksten**, som evalueres uanset
  udfald; og — **fixturen indeholder ikke det tilfælde, det målte overhovedet afhænger af**
  (set 2026-08-03).
- **Et tidsafhængigt træk kræver en fixture der er relativ til i dag.** Rammen om dags dato
  blev tilføjet til Deneb-kalenderen, og hele testsuiten bestod **uændret på 138 krav**:
  suitens fixturer har faste august-datoer, så `idag`-serien var tom i dem alle og marken
  blev aldrig tegnet. Et krav der måler et mark der ikke findes, vogter ingenting. Byg
  fixturen fra `new Date()`, og læg altid en **negativ kontrol** ved siden af (fixture uden
  i dag → 0 rammer) — ellers kan "der er præcis én" ikke fejle på noget der altid tegner.
- **Formulér kravet på VIRKNINGEN, ikke på konstanten.** "Ingen skillestreg må skære en
  søjle" overlever en refaktorering; "offsettet er 0,14" gør ikke. Er kravet tosidet i
  virkeligheden, skal det være tosidet i koden: "rammen er diskret, men stadig tydelig"
  blev til bredde i 1–1,5 px og stiplings-**dækningsgrad** 25–90 %, fordi begge yderpunkter
  er reelle fejl. Et krav på tallene `[5,3]` ville falde ved enhver finjustering uden at
  sige noget om hvordan stregen ser ud.

### Fra visuelt brudt til plausibelt forkert er den værste retning (gate-doktrin 2026-08-03)

En måler der peger på en slettet tabel giver en rød trekant — grim, men **synlig**. Skriver man
den om, så den kører igennem og leverer et forkert tal, er fejlen usynlig og lander i en rapport
nogen træffer beslutninger på. Gaten gav NO-GO på netop den bevægelse i årsværk-sporet.

- **En omskrivning af en måler hvis kilde er FORSVUNDET, kan ikke verificeres mod sig selv.**
  Der findes intet før-tal at sammenligne med. Så skal der et EKSTERNT facit til (årsrapporten,
  en kendt total) — eller også skal måleren udfases bevidst til `BLANK()`, ikke gættes.
- **Efterprøv altid en påstand om GRAIN mod kilden.** Docstringen påstod at den slettede tabel
  var "en dedupliceret projektion" på én nøgle; dens M-kode i arkivet grupperede på **31
  kolonner**. Målingen afgjorde det: 56 og 121 nøgler havde varierende værdi, hvor facit for
  ækvivalens er 0.
- **"Ingen interne forbrugere" er en påstand, ikke et argument** — men den kan efterprøves, og
  gør man det, er `BLANK()` + `isHidden` den rigtige udfasningsform: navnet bevares, så eksterne
  referencer ikke fejler hårdt, og den røde trekant forsvinder. Slet ikke målerne.

### Tæl forekomsterne før en replace-all (set 2026-08-03)

Jeg rullede én projektion i et visual tilbage med en blind streng-erstatning og ramte **6
forekomster hvor kun 1 skulle ændres** — de øvrige 5 var allerede korrekte i main. `git diff`
mod udgangspunktet afslørede det med det samme. Tæl først, erstat derefter, og verificér
diffen mod den kilde du tror du ruller tilbage til.
- **Læg vagten inde i kravet, ikke i nabokravet.** Et krav skal kunne bære sin egen
  formulering alene.
- **Et krav der kun står som en kommentar er intet værn.** Kravet om at Vega-pinnet skulle
  følge Denebs version stod som `comment-vega` i `package.json` — og installationen gled fra
  5.30 til 5.33 mens Deneb kørte 6.2.0. Enhver "husk at"-note skal skrives som et krav der
  læser begge sider.
- **Mål på produktionens konfiguration.** En test der render uden den config produktionen
  bruger, måler et render der ikke findes — og efterlader selve produktionsknappen uvogtet.
  Deneb-suiten parsede uden `jsonConfig`, så en hvid gitterfarve i configen ville slette
  gitteret i rapporten med grøn test.
- **Klassen findes også i den lille fil.** `config.json` er elleve linjer; jeg lukkede den
  ene nøgle og søgte ikke de to andre. Filstørrelse er ingen undskyldning for ikke at søge.

---

## Hvad er AI OS?

AI OS er infrastrukturniveauet for alt AI-assisteret arbejde ved SOSU Randers. Her bor agentdefinitioner og AI-konfiguration (Claude Code: `.claude/settings.json`, Codex: `.codex/config.toml`). Det er **ikke** et arbejdsprojekt — det er værkstedet.

Arbejdsprojekterne ligger fysisk i den separate kanoniske projektmappe `<OneDrive>\AI SOSU\`:

| Projekt | Sti | Indhold |
|---|---|---|
| `BI-OEKONOMI` | `<OneDrive>\AI SOSU\BI-OEKONOMI\` | Power BI-rapport og semantisk model for HR/økonomi |
| `SYS-INNOMATE` | `<OneDrive>\AI SOSU\SYS-INNOMATE\` | Mailskabeloner og procesplaner for onboarding/offboarding via INNOMATE |
| `ADM-HÅNDBØGER` | `<OneDrive>\AI SOSU\ADM-HÅNDBØGER\` | Personalehåndbog og Lederhåndbog — afspejler hinandens emner |
| `ADM-ØKONOMI` | `<OneDrive>\AI SOSU\ADM-ØKONOMI\` | Regnskabsinstruks, Indkøbspolitik og Strategi for finansiel risiko |
| `DATA-BUDGET_PROGNOSE` | `<OneDrive>\AI SOSU\DATA-BUDGET_PROGNOSE\` | Finansiel analyse, budget og prognose — Navision finansposter + BRUGER-budget/prognose → .xlsx-output |
| `ADM-BI` | `<OneDrive>\AI SOSU\ADM-BI\` | BI governance og styringsdokumenter — datastandarder, navnekonventioner, roller og BI-strategi |
| `ADM-KANTINE` | `<OneDrive>\AI SOSU\ADM-KANTINE\` | Kantinens menukort og prisskilte — tilrettede udgaver af leverandørens ugemenu |
| `BI-OPGAVEOVERSIGT` | `<OneDrive>\AI SOSU\BI-OPGAVEOVERSIGT\` | Power BI-rapport: medarbejderes opgaveoversigt mod arbejdstidsnorm (Budgetskema.xlsx på SharePoint) |
| `BI-OPTAG FRAVÆR` | `<OneDrive>\AI SOSU\BI-OPTAG FRAVÆR\` | Power BI-rapport: elevoptag og skoleforløbsfravær (Studie+ Z8312 + Z8224S) |
| `ADM-AFTALER` | `<OneDrive>\AI SOSU\ADM-AFTALER\` | Samarbejds- og samhandelsaftaler med eksterne parter |
| `ADM-BLANKET` | `<OneDrive>\AI SOSU\ADM-BLANKET\` | Administrative blanketter og formularer (fx kørselsbemyndigelser) |

**Note om `ADM-KANTINE`** (oprettet 2026-07-28): repo [JST-BI/ADM-KANTINE](https://github.com/JST-BI/ADM-KANTINE) (privat). Ingen dedikeret agent — arbejd direkte. I modsætning til de øvrige projekter **committes `Input/` her**: leverandørens PDF'er er små og persondatafri, og de dokumenterer hvad et givet ugekort er bygget på.

**Note om de tre projekter tilføjet 2026-08-20** (`BI-OPTAG FRAVÆR`, `ADM-AFTALER`, `ADM-BLANKET`): de fik `CLAUDE.md`/`AGENTS.md`, `.codex/config.toml` og de versionerede hooks, da opsætningen blev gjort dual-læsbar. De har **lokale git-repos uden remote** — der er bevidst hverken oprettet GitHub-repo eller pushet noget, fordi fortrolighedsniveauet ikke er afklaret. `ADM-BLANKET` og `ADM-AFTALER` har `Input/` i `.gitignore` som forsigtig standard: begge indeholder personhenførbart materiale. Afklar med JST før de lægges på GitHub.

**Mapper der IKKE er projekter** (verificeret 2026-08-20 — opret ikke instruktionsfiler i dem): `ADM-MØDER/` (én løs .docx), `ADM-REVISION/` (tom), `BI-SOSU/` (mappe med en ugyldig `.git` — `git status` fejler med "not a git repository"). Bliver en af dem til et rigtigt projekt, så kør `tools/setup-new-repo.ps1` og tilføj den her.

---

## Hvornår arbejder du her vs. i et projekt?

| Situation | Arbejd i |
|---|---|
| Oprette eller redigere en agent | AI OS (`agents/`) |
| Ændre Claude Code-indstillinger | AI OS (`.claude/settings.json`) |
| Ændre Codex-indstillinger | AI OS (`.codex/config.toml`) — projektskabelon: `tools/codex-config.template.toml` |
| Bygge DAX, M-kode eller Power BI-rapporter | `<OneDrive>\AI SOSU\BI-OEKONOMI\` |
| Elevoptag eller skoleforløbsfravær i Power BI | `<OneDrive>\AI SOSU\BI-OPTAG FRAVÆR\` |
| Læse, sammenligne eller revidere en aftale | `<OneDrive>\AI SOSU\ADM-AFTALER\` |
| Blanketter og formularer | `<OneDrive>\AI SOSU\ADM-BLANKET\` |
| Skrive procesplaner eller mailskabeloner | `<OneDrive>\AI SOSU\SYS-INNOMATE\` |
| Redigere Personalehåndbog eller Lederhåndbog | `<OneDrive>\AI SOSU\ADM-HÅNDBØGER\` |
| Redigere Regnskabsinstruks, Indkøbspolitik eller finansiel risiko | `<OneDrive>\AI SOSU\ADM-ØKONOMI\` |
| BI governance, datastandarder, navnekonventioner eller BI-strategi | `<OneDrive>\AI SOSU\ADM-BI\` |
| Kantinens menukort, ugemenu eller prisskilt | `<OneDrive>\AI SOSU\ADM-KANTINE\` |
| Finansiel analyse, budget, prognose (Navision-data) | `<OneDrive>\AI SOSU\DATA-BUDGET_PROGNOSE\` |
| Noget der spænder over flere projekter | Start her, koordinér |

---

## Tilgængelige agenter

Agentfilerne ligger i `agents/` og er værktøjsuafhængige: YAML-frontmatter (`name`, `description`, `tools`, `model`) efterfulgt af selve rolleinstruksen i ren Markdown.

**Sådan bruges de i hvert værktøj:**

| Værktøj | Mekanisme |
|---|---|
| Claude Code | Læser `agents/` via symlink `~/.claude/agents/` og **spawner dem som selvstændige subagenter** med egen kontekst. |
| Codex | Har **ikke** subagenter. Læs `agents/<navn>.md`, ignorér frontmatter, og påtag dig rollen direkte i den aktuelle session. Skal flere agenter køre efter hinanden (se workflow-mønstrene nedenfor), gennemføres trinene sekventielt i samme session. |

Frontmatter-feltet `tools` er en Claude Code-begrænsning. I Codex er den kun vejledende — den
siger hvilke slags handlinger rollen forventes at udføre, ikke hvad der er teknisk muligt.

**Workflow-mønstre** (rækkefølge-regler for agentkæder) ligger i `.claude/rules/` i det enkelte
projekt-repo — i dag `BI-OEKONOMI/.claude/rules/pbi-workflows.md` og
`SYS-INNOMATE/.claude/rules/inno-workflows.md`. **Ingen af de to værktøjer indlæser dem
automatisk**; de er dokumentation, ikke konfiguration. Læs filen eksplicit — uanset om du kører
Claude Code eller Codex — når en opgave involverer flere agenter i det pågældende projekt.

> **`.codex/rules/` er ikke stedet for dem** (rettet 2026-08-20). Mappenavnet ser ud som et
> naturligt spejl af `.claude/rules/`, men `.codex/rules/` er et rigtigt Codex-koncept med et
> helt andet formål: **Starlark-baserede `.rules`-filer der styrer om en kommando må køre**
> (`prefix_rule(pattern = [...], decision = "prompt", ...)`). Codex scanner mappen ved opstart.
> Workflow-prosa i Markdown hører ikke til der og lå der fejlagtigt indtil 2026-08-20. Mappen
> står nu tom med `.gitkeep`, klar til ægte `.rules`-filer, hvis kommandotilladelser en dag
> skal styres pr. projekt. Læg aldrig `.md` i `.codex/rules/`.

### Agentgrupper og sprogkrav

Rollebeskrivelserne står i hver agents `description`-frontmatter i `agents/` (og i sessionens agent-liste) —
de gentages ikke her. Det frontmatter IKKE siger, er sprogkrav og obligatoriske gates:

| Gruppe | Agenter | Output-sprog / krav |
|---|---|---|
| Power BI | `pbi-dax`, `pbi-powerquery`, `pbi-tmdl`, `pbi-performance`, `pbi-naming`, `pbi-kritik`, `pbi-design` | US English i model og rapport; `pbi-kritik` (OBLIGATORISK gate før merge, GO/NO-GO) og `pbi-design` (OBLIGATORISK for alle visuals/PBIR-sider, JST-krav 2026-07-17) svarer på dansk |
| INNOMATE | `inno-hr`, `inno-system`, `inno-logistics`, `inno-mailtemplate` | dansk |
| DATA-BUDGET_PROGNOSE | `fin-analysis`, `fin-patterns`, `fin-statistics`, `fin-accounting`, `fin-data`, `fin-database` | .xlsx med danske formater; svar til bruger på dansk |
| Infrastruktur | `md-optimizer` | dansk — brug proaktivt efter sessioner med fejlrettelser eller arkitekturændringer |
| ADM-BI | `adm-bi` | dansk |

---

## Tilgængelige skills/plugins

Slash-kommandoer og skills (kun Claude Code) står i sessionens skill-liste og gentages ikke her — kald dem ved at skrive kommandoen i chatten.

I Codex findes hverken skills eller slash-kommandoer. Skal en af dem udføres der, læses den
tilsvarende instruks og udføres i hånden — fx et CLAUDE.md-eftersyn ved at følge
`agents/md-optimizer.md`.

---

## Codex-opsætning på en ny maskine (indført 2026-08-20)

De to værktøjer konfigureres **helt forskelligt**. Antag aldrig at en indstilling for det ene
også gælder det andet — de læser hver sit format fra hver sin mappe:

| | Claude Code | Codex |
|---|---|---|
| Instruktionsfil | `CLAUDE.md` | `AGENTS.md` (byte-identisk spejl) |
| Projektkonfiguration | `.claude/settings.json` | `.codex/config.toml` — **små bogstaver, TOML** |
| Personlig konfiguration | `~/.claude/` | `~/.codex/config.toml` |
| Agenter | `agents/` via `~/.claude/agents/` (spawnes som subagenter) | samme filer læses som rolleinstruks (ingen subagenter) |
| Kommandotilladelser | `permissions.allow` i JSON | `sandbox_mode` + `approval_policy`, og evt. Starlark i `.codex/rules/*.rules` |

**JSON-filer i `.codex/` har ingen virkning.** AI OS havde indtil 2026-08-20 en `.Codex/settings.json`
med Claude Codes `permissions.allow`-format. Codex læste den aldrig — den så bare rigtig ud.

### Lav friktion uden fuld adgang (indført 2026-08-20)

AI OS' `.codex/config.toml` bruger `sandbox_mode = "workspace-write"`,
`approval_policy = "on-request"` og `approvals_reviewer = "auto_review"`. Dermed kører sikre
arbejdshandlinger uden brugerprompt, mens undtagelser risikovurderes automatisk; netværk er fortsat
lukket som standard, og AGENTS.md's strengere bekræftelseskrav gælder stadig.

`<OneDrive>\AI SOSU\` er projektroden. Den skal stå (som fuld sti) i
`sandbox_workspace_write.writable_roots`; ellers udløser almindelige projektedits gentagne
godkendelser. Konfigurationsændringer indlæses først i en ny Codex-session.

### Tre ting der skal gøres én gang pr. maskine

1. **Markér projekterne som betroede.** Codex indlæser kun projekt-lokale `.codex/`-lag
   (config, rules, hooks) hvis projektet er betroet. Er det ikke det, springes hele laget over
   uden fejlmeddelelse — en bevidst sikring mod at et klonet repo medbringer sine egne
   løsslupne indstillinger. Trust sættes i din **personlige** `~/.codex/config.toml`, ikke i
   repoet, netop fordi repoet ellers kunne erklære sig selv betroet:

   ```toml
   [projects]
   "C:\\Users\\jst\\OneDrive - Social og Sundhedsskolen Randers\\AI OS".trust_level = "trusted"
   "C:\\Users\\jst\\OneDrive - Social og Sundhedsskolen Randers\\AI SOSU\\BI-OEKONOMI".trust_level = "trusted"
   # ... én linje pr. projekt
   ```

2. **Verificér at `project_doc_max_bytes` slår igennem.** Standardloftet er 65536 bytes.
   `BI-OEKONOMI/AGENTS.md` var **91.960 bytes** da loftet blev hævet — Codex afkortede den
   altså og mistede de nederste ~26 KB regler, uden at sige det. Loftet hæves til 262144 i hvert
   repos `.codex/config.toml`, men **kun hvis projektet er betroet** (punkt 1). Springes trust
   over, er man tilbage ved 64 KB.

3. **Aktivér de versionerede hooks:** `git config core.hooksPath .githooks` — én gang pr. klon.
   Git kører ikke versionerede hooks automatisk. Uden dette virker hverken Excel-persondata-
   spærringen eller spejlkontrollen.

### AGENTS.md findes ved at gå opad — ikke på tværs

Codex leder efter `AGENTS.md` fra arbejdsmappen og opad mod projektroden (mappen med `.git`).
Arbejder du i `<OneDrive>\AI SOSU\BI-OEKONOMI\`, læses **kun** det projekts `AGENTS.md` — ikke AI OS'.
Derfor skal enhver regel, der gælder på tværs af projekter, stå i hvert projekts egen fil eller
udtrykkeligt henvise til `../../AI OS/AGENTS.md`. Det samme gælder Claude Code og `CLAUDE.md`.

`project_doc_fallback_filenames = ["CLAUDE.md"]` i hver `.codex/config.toml` gør at Codex falder
tilbage på Claude Codes fil, hvis `AGENTS.md` mangler. Det er et sikkerhedsnet mod et brudt
spejl — ikke en erstatning for det.

**Kilder** (verificeret 2026-08-20): [Konfigurationsreference](https://learn.chatgpt.com/docs/config-file/config-reference) · [Rules](https://learn.chatgpt.com/docs/agent-configuration/rules)

---

## Routing — kør dette først ved enhver opgave

```
Opgaven vedrører agenter eller AI-konfiguration?
  JA  → Arbejd direkte her i AI OS.
  NEJ →
    Drejer det sig om optimering/opdatering af .md-filer eller hukommelse?
      JA  → Spawn md-optimizer (kun Claude Code; i Codex: følg agents/md-optimizer.md som instruks).
      NEJ →
        Drejer det sig om Power BI (DAX, M-kode, TMDL, rapporter)?
          JA  → Skift til BI-OEKONOMI og brug pbi-agenter.
          NEJ →
            Drejer det sig om finansiel analyse, budget eller prognose (Navision-data)?
              JA  → Skift til DATA-BUDGET_PROGNOSE og brug fin-agenter.
              NEJ →
                Drejer det sig om INNOMATE (onboarding, skabeloner, processer)?
                  JA  → Skift til SYS-INNOMATE og brug inno-agenter.
                  NEJ →
                    Drejer det sig om BI governance, datastandarder eller BI-strategi?
                      JA  → Skift til ADM-BI og brug adm-bi agenten.
                      NEJ →
                        Drejer det sig om kantinen (menukort, ugemenu, prisskilt)?
                          JA  → Skift til ADM-KANTINE (ingen dedikeret agent — arbejd direkte).
                          NEJ →
                            Drejer det sig om elevoptag eller skoleforloebsfravaer?
                              JA  → Skift til BI-OPTAG FRAVÆR og brug pbi-agenter.
                              NEJ →
                                Drejer det sig om en aftale eller kontrakt?
                                  JA  → Skift til ADM-AFTALER (ingen dedikeret agent).
                                  NEJ →
                                    Drejer det sig om en blanket eller formular?
                                      JA  → Skift til ADM-BLANKET (ingen dedikeret agent).
                                      NEJ → Afklar med brugeren hvilket projekt opgaven tilhører.
```

---

## Sikkerhedsregler — handlinger der ALTID kræver bekræftelse

Uanset hvad tilladelsesindstillingerne tillader automatisk, skal agenten **altid stoppe og spørge** før:

| Handling | Eksempel |
|---|---|
| `git push --force` | Overskriver fjernhistorik |
| Sletning af filer/mapper uden for projektmapperne | `rm` på stier uden for `<OneDrive>\AI SOSU\` eller `<OneDrive>\AI OS\` |
| Masseoperationer der ikke kan fortrydes | Slette >5 filer på én gang |
| Afsendelse til eksterne tjenester | E-mail, API-kald med persondata |
| Ændring af Git-konfiguration globalt | `git config --global` |

Alt andet kører uden prompt.

---

## Regler for denne mappe

- **Kun AI-infrastruktur hører hjemme her.** Projektindhold (budgetter, skabeloner, rapporter) hører i `<OneDrive>\AI SOSU\`.
- **Obsidian-vault**: Vault-roden er `<OneDrive>\AI OS\`, og `.obsidian/` er kun vaultens konfigurationsmappe. Arbejdsprojekterne ligger separat og kanonisk i `<OneDrive>\AI SOSU\`; opret aldrig kopier eller links til dem under vaulten. Åbn aldrig `.obsidian/` som en separat vault.
- **Obsidian-livekontrol**: Verificér en åbnet fil via den aktive tabs `state.state.file` under `main` i `.obsidian/workspace.json` (eller den synlige vinduestitel). Brug ikke `lastOpenFiles` som facit; listen kan halte, selv om filen er åbnet korrekt.
- Nye agenter oprettes som `.md`-filer i `agents/` med korrekt frontmatter (`name`, `description`, `tools`, `model`).
- `INDEX.md` er det samlede filindeks over alle styrede filer i alle 11 projekter + AI OS — opdatér det når filer tilføjes, fjernes eller omdøbes.
- Ændringer commites og pushes til GitHub: `https://github.com/JST-BI/AI-OS`

---

## Obsidian-vaultregler (indført 2026-08-22, opdateret 2026-08-25 efter JSTs systemprompt *Obsidian AI Assistant v4.2*)

Vaulten er AI OS-roden, men den indeholder to slags filer med **hver sit regelsæt**. Bland dem aldrig sammen.

### Scope — hvad reglerne herunder gælder

| Filer | Regelsæt |
|---|---|
| **`vault/**`** — frie noter (daily, møder, personer, beslutninger, ressourcer) | **Dette afsnit.** Frontmatter, wikilinks, routing, index-vedligehold, AI-metadatablok. |
| `CLAUDE.md`, `AGENTS.md`, `INDEX.md` | Spejlprincippet og selvvedligeholds-pligten øverst i filen. **Ingen note-frontmatter** — de læses af Claude Code og Codex som instruktion. |
| `agents/*.md` | Claude Codes agent-frontmatter (`name`, `description`, `tools`, `model`). **Skriv aldrig `tags`/`created`/`status` i dem** — det brækker agent-indlæsningen. |
| Alt under `<OneDrive>\AI SOSU\` | Det pågældende projekts egen `CLAUDE.md`; AI OS-vaulten styrer dem ikke. |

**Projekt-noter hører i projektets eget repo**, ikke i `vault/`. Routing-tabellens `/projects`-linje er derfor ikke i brug her — `vault/projects/` findes bevidst ikke.

### Grundregler

- **Aldrig absolutte stier i interne links.** Wikilinks: `[[Notenavn]]`, `[[Notenavn|alias]]`, embeds `![[fil]]` / `![[fil|bredde]]`, callouts `> [!note] Titel` (note, tip, warning, info, example, abstract, todo). Undgå `[tekst](sti)` til interne noter.
- **Slet, omdøb eller overskriv aldrig JSTs egne noter og formuleringer uden en direkte instruktion.** Uopfordrede tilføjelser lægges nederst under `## AI Indsigter (YYYY-MM-DD)`. Ved større omstrukturering: foreslå først.
- **Brug den reelle dags dato** i `created:`/`updated:` — slå den op, gæt den ikke. `updated:` sættes ved **enhver** redigering.
- **Ved tvivl om placering, navngivning eller indhold: spørg.** Gæt ikke — det er samme regel som *Læs kilden — antag aldrig et navn* ovenfor.
- Markér AI-berørte noter med `#ai-assisted` når det er relevant.
- Svar på samme sprog som brugeren (her: dansk).

### Frontmatter — obligatorisk på nye vault-noter

```yaml
---
tags: []          # kebab-case, genbrug eksisterende tags
created: YYYY-MM-DD
updated: YYYY-MM-DD
status: draft     # draft | review | permanent | archived
aliases: []
type:             # meeting | project | note | resource | daily | person | decision | index
---
```

Skabeloner ligger i `vault/_templates/` ([[Daily]], [[Note]], [[Meeting]], [[Decision]]).

### Routing

| Indholdstype | Placering | Filnavn | `type:` |
|---|---|---|---|
| Daglig note | `vault/journal/` | `YYYY-MM-DD.md` | daily |
| Møde | `vault/meetings/` | `YYYY-MM-DD - Mødetitel.md` | meeting |
| Permanent note | `vault/notes/` | `Titel.md` | note |
| Person | `vault/notes/people/` | `Fornavn Efternavn.md` | person |
| Beslutning | `vault/notes/decisions/` | `YYYY-MM-DD - Beslutning.md` | decision |
| Ressource/kilde | `vault/resources/` | `Titel.md` | resource |
| Uforarbejdet | `vault/inbox/` | `YYYY-MM-DD - Kort titel.md` | – |
| Index/MOC | `vault/` | `Index - Emne.md` (alt. `MOC - Emne.md`) | index |
| Vedhæftning (billede, PDF) | `vault/_attachments/` | beskrivende filnavn | – |

Filnavne i Title Case eller `YYYY-MM-DD - Titel`. Undgå `/ \ : * ? " < > |`.
**Opret aldrig en ny mappe i `vault/` uden at sige det** — og aldrig en ny mappe i AI OS-roden, som er dækket af startkontrollen.

**Routing-principper** (i rækkefølge):
1. Tjek eksisterende mapper og noter først — findes emnet allerede, så udvid frem for at oprette.
2. Hører noten til et projekt → den hører i projektets eget repo under `<OneDrive>\AI SOSU\`, ikke i `vault/`.
3. Ved tvivl → foreslå muligheder, eller læg noten midlertidigt i `vault/inbox/` og sig det.

Obsidian er konfigureret til at følge dette: `.obsidian/app.json` lægger nye filer i `vault/inbox/`, `daily-notes.json` peger på `vault/journal/`, og `templates.json` på `vault/_templates/`. **Uden den opsætning skrev daily-notes-pluginet i roden** — det var kilden til de tomme `2026-08-18.md` og `Unavngivet*`-filer der lå der indtil 2026-08-22.

> [!warning] Obsidian skriver sin egen konfiguration tilbage
> En kørende Obsidian holder indstillingerne i hukommelsen og skriver **hele** `.obsidian/*.json`
> til disk, når noget ændres i UI'et. Redigerer du filerne mens programmet kører, kan ændringen
> derfor blive overskrevet uden varsel. **Genstart Obsidian, efter du har rørt `.obsidian/`** — og
> verificér bagefter på den faktiske adfærd (opret en note og se hvor den lander), ikke på filens
> indhold. Samme fejlklasse som PBI-gem der overskriver disk-edits.

### Index/MOC-vedligehold

[[Index - Vault]] er vaultens MOC. `INDEX.md` i roden er noget andet: filindekset over **styrede** filer i alle 11 projekter. Vault-noter hører ikke i `INDEX.md`.

- Index-noter er **rene oversigter**: korte beskrivelser + lister med wikilinks. Ingen brødtekst.
- Opretter du en note der hører under et eksisterende index → **tilføj wikilinket der**. Ny kategori → foreslå et nyt index (opret det kun efter tilladelse).
- **Tjek altid for dubletter før du tilføjer**, og fjern dem du støder på — og nævn kort i svaret at du har ryddet op. Brug det kanoniske filnavn frem for aliaset, medmindre aliaset er tydeligt mere læsbart.
- Sortér alfabetisk, medmindre kronologisk er mere meningsfuldt. Bliver et index for langt → foreslå opdeling.
- Opdatér `updated:` i indexet. Er ændringen større, notér den under `## AI Indsigter (YYYY-MM-DD)`.

### Arbejdsflow ved enhver vault-opgave

1. Læs relevant kontekst (eksisterende noter, index, tags) før du skriver.
2. Anvend routing-tabellen og -principperne ovenfor.
3. Tjek om den nye/ændrede note skal linkes ind i et eksisterende index/MOC — og opdatér det uden dubletter.
4. Foreslå wikilinks til relaterede noter (eksisterende tags og noter frem for nye).
5. Rapportér kort hvad du har oprettet/ændret, hvor det ligger, og hvilke indexes du har opdateret — det er indholdet af metadatablokken nedenfor.

### Svarprotokol ved vault-ændringer

Når — og **kun** når — du opretter, opdaterer eller omstrukturerer filer i `vault/`, indled svaret med:

```yaml
# AI_ACTION_METADATA
action: [created | updated | restructured]
target_file: "vault/relativ/sti.md"
frontmatter_updated: [true | false]
indexes_updated: ["Index - Vault"]
changes_summary: "Kort, præcis beskrivelse"
ai_confidence: [high | medium | low]
```

Udelades ved læsning, analyse og almindelige spørgsmål — og ved alt arbejde uden for `vault/` (TMDL, PBIR, instruktionsfiler, projektfiler). Blokken er til vault-noter, ikke til hver eneste filændring i systemet.

---

## Navnekonvention — nye projekter

Præfiks bestemmer projekttype. GitHub-repo og lokal mappe hedder det samme:

| Præfiks | Projekttype | GitHub-repo | Lokal mappe |
|---|---|---|---|
| `BI-` | Power BI-rapporter og datamodeller | `JST-BI/BI-<EMNE>` | `<OneDrive>\AI SOSU\BI-<EMNE>` |
| `SYS-` | Systemkonfiguration og procesautomatisering (fx INNOMATE) | `JST-BI/SYS-<EMNE>` | `<OneDrive>\AI SOSU\SYS-<EMNE>` |
| `ADM-` | Administrative dokumenter (håndbøger, politikker) | `JST-BI/ADM-<EMNE>` | `<OneDrive>\AI SOSU\ADM-<EMNE>` |

**Bemærk**: Alle projekter samles under `<OneDrive>\AI SOSU\`. GitHub-repo-navne skal være ASCII (undgå æ, ø, å).

**OBLIGATORISK ved nyt repo** (straks efter `git init`/`git clone`): kør
`pwsh AI OS/tools/setup-new-repo.ps1 -RepoPath "<sti til nyt repo>"`. Det installerer den versionerede Excel-persondata pre-commit hook (`.githooks/`), sætter `eol=lf` i `.gitattributes` og aktiverer `core.hooksPath`. Commit derefter `.githooks/` + `.gitattributes`. Se datagovernance-afsnittet nedenfor.
**Bemærk**: `pwsh` findes ikke på denne maskine (kun Windows PowerShell 5.1) — kald scriptet direkte: `& "AI OS\tools\setup-new-repo.ps1" -RepoPath "<sti>"`.

**OGSÅ OBLIGATORISK ved nyt repo — binær-attributter FØR første commit** (set 2026-07-28 i ADM-KANTINE): tilføj `*.pdf binary` (+ `*.png`/`*.jpg`/`*.xlsx`) i `.gitattributes`. Git detekterer binærfiler på NUL-bytes tidligt i filen, og **små, ukomprimerede PDF'er (fx reportlab-genererede) fejldetekteres som TEKST** → CRLF-konvertering ved checkout → filen er korrupt og kan ikke åbnes. Advarslen ved `git add` er den eneste indikation: `warning: ... LF will be replaced by CRLF`. Verificér med `git check-attr text -- <fil>` (skal give `text: unset`) og — efter push — ved at klone til en KORT sti (`C:\Temp\x`; lange stier giver `fatal: cannot write keep file ... Filename too long`) og sammenligne `Get-FileHash`.

---

## Datagovernance — Excel og persondata på GitHub

**Regel (JST, 2026-06-02): Excel-filer med persondata (navn, CPR og/eller e-mail) må ALDRIG på GitHub. Rene Excel-filer er tilladt.**

- Håndhæves af en **versioneret pre-commit hook** i alle 8 repos: `.githooks/pre-commit` + `.githooks/check_excel_pii.py` (committet i repoet). Scanner staged `.xlsx/.xlsm` for CPR (`DDMMYY-XXXX`), e-mail, og kolonner med `navn/fornavn/efternavn/cpr/personnummer/mail` → blokerer commit hvis fundet. Override: `git commit --no-verify`.
- **Aktivér efter `git clone`** (ÉN gang pr. klon — git kører ikke versionerede hooks automatisk af sikkerhedshensyn): `git config core.hooksPath .githooks`. Se `.githooks/README.md`.
- `.gitattributes` tvinger `eol=lf` på `.githooks/pre-commit` + `check_excel_pii.py` — ellers ville `* text=auto` give CRLF ved Windows-checkout og brække shebang.
- Ved untrack af allerede-committet Excel: `git rm --cached --ignore-unmatch '*.xlsx' '*.xls' '*.xlsm' '*.xlsb'` (beholder filerne på disk).
- `DATA-BUDGET_PROGNOSE` holder desuden `Input/**/*.xlsx` (m.fl.) path-ignoreret (store datagrundlag); rene `Output/`-leverancer må committes.
- Detaljer + scanner-logik: se hukommelsesfil `no-excel-on-github.md`.

**Regel (JST, 2026-06-16): Persondata (CPR, navn, e-mail) må ALDRIG returneres til samtalen — kun aggregater.** Værktøjerne kører lokalt, men tool-OUTPUT + filindhold sendes til Anthropics servere (modellen er cloud). Derfor: ved enhver kilde med persondata (Z8050/`cpr_nr`, SD-løn, INNOMATE-eksporter, elevlister m.fl.) skal scripts kun udskrive AGGREGATER (antal, summer, distinkte-tællinger, deltaer, ikke-personhenførbare nøgler som forløbs-/kontokoder) — ALDRIG rå personrækker eller CPR-/navne-/mail-værdier. Læs aldrig en persondata-fil direkte ind i konteksten; skriv i stedet et lokalt script der kun returnerer det aggregerede resultat. **Dette gælder også sub-agenter du spawner**: en gate-/analyse-agent med Bash/PowerShell-adgang kan selv læse en CPR-kilde og lække en værdi (skete 2026-06-16). Forbyd eksplicit rå persondata-læsning i agentens prompt, OG forhåndsberegn hellere aggregaterne selv og giv agenten kun de færdige tal. Begrundelse + how-to: hukommelsesfil `persondata-kun-aggregater.md`.

---

## Power BI-gotchas (PowerShell/TMDL/PBIR) — flyttet

Afsnittene *PowerShell gotchas — TMDL-filer*, *TMDL-syntaks — gotchas* og *PBIR-rapporter — gotchas (visuals)*
ligger fra 2026-08-25 i `<OneDrive>\AI SOSU\BI-OEKONOMI/CLAUDE.md` (spejlet i `AGENTS.md`), fordi de kun gælder
Power BI-arbejde, som routing-tabellen sender dertil. **De gælder ALLE BI-projekter** (`BI-OEKONOMI`,
`BI-OPTAG FRAVÆR`, `BI-OPGAVEOVERSIGT`) — læs dem dér før enhver TMDL-/PBIR-edit, uanset hvilket repo du står i.
