# CLAUDE.md — AI OS (SOSU Randers)

## Session-startkontrol — kør ved FØRSTE prompt i hver session

Før du besvarer noget som helst, verificér følgende. Rapportér kun hvis noget **fejler**:

```
[ ] CLAUDE.md findes i AI OS rod (denne fil)
[ ] CLAUDE.md findes i AI-SOSU/BI-OEKONOMI/
[ ] CLAUDE.md findes i AI-SOSU/SYS-INNOMATE/
[ ] CLAUDE.md findes i AI-SOSU/ADM-HÅNDBØGER/
[ ] CLAUDE.md findes i AI-SOSU/ADM-ØKONOMI/
[ ] CLAUDE.md findes i AI-SOSU/DATA-BUDGET_PROGNOSE/
[ ] CLAUDE.md findes i AI-SOSU/ADM-BI/
[ ] agents/ indeholder: pbi-dax, pbi-powerquery, pbi-tmdl, pbi-performance, pbi-naming, inno-hr, inno-system, inno-logistics, inno-mailtemplate, md-optimizer, fin-analysis, fin-patterns, fin-statistics, fin-accounting, fin-data, fin-database, adm-bi
[ ] AI OS rod indeholder KUN: agents/, .claude/, CLAUDE.md, .gitattributes, .gitignore — ingen projektmapper
[ ] SYS-INNOMATE rod indeholder KUN: Input/, Output/, _Arkiv/, CLAUDE.md, .gitattributes, .gitignore
[ ] BI-OEKONOMI rod indeholder: Input/, Output/, Rapporter/, _Arkiv/, .claude/, CLAUDE.md, .gitattributes, .gitignore
[ ] AI-SOSU/ADM-HÅNDBØGER rod indeholder: Personalehåndbog/, Lederhåndbog/, Input/, Output/, _Arkiv/, .claude/, CLAUDE.md, .gitattributes, .gitignore
[ ] AI-SOSU/ADM-ØKONOMI rod indeholder: Regnskabsinstruks/, Indkøbspolitik/, Strategi for finansiel risiko/, Input/, Output/, _Arkiv/, .claude/, CLAUDE.md, .gitattributes, .gitignore
[ ] AI-SOSU/ADM-BI rod indeholder: Input/, Output/, _Arkiv/, .claude/, CLAUDE.md, .gitattributes, .gitignore
[ ] AI-SOSU/DATA-BUDGET_PROGNOSE rod indeholder: Input/, Output/, _Arkiv/, CLAUDE.md, .gitattributes, .gitignore
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
2. Committe ændringen: `git add CLAUDE.md && git commit -m "Opdatér CLAUDE.md: <hvad og hvorfor>"`

Dette gælder også de projektspecifikke `CLAUDE.md`-filer i alle projekter under `AI-SOSU/`.

---

## Agentadfærd — grundregler

<!-- Tilføjet efter fejl: agent bad bruger om at udføre manuelle handlinger Claude selv kunne udføre -->

**Claude udfører ALTID alle opgaver selv. Brugeren må ALDRIG bedes om at udføre manuelle handlinger, som Claude kan udføre via tilgængelige værktøjer (filkopiering, PowerShell, git, filsøgning osv.). Sæt dig over forhindringerne — find en vej.**

Konkrete regler:

- **Filsøgning**: Brug `Glob` eller PowerShell `Get-ChildItem -Recurse` til at finde filer på maskinen — bed aldrig brugeren om at kopiere eller finde filer manuelt.
- **Filkopiering**: Brug PowerShell `Copy-Item` — bed aldrig brugeren om at kopiere filer via Stifinder eller andet.
- **Git-kommandoer**: Kør selv via Bash/PowerShell — bed aldrig brugeren om at køre git-kommandoer.
- **Valgmuligheder**: Når en sub-agent returnerer "Option A/B/C — hvad vil du?", præsentér valgmulighederne for brugeren, men udfør straks den valgte mulighed selv uden yderligere delegation til brugeren.
- **Sub-agent-resultater**: Når en sub-agent returnerer resultater der kræver efterfølgende filkopiering, git-kommandoer, encoding-konvertering eller lignende: udfør dem selv med Bash/PowerShell — gå ikke videre til brugeren.

---

## Hvad er AI OS?

AI OS er infrastrukturniveauet for alt AI-assisteret arbejde ved SOSU Randers. Her bor agentdefinitioner og Claude Code-konfiguration. Det er **ikke** et arbejdsprojekt — det er værkstedet.

Arbejdsprojekterne ligger i `AI-SOSU/` (samme OneDrive-rod):

| Projekt | Sti | Indhold |
|---|---|---|
| `BI-OEKONOMI` | `../AI-SOSU/BI-OEKONOMI/` | Power BI-rapport og semantisk model for HR/økonomi |
| `SYS-INNOMATE` | `../AI-SOSU/SYS-INNOMATE/` | Mailskabeloner og procesplaner for onboarding/offboarding via INNOMATE |
| `ADM-HÅNDBØGER` | `../AI-SOSU/ADM-HÅNDBØGER/` | Personalehåndbog og Lederhåndbog — afspejler hinandens emner |
| `ADM-ØKONOMI` | `../AI-SOSU/ADM-ØKONOMI/` | Regnskabsinstruks, Indkøbspolitik og Strategi for finansiel risiko |
| `DATA-BUDGET_PROGNOSE` | `../AI-SOSU/DATA-BUDGET_PROGNOSE/` | Finansiel analyse, budget og prognose — Navision finansposter + BRUGER-budget/prognose → .xlsx-output |
| `ADM-BI` | `../AI-SOSU/ADM-BI/` | BI governance og styringsdokumenter — datastandarder, navnekonventioner, roller og BI-strategi |

---

## Hvornår arbejder du her vs. i et projekt?

| Situation | Arbejd i |
|---|---|
| Oprette eller redigere en agent | AI OS (`agents/`) |
| Ændre Claude Code-indstillinger | AI OS (`.claude/`) |
| Bygge DAX, M-kode eller Power BI-rapporter | `AI-SOSU/BI-OEKONOMI/` |
| Skrive procesplaner eller mailskabeloner | `AI-SOSU/SYS-INNOMATE/` |
| Redigere Personalehåndbog eller Lederhåndbog | `ADM-HÅNDBØGER/` |
| Redigere Regnskabsinstruks, Indkøbspolitik eller finansiel risiko | `ADM-ØKONOMI/` |
| BI governance, datastandarder, navnekonventioner eller BI-strategi | `ADM-BI/` |
| Finansiel analyse, budget, prognose (Navision-data) | `AI-SOSU/DATA-BUDGET_PROGNOSE/` |
| Noget der spænder over flere projekter | Start her, koordinér |

---

## Tilgængelige agenter

Agentfilerne ligger i `agents/` og er symlinket til `~/.claude/agents/`.

### Power BI-agenter (output på US English)

| Agent | Rolle |
|---|---|
| `pbi-dax` | DAX measures, KPIs, tidsintelligens, filterkontext |
| `pbi-powerquery` | M-kode, query folding, relationer, stjerneskema |
| `pbi-tmdl` | TMDL-syntaks, beregningsgrupper, model-metadata |
| `pbi-performance` | VertiPaq, storage modes, refresh-optimering |
| `pbi-naming` | Navngivningskonventioner, display folders, audits |

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
| `md-optimizer` | Optimering og vedligehold af alle `.md`-filer — særligt CLAUDE.md-hukommelsesfiler. Persisterer ny viden, fejlmønstre og workflowændringer. Bruges proaktivt efter sessioner med fejlrettelser eller arkitekturændringer. |

### ADM-BI-agent (output på dansk)

| Agent | Rolle |
|---|---|
| `adm-bi` | BI governance og styringsdokumenter — strategi, datastandarder, navnekonventioner, roller og ansvar |

---

## Tilgængelige skills/plugins

Installerede slash-kommandoer (aktive i alle sessioner):

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
      JA  → Spawn md-optimizer.
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
                      NEJ → Afklar med brugeren hvilket projekt opgaven tilhører.
```

