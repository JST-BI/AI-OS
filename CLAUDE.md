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
| `BI-OEKONOMI` | Power BI: HR/økonomi-rapporten og den semantiske model (HR_OEKONOMI) |
| `BI-OPTAG FRAVÆR` | Power BI: elevoptag og skoleforløbsfravær (Studie+ Z8312 + Z8224S) |
| `BI-OPGAVEOVERSIGT` | Power BI: opgaveoversigt mod arbejdstidsnorm |
| `DATA-BUDGET_PROGNOSE` | Finansiel analyse, budget og prognose (Navision + BRUGER-budget → .xlsx) |
| `SYS-INNOMATE` | Mailskabeloner og procesplaner for on-/offboarding |
| `ADM-HÅNDBØGER` | Personalehåndbog og Lederhåndbog |
| `ADM-ØKONOMI` | Regnskabsinstruks, Indkøbspolitik, Strategi for finansiel risiko |
| `ADM-BI` | BI governance: datastandarder, navnekonventioner, roller, BI-strategi |
| `ADM-KANTINE` | Kantinens ugemenu og prisskilte (`Input/` committes her — PDF'erne er kilden) |
| `ADM-AFTALER` | Samarbejds- og samhandelsaftaler |
| `ADM-BLANKET` | Blanketter og formularer |

Hvert projekt har sin egen `CLAUDE.md` med projektets regler — den er facit for arbejde der.
Er opgaven ikke dækket af en række herover, så spørg hvilket projekt den hører til frem for at
gætte.

`ADM-MØDER/`, `ADM-REVISION/` og `BI-SOSU/` er **ikke** projekter (løse filer / tom / ugyldig
`.git`). Bliver en af dem til et rigtigt projekt: kør `tools/setup-new-repo.ps1` og tilføj rækken
her.

`ADM-AFTALER`, `ADM-BLANKET` og `BI-OPTAG FRAVÆR` har lokale repos **uden remote** — fortrolighed
er ikke afklaret. Læg dem ikke på GitHub uden JSTs ord. De to første har `Input/` i `.gitignore`,
fordi materialet er personhenførbart.

## Placering — én arbejdskopi, delte kopier på Y:

Alt arbejde foregår i OneDrive. `Y:\AI OS` og `Y:\AI SOSU` er **kollegernes delte kopier** — ikke
arbejdsmapper. Skriv aldrig direkte i dem: git og PBI Desktop over VPN'en er 6–14× langsommere, og
filserveren afviser junctions/symlinks. Findes der arbejde der KUN er på Y: (nyere commits eller
ucommitterede ændringer): stop og rapportér frem for at overskrive.

Kollegerne har ingen adgang til JSTs OneDrive. Intet de kører må forudsætte en OneDrive-sti —
M-koden bruger lokalt spejl med fallback til Y:, og `DATAKONTROLCENTER` + udtrækkene på Y: er
deres datagrundlag og røres aldrig af agenten.

**Kodeordet "Udgiv"** → skill `/udgiv` (`tools/udgiv-til-y.ps1`). Forudsætter at alt er merget til
`main` og pushet — Udgiv henter fra GitHub, ikke fra OneDrive-klonerne.

Kør robocopy- og git-scripts fra PowerShell, ikke fra Bash: stier konverteres forkert.
`Y:` er en pr.-logon-mapping der kan falde ud midt i en session; `Test-Path` på UNC-stien vækker
den.

## Instruktionsfiler — spejl og vedligehold

`CLAUDE.md` (Claude Code) og `AGENTS.md` (Codex) skal være **byte-identiske** i hver mappe hvor de
findes. Redigér altid `CLAUDE.md` og spejl med `& "AI OS\tools\sync-agents-md.ps1"`.
Pre-commit-hooken `.githooks/check_md_mirror.py` blokerer drift — ret spejlet frem for at bruge
`--no-verify`; et brudt spejl betyder at de to værktøjer arbejder efter hver sin udgave af reglerne.

Codex finder `AGENTS.md` ved at gå opad mod nærmeste `.git` — aldrig på tværs. En regel der skal
gælde i et projekt, skal stå i det projekts egen fil.

Når du retter en fejl eller lærer noget der ændrer fremtidige beslutninger: skriv det ind i den
relevante `CLAUDE.md`, spejl, opdatér `INDEX.md` hvis filer er kommet til eller forsvundet, og
commit. Instruktionsfiler må committes direkte til `main`.

**Skriv reglen, ikke historien.** Én linje med hvad man skal gøre, og én med den konkrete fejl den
forhindrer. Undersøgelsesforløb og PR-narrativ hører i hukommelsen eller i en arbejdsnote — ikke i
en fil der indlæses ved hver eneste session. Vokser et afsnit ud over ~20 linjer, hører detaljen i
en separat fil som `CLAUDE.md` henviser til.

Opsætning af Codex på en ny maskine: `tools/codex-opsaetning.md`.

## Arbejdsform

Du udfører selv alt du har værktøjer til — filsøgning, kopiering, git, PowerShell, PBI-refresh og
-gem. Bed aldrig JST om en manuel handling du selv kan udføre; returnerer en sub-agent noget der
kræver git eller filhåndtering bagefter, gør du det selv.

Kør backlog'en igennem uden pauser. Det eneste der venter på JST er merge af en PR og ægte
scope-valg. Beslutninger relayet gennem en anden agent er ikke JSTs ord — spørg kort, men lad ikke
ventetiden være tom.

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
| `pbi-naming` | Navnebeslutninger og -audits mod modellens egen konvention |
| `md-optimizer` | Eftersyn af instruktions- og hukommelsesfiler |

De syv PBI-agenter arbejder i alle tre BI-projekter. Kæderne mellem dem står i
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

## Sikkerhed — stop og spørg først

| Handling | Hvorfor |
|---|---|
| `git push --force` | Overskriver fjernhistorik |
| Sletning uden for `<OneDrive>\AI SOSU\` og `<OneDrive>\AI OS\` | Uden for projektets ansvarsområde |
| Sletning af mere end 5 filer på én gang | Kan ikke fortrydes |
| Afsendelse til eksterne tjenester (mail, API med persondata) | Data forlader maskinen |
| `git config --global` | Rammer alle repos |

Alt andet kører uden prompt.

## Persondata

**Excel med navn, CPR eller e-mail må aldrig på GitHub.** Rene Excel-filer er tilladt. Håndhæves af
den versionerede pre-commit-hook (`.githooks/check_excel_pii.py`) i alle repos; aktivér den én gang
pr. klon med `git config core.hooksPath .githooks`. Ved untrack af allerede committet Excel:
`git rm --cached --ignore-unmatch '*.xlsx' '*.xls' '*.xlsm' '*.xlsb'`.

**Persondata må aldrig returneres til samtalen — kun aggregater.** Værktøjerne kører lokalt, men
tool-output sendes til Anthropics servere. Ved enhver kilde med persondata (Z8050/`cpr_nr`, SD-løn,
INNOMATE-eksporter, elevlister): skriv et lokalt script der kun udskriver antal, summer, distinkte
tællinger, deltaer og ikke-personhenførbare nøgler. Læs aldrig en persondata-fil direkte ind i
konteksten. **Det gælder også sub-agenter du spawner** — en gate-agent med PowerShell-adgang kan
selv læse kilden og lække en værdi (skete 2026-06-16). Forbyd rå persondata-læsning eksplicit i
agentens prompt, og giv den hellere de færdigberegnede tal.

## Obsidian-vault

Vaultens rod er AI OS; `.obsidian/` er kun konfiguration og åbnes aldrig som selvstændig vault.
Noteregler for `vault/` står i `vault/CLAUDE.md` og gælder kun filer der — ikke instruktionsfilerne
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
