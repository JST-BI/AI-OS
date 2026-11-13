# AI OS (SOSU Randers) — agentregler

`<OneDrive>` = `C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers`.
"Agenten" = den aktive AI-agent (Claude Code eller Codex). Funktioner der kun findes i ét
værktøj er markeret "(kun Claude Code)" / "(kun Codex)".

## Hvad dette repo er

AI OS er værkstedet, ikke et arbejdsprojekt: agentdefinitioner (`agents/`), AI-konfiguration
(`.claude/`, `.codex/`), delte PowerShell-værktøjer (`tools/`) og Obsidian-vaulten (`vault/`).
Projektindhold hører aldrig her.

`INDEX.md` er det samlede filindeks over styrede filer i alle projekter. Opdatér det når filer
tilføjes, fjernes eller omdøbes.

Strukturen kontrolleres maskinelt ved sessionsstart af `tools/session-start-kontrol.ps1`
(SessionStart-hook). Den er tavs når alt er i orden og melder kun det der fejler — der er derfor
ingen tjekliste at gennemgå i hånden.

## Projekter — hvor hører opgaven til

Alle arbejdsprojekter ligger i `<OneDrive>\AI SOSU\<PROJEKT>`, ét git-repo pr. projekt.

| Projekt | Brug til |
|---|---|
| `BI-OEKONOMI` | Power BI: HR/økonomi-rapporten og den semantiske model (HR_OEKONOMI) + scenariemotoren; rummer også FB-kæden og BI_SOSU (rækkerne herunder) |
| `BI-OEKONOMI/DATA-BUDGET_PROGNOSE` | Finansiel analyse, budget og prognose — FB <år> (Navision + BRUGER-budget → .xlsx); undermappe med egen `AGENTS.md` |
| `BI-OEKONOMI/BI-SOSU` | Power BI: rapporten BI_SOSU — de fire FB-tabeller (elevaktivitet, økonomi, elevoptag, årsværk) som matricer med drill; undermappe med egen `AGENTS.md` |
| `BI-OPTAG FRAVÆR` | Power BI: elevoptag og skoleforløbsfravær (Studie+ Z8312 + Z8224S) |
| `BI-OPGAVEOVERSIGT` | Power BI: opgaveoversigt mod arbejdstidsnorm |
| `SYS-INNOMATE` | Mailskabeloner og procesplaner for on-/offboarding |
| `ADM-HÅNDBØGER` | Personalehåndbog og Lederhåndbog |
| `ADM-ØKONOMI` | Regnskabsinstruks, Indkøbspolitik, Strategi for finansiel risiko |
| `ADM-BI` | BI governance: datastandarder, navnekonventioner, roller, BI-strategi |
| `ADM-KANTINE` | Kantinens ugemenu og prisskilte (`Input/` committes her — PDF'erne er kilden) |
| `ADM-AFTALER` | Samarbejds- og samhandelsaftaler |
| `ADM-BLANKET` | Blanketter og formularer |
| `ADM-RETTIGHEDSSTYRING` | Rettighedsstyring på Y:-drevet: ACL- og gruppemedlemsudtræk → adgangsoversigter |
| `ADM-BESPARELSER` | Afskedigelser ved besparelser: procesplaner og varslinger om påtænkt opsigelse |
| `ADM-INSTITUTIONSLANDSKAB` | Epx-reformen: skolens tilkendegivelse til STUK (frist 20-01-2027) og egne aktivitetsskøn mod STUKs |

Hvert projekt har sin egen `AGENTS.md` med projektets regler — den er facit for arbejde der.
Er opgaven ikke dækket af en række herover, så spørg hvilket projekt den hører til frem for at
gætte.

`ADM-MØDER/` og `ADM-REVISION/` er **ikke** projekter (løse filer / tom). Bliver en af dem til
et rigtigt projekt: kør `tools/setup-new-repo.ps1` og tilføj rækken her.

**Samlet 13-11-2026 (JST 12-11: "alt i ét"):** `DATA-BUDGET_PROGNOSE` og `BI-SOSU` er flyttet ind i BI-OEKONOMI
med historik. De gamle kloner ligger i `AI SOSU\_ARKIV\<navn> - flyttet til BI-OEKONOMI 2026-11-13` (OneDrive og
Y:; JST 13-11: omdøbt, så de ikke bruges ved en fejl) — arbejd aldrig dér, og flyt dem aldrig tilbage; de slettes kun på
JSTs ord. `_ARKIV` har ingen `.git`, så Udgiv springer den over. Det forhindrer, at en rettelse eller en rapport rammer
en kopi, som ingen kæde opdaterer.

`ADM-AFTALER`, `ADM-BLANKET`, `BI-OPTAG FRAVÆR`, `ADM-RETTIGHEDSSTYRING`, `ADM-BESPARELSER` og
`ADM-INSTITUTIONSLANDSKAB` har lokale repos **uden remote** — fortrolighed er ikke afklaret. Læg dem ikke på GitHub uden
JSTs ord (BI-SOSU må på GitHub: JST 12-11-2026). `ADM-AFTALER`, `ADM-BLANKET`, `ADM-RETTIGHEDSSTYRING` og `ADM-BESPARELSER` har
`Input/` i `.gitignore`, fordi materialet er personhenførbart; `ADM-RETTIGHEDSSTYRING`,
`ADM-BESPARELSER` og `BI-OEKONOMI/BI-SOSU` gitignorer også `Output/` af samme grund (oversigter, varslinger
og FB-tabeller med navngivne medarbejdere).

## Placering — én arbejdskopi, delte kopier på Y:

Alt arbejde foregår i OneDrive. `Y:\AI OS` og `Y:\AI SOSU` er **kollegernes delte kopier** — ikke
arbejdsmapper. Skriv aldrig direkte i dem: git og PBI Desktop over VPN'en er 6–14× langsommere, og
filserveren afviser junctions/symlinks. Findes der arbejde der KUN er på Y: (nyere commits eller
ucommitterede ændringer): stop og rapportér frem for at overskrive.

Kollegerne har ingen adgang til JSTs OneDrive. Intet de kører må forudsætte en OneDrive-sti —
M-koden bruger lokalt spejl med fallback til Y:.

På Y: er der to slags filer, og de har hver sin regel:

- **Datagrundlaget** — udtrækkene (Z8050, Navision m.fl.) og kollegernes egne arbejdsfiler.
  Dem overskriver agenten aldrig; de er kilden, og de produceres et andet sted.
- **Styringsfilerne** — `DATAKONTROLCENTER` og DIM-/oversigtsfilerne, som modellen slår op i
  (`fxDatakildeSti` læser stier dér). Dem **vedligeholder agenten**: det er selve arbejdet at
  registrere en ny datakilde eller rette en dimension, og modellen kan ikke fungere uden.
  Sig hvad du ændrer, og tag en kopi af filen før en ikke-triviel rettelse — kollegerne
  arbejder i den samtidig.

**Filer JST lægger på Y: hentes straks ind i OneDrive** (hash-tjek, aldrig overskrivning), og Udgivs
rapport "Filer der kun findes paa Y:" skal være 0 før en opgave meldes færdig. Udgiv fører kun
OneDrive → Y:, så en PowerPoint lagt i `Y:\…\Input` var ellers usynlig for arbejdskopien (2026-09-15).
**Y: og OneDrive skal være identiske — også gitignoreret Input/Output med persondata og repos uden
remote** (JST 2026-09-15). Udgiv sørger for det; Y:-klonerne står dog altid på `main`.
**Eneste undtagelse: `ADM-BESPARELSER` må aldrig kopieres til Y:** — hverken repo eller filer
(JST 2026-10-16; afskedigelsesvarslinger med navn og CPR). Udgiv springer det over via
`$IkkePaaY` i `tools/udgiv-til-y.ps1`; et nyt fortroligt projekt føjes til den liste.
Samme følsomhed i en undermappe af et udgivet repo → `$IkkePaaYStier`: i dag
`BI-OEKONOMI/DATA-BUDGET_PROGNOSE/Output/Grundlag/budget2027/` (og den gamle klons sti; FB-grundlaget med `jst-valg.json` – hvem sparerunden omfatter;
JST 2026-11-05: "Grundlaget bliver lokalt – indtil videre"; fjern stien fra listen kun på JSTs ord).

**Kodeordet "Udgiv"** → skill `/udgiv` (`tools/udgiv-til-y.ps1`). Forudsætter at alt er merget til
`main` og pushet — Udgiv henter fra GitHub, ikke fra OneDrive-klonerne.
**Sider/artefakter skal også på Y: (JST 2026-11-10):** når en side udgives på claude.ai, gemmes samme HTML som selvstændig fil
(`<!doctype html>`, charset, titel) i projektets `Output\Sider\` (gitignoreret); lokale sider med navne i `Output\Budget\* - med navne.html` (entydigt navn: `FB 2027 - fire tabeller som side <dato> - med navne.html` / `- uden navne.html` i `Output\Sider\`; JST 11-11).
Udgiv spejler dem (filer git ikke følger) – ellers ligger siden kun i en jobmappe og på claude.ai, som kollegerne ikke kan åbne.

Kør robocopy- og git-scripts fra PowerShell, ikke fra Bash: stier konverteres forkert.
`Y:` er en pr.-logon-mapping der kan falde ud midt i en session; `Test-Path` på UNC-stien vækker
den.

## Instruktionsfiler — én fil, uafhængig af AI-model

`AGENTS.md` er den eneste instruktionsfil i hver mappe hvor den findes; Codex og Claude Code
(≥ v2.1.277) læser den direkte. Der må ingen `CLAUDE.md`, `CLAUDE.local.md` eller
`.claude/CLAUDE.md` findes — i mappen eller over den får de Claude Code til at ignorere
`AGENTS.md`. `& "AI OS\tools\sync-agents-md.ps1" -Check` melder dem (sessionsstartkontrollen kører
den); uden `-Check` sletter den rene pegefiler. Pre-commit-hooken `.githooks/check_kun_agents_md.py`
blokerer dem ved commit. Reglerne må aldrig afhænge af hvilken model der kører (JST 2026-10-12);
pegefilen `CLAUDE.md` → `@AGENTS.md` blev fjernet overalt 2026-11-01.

**Skills følger samme princip:** `.agents/skills/<navn>/` er eneste kilde (Codex læser den);
`.claude/skills/` er et byte-identisk spejl, som kun `tools/sync-skills.ps1` skriver — Claude Code
har ingen import for skills, og filserveren afviser symlinks. Redigér aldrig i `.claude/skills/`;
`.githooks/check_skills_mirror.py` blokerer drift, og sessionsstartkontrollen melder den.

Codex finder `AGENTS.md` ved at gå opad mod nærmeste `.git` — aldrig på tværs. En regel der skal
gælde i et projekt, skal stå i det projekts egen fil.

Når du retter en fejl eller lærer noget der ændrer fremtidige beslutninger: skriv det ind i den
relevante `AGENTS.md`, opdatér `INDEX.md` hvis filer er kommet til eller forsvundet, og commit.
Instruktionsfiler må committes direkte til `main`. Viden der kun ligger i ét værktøjs private
hukommelse, findes ikke for det andet — repoets `AGENTS.md` er den hukommelse der tæller.

**Skriv reglen, ikke historien.** Én linje med hvad man skal gøre, og én med den konkrete fejl den
forhindrer. Undersøgelsesforløb og PR-narrativ hører i en arbejdsnote i repoet — ikke i en fil der
indlæses ved hver eneste session. Vokser et afsnit ud over ~20 linjer, hører detaljen i en separat
fil som `AGENTS.md` henviser til.

Opsætning af Codex på en ny maskine: `tools/codex-opsaetning.md`.

## Faste kommandoer — pause, bogfør, udgiv, aflever

**Kodeordet "aflever"** (eller "bogfør, merge og udgiv") → skill `/aflever`: sikr egne grene, bogfør, ét
merge-valg til JST over de klare PR'er, ff OneDrive-klonerne + INDEX, udgiv, ryd egne worktrees op, samlet
rapport (JST 2026-11-07). Bogfør og udgiv alene dækker ikke push af grene, klonernes ff eller oprydning.

**Kodeordet "pause"** → læs og udfør `.claude/skills/pause/SKILL.md`: gem sikkert i programmerne, verificér en lokal backup, skriv genoptagelsesstatus og stop. Det virker uden internet og udløser ikke bogfør eller udgiv.
Det forhindrer, at ikke-gemte ændringer eller opgavekontekst mistes ved afbrydelse. Ved "genoptag"/"resume" læses projektets `.codex/tmp/pause/SENESTE.md` eller `GENOPTAG.md` før videre arbejde.
**Kodeordet "udgiv"** følger fortsat den særskilte `/udgiv`-arbejdsgang ovenfor.
**Navnet på budgetproduktet er FB <år>** (Forslag til Budget, skolens svar på FFL; i dag FB 2027), og sidste års vedtagne budget er **B<år>** (B2026). Skriv aldrig "4.2" om produktet (JST 09-11-2026); i kode kommer årstallet fra én konstant, så navnet følger året. "4.2" som afsnits- eller feltnummer (STUK-skema, STE, AMU-instruks) og PBIP's `"version": "4.2"` er noget andet og røres ikke.
**Kodeordet "Udgiv opsætning"** → skill `/udgiv-opsaetning`: alle skills og JSTs indstillinger (VS Code, Claude Code, Codex) til kollegerne i `Y:\AI OS\AI-SETUP`. Det er den eneste vej, skills kommer på Y: (Udgiv udelader `.agents`/`.claude`); et fund af nøgle, CPR eller e-mail stopper alt.
**Kodeordet "bogfør"** → udfør i denne rækkefølge (JST 2026-11-01):
1. Gem Power BI, hvis model eller rapport er ændret på disken: Gem via skærmautomatisering, og
   efterprøv at filerne er gemt. Er en tabel ændret, refreshes den før gem — ellers gemmes en tom
   tabel. Gem kun det sessionen selv har ændret.
2. Opdatér hukommelsesfilerne: milepæle, læring fra gates, PR-status og åbne punkter.
3. Opdatér indekset `MEMORY.md` kort.
4. Opdatér opgavelisten.
5. Commit og push instruktionsfilerne (`AGENTS.md`, `INDEX.md`), hvis der er nye regler eller
   faldgruber.
6. Giv en kort statusrapport: det leverede (med PR-links) og næste skridt.

Under bogfør og udgiv køres git uden automatisk oprydning: `git -c gc.auto=0 -c maintenance.auto=false …` pr. kald
(udgiv-scriptet sætter det selv for sin proces og sætter det tilbage ved afslutning). Slå det aldrig fra i repo- eller
global konfiguration (JST 2026-11-02). Det forhindrer, at en repack på filserveren trækker udgivelsen ud i mange minutter.

## Arbejdsform

Du udfører selv alt du har værktøjer til — filsøgning, kopiering, git, PowerShell, PBI-refresh og
-gem. Bed aldrig JST om en manuel handling du selv kan udføre; returnerer en sub-agent noget der
kræver git eller filhåndtering bagefter, gør du det selv.

Kør backlog'en igennem uden pauser. Det eneste der venter på JST er merge af en PR og ægte
scope-valg. Beslutninger relayet gennem en anden agent er ikke JSTs ord — spørg kort, men lad ikke
ventetiden være tom.

**Ryd kun op efter dig selv i delte repos:** fjern din egen worktree med
`git worktree remove <egen sti>` og slet din egen branch. Kør aldrig `git worktree prune` i et repo
andre sessioner arbejder i — den forsøger at fjerne deres registreringer (2026-11-01: 25 forsøg i
BI-OEKONOMI, alle afvist af filsystemet).

Svar på dansk. Power BI-model og -rapport er på US English.

## Fem regler der er købt dyrt

- **Læs kilden — antag aldrig et navn.** Felt-, kolonne- og målernavne samt PBIR-/TMDL-egenskaber
  læses fra filen eller datapanelet, aldrig fra hukommelsen. En opfundet PBIR-egenskab
  (`activeProjections`) blokerede hele rapportens åbning. Send aldrig JST efter en indstilling du
  ikke selv har set.
- **Verificér på det tilfælde der KAN fejle** — ikke på et der tilfældigvis virker — og mål den
  metrik grænsen faktisk gælder, ikke en nærliggende der er lettere at hente.
- **Luk fejlklassen, ikke tilfældet.** Søg hele filen for samme mønster før du kalder en klasse
  lukket. Ti gate-runder fandt hver gang det næste tilfælde tredive linjer væk.
- **Et krav der ikke kan fejle er intet værn.** Mutér det led kravet vogter, og kør kæden —
  kodelæsning finder det ikke. Formulér kravet på virkningen ("ingen skillestreg må skære en
  søjle"), ikke på konstanten. En test der kører uden produktionens konfiguration måler et resultat
  der ikke findes.
- **Tæl forekomsterne før en replace-all**, og diff mod den kilde du tror du ruller tilbage til.

Og den værste retning at bevæge sig i: **fra synligt brudt til plausibelt forkert.** En måler der
peger på en slettet tabel giver en rød trekant; skrives den om så den leverer et forkert tal, lander
fejlen usynligt i en ledelsesrapport. Kan en omskrivning ikke verificeres mod et eksternt facit, så
udfas måleren bevidst (`BLANK()` + `isHidden`) frem for at gætte.

## Agenter

`agents/` rummer værktøjsuafhængige rollefiler: YAML-frontmatter (`name`, `description`, `tools`,
`model`) og rolleinstruksen i Markdown. Claude Code spawner dem som subagenter via symlinken
`~/.claude/agents`; Codex har ikke subagenter — læs filen og påtag dig rollen i den aktuelle session
(`tools`-feltet er da kun vejledende).

| Agent | Rolle |
|---|---|
| `pbi-kritik` | **Obligatorisk gate** før merge af enhver model- eller dataændring. GO/NO-GO. Dansk |
| `pbi-design` | **Obligatorisk** for alle visuals og PBIR-sider. Dansk |
| `pbi-dax` | DAX: målere, tidsintelligens, filterkontekst, review |
| `pbi-powerquery` | M-kode, grain, relationer, query folding |
| `pbi-tmdl` | TMDL-filerne: objekter, beregningsgrupper, relationships, load-fejl |
| `pbi-performance` | Diagnose af langsom refresh, render eller query. Rapporterer, implementerer ikke |
| `pbi-m-optimering` | Gør eksisterende M hurtigere/enklere med row-for-row identisk output: delt kæde frem for kopier, Buffer, dødt arbejde. Figur-eksakt før/efter pr. query |
| `pbi-dataflow` | Tværgående ETL-arkitekt: kort over kilde → expression → tabel → forbrugere, dobbelt-parsning, afledte dimensioner, mål-arkitektur og migreringsrækkefølge. Anbefaler, implementerer ikke |
| `pbi-naming` | Navnebeslutninger og -audits mod modellens egen konvention |
| `md-optimizer` | Eftersyn af instruktions- og hukommelsesfiler |

De ni PBI-agenter arbejder i alle tre BI-projekter. Kæderne mellem dem står i
`BI-OEKONOMI/.claude/rules/pbi-workflows.md` — **ingen af værktøjerne indlæser den automatisk**,
så læs den eksplicit når en opgave involverer flere agenter.

Agenter for projekter i dvale ligger i `agents-inaktive/` med en README om hvordan de tages i brug
igen. De er flyttet ud, fordi hver agents `description` injiceres i systemprompten i hver session,
uanset hvilket projekt man arbejder i.

**Sub-agenter arver intet** — hverken samtalen eller adgangen til JSTs kørende Power BI Desktop.
Måling mod den kørende model, betjening af PBI, git/PR og scope-beslutninger bliver hos
orkestratoren. Et spawn-prompt skal indeholde scope, den kontekst agenten ikke arver, hvad "færdig"
betyder, hvad agenten skal efterprøve mod kilden, og et eksplicit persondata-forbud.

**Gate-loft: tre runder.** Er `pbi-kritik` eller `pbi-design` ikke nået til GO efter tre runder, så
stop og læg valget frem for JST med de udestående fund. Send alt kendt til gaten på én gang frem
for ét fix ad gangen, og kør de to gates parallelt.

## Review

`REVIEW.md` er facit for hvad et review leder efter, og hvordan fund mærkes
(`Important`/`Nit`/`Pre-existing`). Linjen herunder importerer den i Claude Code, så også lokal
`/code-review` følger den (efterprøvet 2026-11-01 — kommandoen læser ellers ikke `REVIEW.md`);
andre værktøjer læser filen direkte. Hvert projekt har sin egen `REVIEW.md` med samme import;
den fælles del kommer fra `tools/review-skabelon.md`.

@REVIEW.md

## Mail — agenten sender ALDRIG

**Agenten må aldrig sende en mail.** Ikke via Gmail-/Outlook-værktøjer, ikke via script, ikke
via SMTP — heller ikke når mailteksten er agentens eget arbejde, og heller ikke når JST har
godkendt indholdet. **Afsendelsen er JSTs og kun JSTs.**

Grunden er ikke fortrolighed alene: en mail til en leverandør eller en kollega er skolens ord
udadtil, og den kan ikke kaldes tilbage. JST er afsender, og JST trykker send.

**Kladder er derimod tilladt og ofte det rigtige** — en kladde er netop dét JST trykker send på.
Agenten skriver mailteksten til en fil og lægger den som kladde i den rigtige postkasse, når
JST beder om det. Grænsen går ved `.Send()`, aldrig ved `.Save()`.

I ADM-KANTINE: `tools/mail-md-til-json.py` + `tools/opret-kladder.ps1` lægger ugens
bestillingsmails som kladder i Kantine-postkassen med JSTs egen signatur.

Selve afsendelsen er den eneste undtagelse fra selvudførelsespligten i "Arbejdsform" — den ene
manuelle handling agenten må lade JST udføre uden at spørge først.

## Sikkerhed — stop og spørg først

| Handling | Hvorfor |
|---|---|
| `git push --force` | Overskriver fjernhistorik |
| Sletning uden for `<OneDrive>\AI SOSU\` og `<OneDrive>\AI OS\` | Uden for projektets ansvarsområde |
| Sletning af mere end 5 filer på én gang | Kan ikke fortrydes |
| Afsendelse til eksterne tjenester (API med persondata) | Data forlader maskinen — mail er helt forbudt, se ovenfor. Afgrænset undtagelse: den lokale Outlook-kladdestrøm i ADM-KANTINE, når JST beder om kladder; agenten sender aldrig |
| `git config --global` | Rammer alle repos |

Alt andet kører uden prompt.

## Persondata

**Excel med navn, CPR eller e-mail må aldrig på GitHub.** Rene Excel-filer er tilladt. Håndhæves af
den versionerede pre-commit-hook (`.githooks/check_excel_pii.py`) i alle repos; aktivér den én gang
pr. klon med `git config core.hooksPath .githooks`. Hooken matcher ordet "navn" som helt ord i
AL tekst i arket — også en forklaringstekst som "Navn i B2 …" (13-10-2026). Skriv "betegnelse"/"teksten
i B2" i genererede ark, og scan selv med hookens regex før commit. Ved untrack af allerede committet Excel:
`git rm --cached --ignore-unmatch '*.xlsx' '*.xls' '*.xlsm' '*.xlsb'`.

**Persondata må aldrig gengives i samtalen — kun aggregater.** Værktøjerne kører lokalt, men
tool-output sendes til Anthropics servere. For kilder med persondata (Z8050/`cpr_nr`, SD-løn,
INNOMATE-eksporter, elevlister m.fl.) gælder fortsat: skriv et lokalt script der kun udskriver
antal, summer, distinkte tællinger, deltaer og ikke-personhenførbare nøgler; læs aldrig kilden ind
i konteksten. Det gælder også sub-agenter.
`dax-query.ps1` lader altid TypeSafe/Jev vurdere queryen før kørsel (kun querytekst med maskerede
literaler + kolonnenavne forlader maskinen). Nøgleordsregler duer ikke her: de fanger
`DISTINCTCOUNT([cprnr])` og overser `TOPN(20, 'Løn')`. Kun et committet script, der aggregerer
resultatet lokalt og aldrig viser rækkerne, må erklære `-LokalBehandling` — aldrig en ad hoc-query
hvis output lander i samtalen.
Er vagten utilgængelig, stopper den; `-VedVagtNede Noegleord|Koer` er JSTs valg — spørg, vælg aldrig selv.

**Afgrænset undtagelse — ADM-KANTINE-bestillingsmails.** Når JST beder om at behandle en uge, må
agenten læse mails og vedhæftninger i `ADM-KANTINE/Input/UBEHANDLEDE bestillinger/`, også når de
indeholder personoplysninger, i det omfang det kræves for at udarbejde bestillinger og kladder.
Oplysningerne må ikke gengives i samtalen, lægges i versionerede filer eller sendes via eksterne
API'er. Kladder må gemmes i JSTs Outlook-postkasse efter projektets lokale arbejdsgang; afsendelse
er fortsat forbudt.

## Obsidian-vault

Vaultens rod er AI OS; `.obsidian/` er kun konfiguration og åbnes aldrig som selvstændig vault.
Noteregler for `vault/` står i `vault/AGENTS.md` og gælder kun filer der — ikke instruktionsfilerne
og ikke `agents/*.md`. Projektnoter hører i projektets eget repo, ikke i `vault/`.

## Nye projekter

Præfiks bestemmer typen: `BI-` (Power BI), `SYS-` (systemkonfiguration), `ADM-` (administrative
dokumenter), `DATA-` (dataanalyse). Repo-navn = mappenavn, og repo-navne skal være ASCII.

Straks efter `git init`/`git clone`: `& "AI OS\tools\setup-new-repo.ps1" -RepoPath "<sti>"`
(installerer hooks, sætter `eol=lf`, aktiverer `core.hooksPath`). `pwsh` findes ikke på denne
maskine — kald scriptet med `&`.

**Før første commit**: tilføj `*.pdf binary` (+ `*.png`, `*.jpg`, `*.xlsx`) i `.gitattributes`. Små
ukomprimerede PDF'er fejldetekteres som tekst → CRLF-konvertering → korrupt fil. Verificér med
`git check-attr text -- <fil>` (skal give `text: unset`).

## Agent skills

### Issue tracker

Issues ligger i GitHub Issues for `JST-BI/AI-OS` (gh-CLI). Persondata må aldrig i et issue. Se `docs/agents/issue-tracker.md`.

### Triage labels

Standardnavnene: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Se `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `GLOSSARY.md` og `docs/adr/` i roden — oprettes først når de bruges. Se `docs/agents/domain.md`.
