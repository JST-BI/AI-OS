# AI OS (SOSU Randers) — agentregler (Claude Code + Codex)

> **Spejlprincip — Claude Code + Codex**: `CLAUDE.md` (læses af Claude Code) og `AGENTS.md` (læses af Codex) er identiske spejle af samme indhold. Redigér ALTID `CLAUDE.md` først, og kopiér derefter 1:1 til `AGENTS.md`: `Copy-Item CLAUDE.md AGENTS.md`. "Agenten" i teksten betyder den aktive AI-agent, uanset værktøj; funktioner der kun findes i ét værktøj er markeret "(kun Claude Code)" / "(kun Codex)".
>
> **Filindeks**: `INDEX.md` (her i AI OS rod) er det samlede indeks over alle styrede filer på tværs af alle 8 repos. Holdes opdateret ved enhver fil-tilføjelse/-fjernelse/-omdøbning.

## Session-startkontrol — kør ved FØRSTE prompt i hver session

Før du besvarer noget som helst, verificér følgende. Rapportér kun hvis noget **fejler**:

```
[ ] CLAUDE.md + AGENTS.md findes i AI OS rod og er identiske spejle (denne fil)
[ ] CLAUDE.md + AGENTS.md findes og er identiske spejle i hvert af de 8 projekt-repos:
    AI-SOSU/BI-OEKONOMI/, AI-SOSU/SYS-INNOMATE/, AI-SOSU/ADM-HÅNDBØGER/,
    AI-SOSU/ADM-ØKONOMI/, AI-SOSU/DATA-BUDGET_PROGNOSE/, AI-SOSU/ADM-BI/,
    AI-SOSU/ADM-KANTINE/, AI-SOSU/BI-OPGAVEOVERSIGT/
[ ] INDEX.md findes i AI OS rod
[ ] agents/ indeholder: pbi-dax, pbi-powerquery, pbi-tmdl, pbi-performance, pbi-naming, pbi-kritik, pbi-design, inno-hr, inno-system, inno-logistics, inno-mailtemplate, md-optimizer, fin-analysis, fin-patterns, fin-statistics, fin-accounting, fin-data, fin-database, adm-bi
[ ] AI OS rod indeholder KUN: agents/, tools/, .githooks/, .claude/, .agents/, .Codex/, CLAUDE.md, AGENTS.md, INDEX.md, .gitattributes, .gitignore — ingen projektmapper
[ ] SYS-INNOMATE rod indeholder KUN: Input/, Output/, _Arkiv/, .githooks/, .claude/, .Codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore (+ procesplan-generator: node_modules/, package.json, package-lock.json, generate-procesplan-v3.js)
[ ] BI-OEKONOMI rod indeholder: Input/, Output/, Rapporter/, tools/, _Arkiv/, .githooks/, .claude/, .Codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore
[ ] AI-SOSU/ADM-HÅNDBØGER rod indeholder: Personalehåndbog/, Lederhåndbog/, Input/, Output/, _Arkiv/, .githooks/, .claude/, .Codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore
[ ] AI-SOSU/ADM-ØKONOMI rod indeholder: Regnskabsinstruks/, Indkøbspolitik/, Strategi for finansiel risiko/, Input/, Output/, _Arkiv/, .githooks/, .claude/, .Codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore
[ ] AI-SOSU/ADM-BI rod indeholder: Input/, Output/, _Arkiv/, .githooks/, .claude/, .Codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore
[ ] AI-SOSU/DATA-BUDGET_PROGNOSE rod indeholder: Input/, Output/, _Arkiv/, .githooks/, .claude/, .Codex/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore
[ ] AI-SOSU/ADM-KANTINE rod indeholder: Input/, Output/, tools/, .githooks/, CLAUDE.md, AGENTS.md, .gitattributes, .gitignore
```

Hvis én eller flere tjek fejler: **stop, rapportér præcist hvad der mangler, og afvent instruktion.**

---

## Selvvedligehold — obligatorisk

Når du:
- **finder og retter en fejl** (konfiguration, routing, agent-opsætning, Git-quirks)
- **opdager ny viden** om projekter, agenter, arbejdsgange eller systemadfærd
- **gennemfører en ændring** der påvirker fremtidige beslutninger