---

## Sikkerhedsregler — handlinger der ALTID kræver bekræftelse

Uanset hvad tilladelsesindstillingerne tillader automatisk, skal Claude **altid stoppe og spørge** før:

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

- **INGEN `/* ... */`-blokkommentarer på objekt-niveau** (measure/column/table). TMDL er indrykningsfølsomt, og blokkommentarer udløser `TMDL Format Error: Parsing error type - Indentation / Invalid indentation` ved load i PBI Desktop. Brug i stedet `///` (beskrivelse, bliver til objektets tooltip) eller `//` (linjekommentar) ved SAMME indrykning som objektet. `/* */` er KUN gyldigt inde i M-source-blokken (`source = ```...````), fordi det er en fritekst-streng. Set 2026-06-01 i `#Measures - STU.tmdl`.
- **PBI-gemning overskriver disk-edits**: Har brugeren pbix'en åben i PBI Desktop og gemmer, skrives in-memory-modellen hen over mine TMDL/PBIR-diskændringer → de forsvinder. Redigér kun disk når disk == seneste PBI-gem; bed brugeren **genåbne pbix UDEN at gemme først** for at indlæse mine ændringer.
- **DAX VAR-navne SKAL være ren ASCII** (set 2026-06-02): æøå/Å (og andre ikke-ASCII-tegn) i et `VAR`-navn giver `Invalid token, Line X, Offset Y, <tegn>` ved parsing. Et mål med denne fejl loades som objekt (vises i Data-ruden med rød trekant) men er ugyldigt → PBI dropper det stille fra visual-field-wells OG filterpanel, så en korrekt visual-binding ser blank ud. Brug fx `_AarStart`/`_AarSlut` i stedet for `_ÅrStart`/`_ÅrSlut`. Tabel-/kolonne-/målnavne MÅ gerne have æøå (de står i `'...'`-quotes); det er kun bare VAR-identifikatorer der skal være ASCII.

