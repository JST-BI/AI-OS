# CLAUDE.md — AI OS (SOSU Randers)

## Session-startkontrol — kør ved FØRSTE prompt i hver session

Før du besvarer noget som helst, verificér følgende. Rapportér kun hvis noget **fejler**:

```
[ ] CLAUDE.md findes i AI OS rod (denne fil)
[ ] CLAUDE.md findes i BI-SOSU/BI-OEKONOMI/
[ ] CLAUDE.md findes i BI-SOSU/SYS-INNOMATE/
[ ] agents/ indeholder: pbi-dax, pbi-powerquery, pbi-tmdl, pbi-performance, pbi-naming, inno-hr, inno-system, inno-logistics, inno-mailtemplate, md-optimizer
[ ] AI OS rod indeholder KUN: agents/, .claude/, CLAUDE.md, .gitattributes, .gitignore — ingen projektmapper
[ ] SYS-INNOMATE rod indeholder KUN: Input/, Output/, _Arkiv/, CLAUDE.md, .gitattributes, .gitignore
[ ] BI-OEKONOMI rod indeholder: Input/, Output/, Rapporter/, _Arkiv/, .claude/, CLAUDE.md, .gitattributes, .gitignore
[ ] ADM-HÅNDBØGER rod indeholder: Personalehåndbog/, Lederhåndbog/, Input/, Output/, _Arkiv/, .claude/, CLAUDE.md, .gitattributes, .gitignore
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

Dette gælder også de projektspecifikke `CLAUDE.md`-filer i `BI-OEKONOMI` og `SYS-INNOMATE`.

---

## Hvad er AI OS?

AI OS er infrastrukturniveauet for alt AI-assisteret arbejde ved SOSU Randers. Her bor agentdefinitioner og Claude Code-konfiguration. Det er **ikke** et arbejdsprojekt — det er værkstedet.

Arbejdsprojekterne ligger i `BI-SOSU/` (samme OneDrive-rod):

| Projekt | Sti | Indhold |
|---|---|---|
| `BI-OEKONOMI` | `../BI-SOSU/BI-OEKONOMI/` | Power BI-rapport og semantisk model for HR/økonomi |
| `SYS-INNOMATE` | `../BI-SOSU/SYS-INNOMATE/` | Mailskabeloner og procesplaner for onboarding/offboarding via INNOMATE |
| `ADM-HÅNDBØGER` | `../ADM-HÅNDBØGER/` | Personalehåndbog og Lederhåndbog — afspejler hinandens emner |

---

## Hvornår arbejder du her vs. i et projekt?

| Situation | Arbejd i |
|---|---|
| Oprette eller redigere en agent | AI OS (`agents/`) |
| Ændre Claude Code-indstillinger | AI OS (`.claude/`) |
| Bygge DAX, M-kode eller Power BI-rapporter | `BI-SOSU/BI-OEKONOMI/` |
| Skrive procesplaner eller mailskabeloner | `BI-SOSU/SYS-INNOMATE/` |
| Redigere Personalehåndbog eller Lederhåndbog | `ADM-HÅNDBØGER/` |
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

### Generel infrastruktur-agent

| Agent | Rolle |
|---|---|
| `md-optimizer` | Optimering og vedligehold af alle `.md`-filer — særligt CLAUDE.md-hukommelsesfiler. Persisterer ny viden, fejlmønstre og workflowændringer. Bruges proaktivt efter sessioner med fejlrettelser eller arkitekturændringer. |

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
            Drejer det sig om INNOMATE (onboarding, skabeloner, processer)?
              JA  → Skift til SYS-INNOMATE og brug inno-agenter.
              NEJ → Afklar med brugeren hvilket projekt opgaven tilhører.
```

---

## Sikkerhedsregler — handlinger der ALTID kræver bekræftelse

Uanset hvad tilladelsesindstillingerne tillader automatisk, skal Claude **altid stoppe og spørge** før:

| Handling | Eksempel |
|---|---|
| `git push --force` | Overskriver fjernhistorik |
| Sletning af filer/mapper uden for projektmapperne | `rm` på stier uden for `BI-SOSU/` eller `AI OS/` |
| Masseoperationer der ikke kan fortrydes | Slette >5 filer på én gang |
| Afsendelse til eksterne tjenester | E-mail, API-kald med persondata |
| Ændring af Git-konfiguration globalt | `git config --global` |

Alt andet kører uden prompt.

---

## Regler for denne mappe

- **Kun AI-infrastruktur hører hjemme her.** Projektindhold (budgetter, skabeloner, rapporter) hører i `BI-SOSU/`.
- Nye agenter oprettes som `.md`-filer i `agents/` med korrekt frontmatter (`name`, `description`, `tools`, `model`).
- Ændringer commites og pushes til GitHub: `https://github.com/JST-BI/AI-OS`

---

## Navnekonvention — nye projekter

Præfiks bestemmer projekttype. GitHub-repo og lokal mappe hedder det samme:

| Præfiks | Projekttype | GitHub-repo | Lokal mappe |
|---|---|---|---|
| `BI-` | Power BI-rapporter og datamodeller | `JST-BI/BI-<EMNE>` | `BI-SOSU\BI-<EMNE>` |
| `SYS-` | Systemkonfiguration og procesautomatisering (fx INNOMATE) | `JST-BI/SYS-<EMNE>` | `BI-SOSU\SYS-<EMNE>` |
| `ADM-` | Administrative dokumenter (håndbøger, politikker) | `JST-BI/ADM-<EMNE>` | `ADM-<EMNE>\` (i OneDrive-rod) |

**Bemærk**: `BI-` og `SYS-`-projekter samles under `BI-SOSU\`. `ADM-`-projekter ligger direkte i OneDrive-roden. GitHub-repo-navne skal være ASCII (undgå æ, ø, å).