…skal du **straks**:
1. Opdatere det relevante afsnit i denne CLAUDE.md
2. Spejle til AGENTS.md: `Copy-Item CLAUDE.md AGENTS.md`
3. Opdatere `INDEX.md` hvis filer er tilføjet, fjernet eller omdøbt
4. Committe ændringen: `git add CLAUDE.md AGENTS.md INDEX.md && git commit -m "Opdatér CLAUDE.md/AGENTS.md: <hvad og hvorfor>"`

Dette gælder også de projektspecifikke `CLAUDE.md`/`AGENTS.md`-par i alle projekter under `AI-SOSU/`. Instruktionsfil-opdateringer (CLAUDE.md, AGENTS.md, INDEX.md) må committes direkte til `main` — det er den etablerede undtagelse fra projekternes PR-regel.

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

---

## Hvad er AI OS?

AI OS er infrastrukturniveauet for alt AI-assisteret arbejde ved SOSU Randers. Her bor agentdefinitioner og AI-konfiguration (Claude Code: `.claude/`, Codex: `.Codex/`). Det er **ikke** et arbejdsprojekt — det er værkstedet.

Arbejdsprojekterne ligger i `AI-SOSU/` (samme OneDrive-rod):

| Projekt | Sti | Indhold |
|---|---|---|
| `BI-OEKONOMI` | `../AI-SOSU/BI-OEKONOMI/` | Power BI-rapport og semantisk model for HR/økonomi |
| `SYS-INNOMATE` | `../AI-SOSU/SYS-INNOMATE/` | Mailskabeloner og procesplaner for onboarding/offboarding via INNOMATE |
| `ADM-HÅNDBØGER` | `../AI-SOSU/ADM-HÅNDBØGER/` | Personalehåndbog og Lederhåndbog — afspejler hinandens emner |
| `ADM-ØKONOMI` | `../AI-SOSU/ADM-ØKONOMI/` | Regnskabsinstruks, Indkøbspolitik og Strategi for finansiel risiko |
| `DATA-BUDGET_PROGNOSE` | `../AI-SOSU/DATA-BUDGET_PROGNOSE/` | Finansiel analyse, budget og prognose — Navision finansposter + BRUGER-budget/prognose → .xlsx-output |
| `ADM-BI` | `../AI-SOSU/ADM-BI/` | BI governance og styringsdokumenter — datastandarder, navnekonventioner, roller og BI-strategi |
| `ADM-KANTINE` | `../AI-SOSU/ADM-KANTINE/` | Kantinens menukort og prisskilte — tilrettede udgaver af leverandørens ugemenu |
| `BI-OPGAVEOVERSIGT` | `../AI-SOSU/BI-OPGAVEOVERSIGT/` | Power BI-rapport: medarbejderes opgaveoversigt mod arbejdstidsnorm (Budgetskema.xlsx på SharePoint) |

