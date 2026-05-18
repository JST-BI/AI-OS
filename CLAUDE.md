# CLAUDE.md — AI OS (SOSU Randers)

## Selvvedligehold

Når du opdager ny viden om projekter, agenter eller arbejdsgange der påvirker fremtidige beslutninger, skal du **straks** opdatere det relevante afsnit i denne CLAUDE.md.

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