## PBIR-rapporter — gotchas (visuals)

- **Indbygget visualType-navn**: *Stacked column chart* = `columnChart` (IKKE `stackedColumnChart` → `CustomVisualNotFound`). Stablet liggende = `barChart`. Clustered har egne navne (`clusteredColumnChart`/`clusteredBarChart`); 100% = `hundredPercentStacked...`.
- **Fra-bunden PBIR-JSON-visuals BINDER faktisk** (rettet 2026-06-02): håndskrevet `queryState`-binding på en helt ny side + visual-skal populerer field-wells og renderer fint ved kold genstart af PBI Desktop — INKL. Y/Column-projektioner, ikke kun Category. Den tidligere konklusion ("binder ikke / kræver UI-træk", set 2026-06-01) var **fejldiagnosticeret**: de refererede mål havde en DAX-fejl (se DAX-VAR-ASCII-gotcha nedenfor), og PBI dropper stille et fejlramt mål fra både field-well OG filterpanel → visual'et så blankt ud, selvom JSON'en var korrekt. **Tjek altid at de refererede mål er fejlfri (ingen rød trekant i Data-ruden) FØR du konkluderer at binding ikke virker.** Repointing af eksisterende UI-skabte visuals virker også (skift `Property` + `queryRef` + `nativeQueryRef` i projection, sortDefinition og filterConfig).
- **Hot-reload af PBIR kræver kold genstart**: PBI Desktop genindlæser ikke altid disk-redigeret PBIR ved blot at åbne filen igen — luk HELE PBI Desktop (ikke kun fanen) og genåbn `.pbip` for at se mine disk-ændringer. TMDL-model-ændringer reloader lettere end PBIR-layout.
- `queryRef: "#Measures - ELEV.X"` kan være en STALE kosmetisk label — den bindende reference er `field.Measure.Expression.SourceRef.Entity` + `Property`.