**Note om `ADM-KANTINE`** (oprettet 2026-07-28): repo [JST-BI/ADM-KANTINE](https://github.com/JST-BI/ADM-KANTINE) (privat). Ingen dedikeret agent — arbejd direkte. I modsætning til de øvrige projekter **committes `Input/` her**: leverandørens PDF'er er små og persondatafri, og de dokumenterer hvad et givet ugekort er bygget på.

---

## Hvornår arbejder du her vs. i et projekt?

| Situation | Arbejd i |
|---|---|
| Oprette eller redigere en agent | AI OS (`agents/`) |
| Ændre Claude Code-/Codex-indstillinger | AI OS (`.claude/` / `.Codex/`) |
| Bygge DAX, M-kode eller Power BI-rapporter | `AI-SOSU/BI-OEKONOMI/` |
| Skrive procesplaner eller mailskabeloner | `AI-SOSU/SYS-INNOMATE/` |
| Redigere Personalehåndbog eller Lederhåndbog | `ADM-HÅNDBØGER/` |
| Redigere Regnskabsinstruks, Indkøbspolitik eller finansiel risiko | `ADM-ØKONOMI/` |
| BI governance, datastandarder, navnekonventioner eller BI-strategi | `ADM-BI/` |
| Kantinens menukort, ugemenu eller prisskilt | `ADM-KANTINE/` |
| Finansiel analyse, budget, prognose (Navision-data) | `AI-SOSU/DATA-BUDGET_PROGNOSE/` |
| Noget der spænder over flere projekter | Start her, koordinér |

---

## Tilgængelige agenter

Agentfilerne ligger i `agents/`. Claude Code læser dem via symlink `~/.claude/agents/`; i Codex bruges samme filer som rolleinstrukser direkte fra repoet.

### Power BI-agenter (output på US English)

| Agent | Rolle |
|---|---|
| `pbi-dax` | DAX measures, KPIs, tidsintelligens, filterkontext |
| `pbi-powerquery` | M-kode, query folding, relationer, stjerneskema |
| `pbi-tmdl` | TMDL-syntaks, beregningsgrupper, model-metadata |
| `pbi-performance` | VertiPaq, storage modes, refresh-optimering |
| `pbi-naming` | Navngivningskonventioner, display folders, audits |
| `pbi-kritik` | Kritisk gate FØR merge — grain, dobbelttælling, fortegn, måling-før-merge; afgiver GO/NO-GO-dom (svar på dansk) |
| `pbi-design` | OBLIGATORISK design-standard for alle visuals/PBIR-sider — cards uden rå målernavne, ingen trunkering/scrollbars, semantisk stak-farverækkefølge (grøn→gul→rød→sort→grå), dynamiske slicer-defaults, visuel verifikation før merge (svar på dansk; JST-krav 2026-07-17) |

### INNOMATE-agenter (output på dansk)

| Agent | Rolle |
|---|---|
| `inno-hr` | Medarbejderlivscyklus, ansættelses- og fratrædelsesprocesser |
| `inno-system` | INNOMATE-systemopsætning, handlinger, onboarding-konfiguration |
| `inno-logistics` | Procesplaner, tjeklister, rollebeskrivelser, arbejdsgangsoverblik |
| `inno-mailtemplate` | Mailskabeloner i INNOMATE, merge-felter, CPR-regler |

### DATA-BUDGET_PROGNOSE-agenter (output: .xlsx med danske formater; svar til bruger: dansk)

| Agent | Rolle |
|---|---|
| `fin-analysis` | Finansiel analyse — afvigelser, periodisering, budget vs. realiseret, cashflow |
| `fin-patterns` | Mønstergenkendelse — anomalier, sæsonudsving, strukturelle brud, outliers |
| `fin-statistics` | Statistisk ekspert — prognoser, regressioner, konfidensintervaller, tidsseriedekomposition |
| `fin-accounting` | Regnskabsekspert — kontoplan, dimensioner, bogføringsregler, SOSU-specifik regnskabspraksis |
| `fin-data` | Dataanalyse — datakvalitet, krydskildesammenstilling, oprensning, aggregering |
| `fin-database` | Databasestruktur — skemadesign, nøgler, relationer, kanoniske kolonnenavne |

### Generel infrastruktur-agent

| Agent | Rolle |
|---|---|
| `md-optimizer` | Optimering og vedligehold af alle `.md`-filer — særligt CLAUDE.md/AGENTS.md-hukommelsesfiler. Persisterer ny viden, fejlmønstre og workflowændringer. Bruges proaktivt efter sessioner med fejlrettelser eller arkitekturændringer. |

### ADM-BI-agent (output på dansk)

| Agent | Rolle |
|---|---|
| `adm-bi` | BI governance og styringsdokumenter — strategi, datastandarder, navnekonventioner, roller og ansvar |

---

## Tilgængelige skills/plugins

Installerede slash-kommandoer (kun Claude Code — Codex har ikke disse kommandoer):

| Kommando | Hvad den gør |
|---|---|
| `/revise-claude-md` | Opdatér CLAUDE.md med læringer fra den aktuelle session |
| `/claude-md-improver` | Audit og forbedringsforslag til alle CLAUDE.md-filer |
| `/code-review` | Code review af aktuel diff eller specificeret PR |

Kald dem ved at skrive kommandoen i chatten.

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
                          NEJ → Afklar med brugeren hvilket projekt opgaven tilhører.
```

---

## Sikkerhedsregler — handlinger der ALTID kræver bekræftelse

Uanset hvad tilladelsesindstillingerne tillader automatisk, skal agenten **altid stoppe og spørge** før:

| Handling | Eksempel |
|---|---|
| `git push --force` | Overskriver fjernhistorik |
| Sletning af filer/mapper uden for projektmapperne | `rm` på stier uden for `AI-SOSU/` eller `AI OS/` |
| Masseoperationer der ikke kan fortrydes | Slette >5 filer på én gang |
| Afsendelse til eksterne tjenester | E-mail, API-kald med persondata |
| Ændring af Git-konfiguration globalt | `git config --global` |

Alt andet kører uden prompt.

---

## Regler for denne mappe

- **Kun AI-infrastruktur hører hjemme her.** Projektindhold (budgetter, skabeloner, rapporter) hører i `AI-SOSU/`.
- Nye agenter oprettes som `.md`-filer i `agents/` med korrekt frontmatter (`name`, `description`, `tools`, `model`).
- `INDEX.md` er det samlede filindeks over alle styrede filer i alle 8 repos — opdatér det når filer tilføjes, fjernes eller omdøbes.
- Ændringer commites og pushes til GitHub: `https://github.com/JST-BI/AI-OS`

---

## Navnekonvention — nye projekter

Præfiks bestemmer projekttype. GitHub-repo og lokal mappe hedder det samme:

| Præfiks | Projekttype | GitHub-repo | Lokal mappe |
|---|---|---|---|
| `BI-` | Power BI-rapporter og datamodeller | `JST-BI/BI-<EMNE>` | `AI-SOSU\BI-<EMNE>` |
| `SYS-` | Systemkonfiguration og procesautomatisering (fx INNOMATE) | `JST-BI/SYS-<EMNE>` | `AI-SOSU\SYS-<EMNE>` |
| `ADM-` | Administrative dokumenter (håndbøger, politikker) | `JST-BI/ADM-<EMNE>` | `AI-SOSU\ADM-<EMNE>` |

**Bemærk**: Alle projekter samles under `AI-SOSU\`. GitHub-repo-navne skal være ASCII (undgå æ, ø, å).

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

## PowerShell gotchas — TMDL-filer

**ALDRIG `Get-Content` til TMDL-filer** (PS 5.1). Læser UTF-8 som CP1252 → `Ø` → `Ã˜` → double-encoded mojibake → PBI Desktop fejler med `"Property QueryGroup ... refers to an object which cannot be found"`.

Korrekt mønster:
```powershell
$utf8 = [System.Text.UTF8Encoding]::new($false)
$lines = [System.IO.File]::ReadAllLines($path, $utf8)
# ... modificer $lines ...
[System.IO.File]::WriteAllLines($path, $lines, $utf8)
```

## TMDL-syntaks — gotchas

**OBLIGATORISK før du beder om (eller selv laver) en PBI-åbning efter TMDL-edits**: kør
`powershell -File "AI OS\tools\validate-tmdl.ps1" -DefinitionPath "<model>.SemanticModel\definition"`.
Værktøjet kører filerne gennem SAMME TOM-deserializer som PBI Desktop og svarer på ~5 sekunder
i stedet for en 60-sekunders åbning der ender i "Issues were found". `GRØN` = strukturen holder
(`GRØN` gives også når parsingen standser til sidst på kompatibilitetsniveau — biblioteket kender
ikke DAX UDF'er, og på det tidspunkt er ALT parset). `RØD` udskriver fejlen + hvilket TMDL-dokument
den står i. Fanger ukendte properties, forkert indrykning og dublerede properties.

- **`///`-docstring på en RELATION brækker modellen**: `Property 'description' is unknown and is not
  expected in the situation it appears`. Relationer har ingen beskrivelses-egenskab — læg forklaringen
  i CLAUDE.md eller commit-beskeden i stedet. Samme fejlklasse rammer alle objekttyper der ikke
  understøtter description; validatoren ovenfor fanger dem alle (set 2026-07-26).
- **PBI's fejl-dialog har INTET fejltidspunkt**: `Timestamp` i frown-rapporten er tidspunktet hvor
  brugeren klikkede "Copy details to clipboard" — dialogen kan have stået åben i timevis, og fejlen
  kan for længst være rettet. Før du jagter en rapporteret åbningsfejl: sammenhold filens mtime med
  fixet, og tjek PBI-vinduets titel + `IsEnabled` via UIA (`Untitled` + `enabled=False` = instansen
  hænger stadig i den GAMLE modal). Verificér ved at genåbne — ikke ved at læse stack-tracen igen.
- **INGEN `/* ... */`-blokkommentarer på objekt-niveau** (measure/column/table). TMDL er indrykningsfølsomt, og blokkommentarer udløser `TMDL Format Error: Parsing error type - Indentation / Invalid indentation` ved load i PBI Desktop. Brug i stedet `///` (beskrivelse, bliver til objektets tooltip) eller `//` (linjekommentar) ved SAMME indrykning som objektet. `/* */` er KUN gyldigt inde i M-source-blokken (`source = ```...````), fordi det er en fritekst-streng. Set 2026-06-01 i `#Measures - STU.tmdl`.
- **Tabel-scoped refresh uden PBI's UI**: `powershell -File "AI OS\tools\tmsl-refresh.ps1" -Port <port> -Catalog <guid> -Table "<tabel>"` sender en TMSL `refresh` via ADOMD til den kørende instans. Uden `-Table` refreshes hele databasen (undgå — timeouter typisk over VPN). Kør den med `run_in_background`, og poll `COUNTROWS(<tabel>)` — et hængende kald betyder næsten altid en usynlig modal (se næste punkt), ikke en langsom kilde.
- **Hårde `Stop-Process -Force`-drab på PBI kan efterlade cloud-credentials i limbo** (set 2026-07-27). Symptom: TMSL-refresh mod en SharePoint-/cloud-kilde hænger uden fejl, PBI-hovedvinduet har `IsEnabled=False` (usynlig credential-modal — UIA finder ingen knapper under PBI-processen), og et Edge-vindue melder "Authentication Complete". Fejlteksten `AADSTS9002313: Invalid request` er et SPOR, ikke roden. Fix: luk PBI helt og genåbn `.pbip` — refresh virker så uden auth-prompt. Samme familie som `pbi-aabningsfejl-token-comma` (rådden sessionstilstand): **genstart før du fejlsøger**.
- **`.pbip` åbnes via explorer, ikke via exe'en**: `Start-Process "<pbidesktop.exe>"` fejler med `Adgang nægtet` (Store-app under `WindowsApps`). Brug `Start-Process explorer.exe -ArgumentList "`"<sti til .pbip>`""`. Vent på at vinduestitlen skifter fra `Untitled - Power BI Desktop` til projektnavnet før du måler.
- **PBI-gemning overskriver disk-edits**: Har brugeren pbix'en åben i PBI Desktop og gemmer, skrives in-memory-modellen hen over mine TMDL/PBIR-diskændringer → de forsvinder. Redigér kun disk når disk == seneste PBI-gem; bed brugeren **genåbne pbix UDEN at gemme først** for at indlæse mine ændringer.
- **DAX VAR-navne SKAL være ren ASCII** (set 2026-06-02): æøå/Å (og andre ikke-ASCII-tegn) i et `VAR`-navn giver `Invalid token, Line X, Offset Y, <tegn>` ved parsing. Et mål med denne fejl loades som objekt (vises i Data-ruden med rød trekant) men er ugyldigt → PBI dropper det stille fra visual-field-wells OG filterpanel, så en korrekt visual-binding ser blank ud. Brug fx `_AarStart`/`_AarSlut` i stedet for `_ÅrStart`/`_ÅrSlut`. Tabel-/kolonne-/målnavne MÅ gerne have æøå (de står i `'...'`-quotes); det er kun bare VAR-identifikatorer der skal være ASCII.
- **Partition-`queryGroup` SKAL være deklareret i model.tmdl** (set 2026-07-17). En partition med `queryGroup: STU\BUDGET` hvor gruppen ikke findes blandt model.tmdl's `queryGroup`-deklarationer → PBI kan slet ikke åbne projektet: `Cannot resolve all the paths while de-serializing Database. Resolution Errors: Property QueryGroup of object "partition X" refers to an object which cannot be found`. Fix: brug en eksisterende gruppe (fx `STU\DATA`) eller deklarér den nye i model.tmdl. NB: samme fejltekst ("Property QueryGroup ... cannot be found") opstår OGSÅ ved encoding-mojibake i gruppenavnet (se PowerShell-gotcha ovenfor) — tjek begge årsager.
- **CALCULATE-filterargumenter evalueres i den YDRE filterkontekst** (set 2026-07-21): et `FILTER('Fakta', interval-betingelse)`-argument er allerede relations-reduceret (fx af en aktiv dato-relation) FØR modifiers som `CROSSFILTER(...,NONE)`/`REMOVEFILTERS` får virkning — de påvirker kun den indre evaluering. Events-in-progress-målere ("aktive pr. dag") SKAL derfor bruge `FILTER(ALL('Fakta'), start<=d && slut>=d)` (og dokumentere at eksterne fakta-filtre dermed ignoreres).
- **M-råværdien bag en model-STRING-kolonne kan være datetime** (set 2026-07-21): modellens visning ("01-05-2025") siger intet om M-typen — en `(x as nullable text)`-funktion kaster på typecheck og alle celler bliver stille null. Og `Date.FromText(x, [Culture="da-DK"])` fejlede på ALLE rækker i denne PBI-version. Robust interval-dato-parsing: type-agnostisk `(x as any)` — date/datetime returneres direkte (`Date.From`), tekst parses manuelt med `Text.Split(Text.Start(t,10), "-")` → `#date(år, md, dag)`.
- **En dim-tabel der er én-siden i en relation må IKKE unpivoteres** (set 2026-07-27). Lagde tre normvarianter om fra kolonner til rækker (`Normtype`/`Normtimer`) i en dim med relationen `Fakta[Initialer] → Dim[Initialer]` → refresh fejler med `Column 'Initialer' ... contains a duplicate value ... not allowed for columns on the one side of a many-to-one relationship`. TMDL-validatoren fanger det IKKE (den validerer struktur, ikke data). Tjek relationsretningen FØR enhver grain-ændring på en dim; nye varianter tilføjes som kolonner.
- **En dim-tabel der er relations-MÅL må IKKE være en kalkuleret tabel afledt af de samme fact-kolonner den relaterer til** (set 2026-06-20). Lavede en delt forløbs-dim som `calculated` = `DISTINCT(UNION(VALUES(Fact1[col]), VALUES(Fact2[col])))` OG lagde relationer `Fact1[col]→Dim[col]` osv. → PBI fejler ved LOAD (før refresh) med `Relationship '<guid>' uses an invalid column ID <n>`. Årsag: cirkulær/ordnings-afhængighed — en kalk-tabels kolonner materialiseres FØRST ved processering (refresh), men relationer valideres ved load, så kolonnen har intet gyldigt ID at binde til. (En CALENDAR-kalk-tabel virker som relations-mål fordi den ikke afhænger af de facts den relaterer til.) **Fix: kild dim'en fra de RÅ M-queries i stedet** (M/import-tabel: `Table.Combine` af `Table.SelectColumns(#"RawQuery", {"col"})` fra hver kilde → `SelectRows(<>null and <>"")` → `Table.Distinct` → `type text`). En M/import-tabel har statisk kolonne-metadata der binder ved åbning uafhængigt af processering. Single-direction many→one relationer, dim'en skal indeholde UNIONEN af alle facts' værdier (ellers blank-member-rækker).

## PBIR-rapporter — gotchas (visuals)

- **Indbygget visualType-navn**: *Stacked column chart* = `columnChart` (IKKE `stackedColumnChart` → `CustomVisualNotFound`). Stablet liggende = `barChart`. Clustered har egne navne (`clusteredColumnChart`/`clusteredBarChart`); 100% = `hundredPercentStacked...`.
- **Fra-bunden PBIR-JSON-visuals BINDER faktisk** (rettet 2026-06-02): håndskrevet `queryState`-binding på en helt ny side + visual-skal populerer field-wells og renderer fint ved kold genstart af PBI Desktop — INKL. Y/Column-projektioner, ikke kun Category. Den tidligere konklusion ("binder ikke / kræver UI-træk", set 2026-06-01) var **fejldiagnosticeret**: de refererede mål havde en DAX-fejl (se DAX-VAR-ASCII-gotcha nedenfor), og PBI dropper stille et fejlramt mål fra både field-well OG filterpanel → visual'et så blankt ud, selvom JSON'en var korrekt. **Tjek altid at de refererede mål er fejlfri (ingen rød trekant i Data-ruden) FØR du konkluderer at binding ikke virker.** Repointing af eksisterende UI-skabte visuals virker også (skift `Property` + `queryRef` + `nativeQueryRef` i projection, sortDefinition og filterConfig).
- **Hot-reload af PBIR kræver kold genstart**: PBI Desktop genindlæser ikke altid disk-redigeret PBIR ved blot at åbne filen igen — luk HELE PBI Desktop (ikke kun fanen) og genåbn `.pbip` for at se mine disk-ændringer. TMDL-model-ændringer reloader lettere end PBIR-layout.
- `queryRef: "#Measures - ELEV.X"` kan være en STALE kosmetisk label — den bindende reference er `field.Measure.Expression.SourceRef.Entity` + `Property`.
- **Dynamisk slicer-default** ("altid indeværende år"): gemte slicer-valg er statiske — lav en beregnet label-kolonne (fx `IF([År]=YEAR(TODAY()),"Indeværende år",FORMAT([År],"0"))` m. sortByColumn) og gem valget på LABELEN; den følger så med ved refresh.
- **Slicer-header-tekst** kan overstyres (`objects.header.text`) → feltnavnet skjules uden titel-boks (Periode-stil). Et Advanced-målerfilter UDEN filter-body er inaktiv placeholder.
- **sortByColumn må IKKE pege på en DAX-kalk-kolonne afledt af den sorterede kolonne** (set 2026-07-21): `[Status]` sorteret af kalk-kolonnen `SWITCH([Status],...)` → PBI nægter at åbne projektet ("A circular dependency was detected"). 'År (vælger)'-mønsteret er det OMVENDTE (kalk-kolonne sorteret AF basiskolonnen) og lovligt. Løsning: byg sortkolonnen som M-STEP i partitionen (import-kolonne). OG: M-mapningen skal være CASE-INSENSITIV + hårdt normaliseret (`Text.Lower`+`Text.Clean`+NBSP) — Vertipaq-dictionary er case-ufølsom og kollapser rå-varianter til én modelværdi, så to varianter med forskellig sortværdi giver 1:1-brud.
- **SVG-side-baggrunde KRÆVER registrering i report.json** (`resourcePackages → RegisteredResources → items`) — filen i `StaticResources\RegisteredResources` alene er IKKE nok (siden renderer da uden baggrund, stille). Set 2026-07-21: 48 uregistrerede ELEV-SVG'er = alle E-O-/E-A-baggrunde havde været væk længe.
- **Felt-omdøbning i visuals**: `displayName` sættes PR. PROJEKTION (sammen med queryRef/nativeQueryRef) — et `columnProperties`-objekt på `/visual`-niveau AFVISES af PBIR-skemaet ("additional property") og blokerer rapport-åbning (set 2026-07-20).
- **formatString-% ganger SELV med 100**: et u-escapet `%` i formatString multiplicerer værdien (0,951 → "95,1 %"); `\ %` escaper KUN mellemrummet, ikke procenttegnet. Målere skal derfor returnere ANDELE (0-1), aldrig selv gange med 100 (gav "9510 %", set 2026-07-20). Procentpoint-målere uden %-format ganger selv.
- **Stacked PRs (git/GitHub)**: `gh pr merge --squash --delete-branch` på base-PR'en LUKKER den stackede child-PR (GitHub retargeter IKKE når base-branchen slettes). Fix: genskab base-branchen (`git push origin <sha>:refs/heads/<navn>`), `gh api PATCH state=open`, derefter SEPARAT `PATCH base=main` (base kan ikke ændres på lukket PR; `gh pr edit` kræver read:org-scope — brug REST). Og: merge af main ind i en branch med PBI-gem-churn kan GENINDSÆTTE serializer-flyttede TMDL-kolonneblokke som DUBLETTER (`-X ours` er utilstrækkelig — hunks er ikke-konfliktende) → brug `git merge -s ours` (tag hele branch-træet) + dublet-tjek på `^\tcolumn`-navne før push (set 2026-07-20).
- Selvkørt PBI-cyklus (luk/åbn via UIA-recents/TMSL-refresh): opskrift i BI-OEKONOMI/CLAUDE.md.
