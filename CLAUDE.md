# CLAUDE.md — AI OS (SOSU Randers)

## Session-startkontrol — kør ved FØRSTE prompt i hver session

Før du besvarer noget som helst, verificér følgende. Rapportér kun hvis noget **fejler**:

```
[ ] CLAUDE.md findes i AI OS rod (denne fil)
[ ] CLAUDE.md findes i BI-SOSU/BI-OEKONOMI/
[ ] CLAUDE.md findes i BI-SOSU/BI-INNOMATE/
[ ] agents/ indeholder: pbi-dax, pbi-powerquery, pbi-tmdl, pbi-performance, pbi-naming, inno-hr, inno-system, inno-logistics, inno-mailtemplate
[ ] AI OS rod indeholder KUN: agents/, .claude/, CLAUDE.md, .gitattributes, .gitignore — ingen projektmapper
[ ] BI-INNOMATE rod indeholder KUN: Input/, Output/, _Arkiv/, CLAUDE.md, .gitattributes, .gitignore
[ ] BI-OEKONOMI rod indeholder: Input/, Output/, Rapporter/, _Arkiv/, .claude/, CLAUDE.md, .gitattributes, .gitignore
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

Dette gælder også de projektspecifikke `CLAUDE.md`-filer i `BI-OEKONOMI` og `BI-INNOMATE`.

---

## Hvad er AI OS?

AI OS er infrastrukturniveauet for alt AI-assisteret arbejde ved SOSU Randers. Her bor agentdefinitioner og Claude Code-konfiguration. Det er **ikke** et arbejdsprojekt — det er værkstedet.

Arbejdsprojekterne ligger i `BI-SOSU/` (samme OneDrive-rod):

| Projekt | Sti | Indhold |
|---|---|---|
| `BI-OEKONOMI` | `../BI-SOSU/BI-OEKONOMI/` | Power BI-rapport og semantisk model for HR/økonomi |
| `BI-INNOMATE` | `../BI-SOSU/BI-INNOMATE/` | Mailskabeloner og procesplaner for onboarding/offboarding via INNOMATE |

---

## Hvornår arbejder du her vs. i et projekt?

| Situation | Arbejd i |
|---|---|
| Oprette eller redigere en agent | AI OS (`agents/`) |
| Ændre Claude Code-indstillinger | AI OS (`.claude/`) |
| Bygge DAX, M-kode eller Power BI-rapporter | `BI-SOSU/BI-OEKONOMI/` |
| Skrive procesplaner eller mailskabeloner | `BI-SOSU/BI-INNOMATE/` |
| Noget der spænder over begge projekter | Start her, koordinér |

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

---

## Routing — kør dette først ved enhver opgave

```
Opgaven vedrører agenter eller AI-konfiguration?
  JA  → Arbejd direkte her i AI OS.
  NEJ →
    Drejer det sig om Power BI (DAX, M-kode, TMDL, rapporter)?
      JA  → Skift til BI-OEKONOMI og brug pbi-agenter.
      NEJ →
        Drejer det sig om INNOMATE (onboarding, skabeloner, processer)?
          JA  → Skift til BI-INNOMATE og brug inno-agenter.
          NEJ → Afklar med brugeren hvilket projekt opgaven tilhører.
```

---

## Regler for denne mappe

- **Kun AI-infrastruktur hører hjemme her.** Projektindhold (budgetter, skabeloner, rapporter) hører i `BI-SOSU/`.
- Nye agenter oprettes som `.md`-filer i `agents/` med korrekt frontmatter (`name`, `description`, `tools`, `model`).
- Ændringer commites og pushes til GitHub: `https://github.com/JST-BI/AI-OS`
