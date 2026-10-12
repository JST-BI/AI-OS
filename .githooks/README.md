# Versionerede git-hooks

`pre-commit` kører to spærringer. Begge skal passere, før en commit går igennem.

## 1. Persondata i Excel — `check_excel_pii.py`

Blokerer commits af Excel-filer (`.xlsx/.xlsm/...`) der indeholder persondata: CPR
(`DDMMYY-XXXX`), e-mailadresser eller kolonner med
`navn/fornavn/efternavn/cpr/personnummer/mail`. Rene Excel-filer tillades.

## 2. AGENTS.md er instruktionsfilen, CLAUDE.md en pegefil — `check_md_mirror.py`

Blokerer commits hvor `CLAUDE.md` i en mappe er andet end linjen `@AGENTS.md`, eller hvor kun
den ene af de to filer findes.

`AGENTS.md` er den eneste instruktionsfil og er uafhængig af AI-model. Codex læser den direkte;
Claude Code læser `CLAUDE.md`, som derfor kun indeholder importlinjen `@AGENTS.md`. Så ser begge
værktøjer præcis samme regler, og ingen regel kan drive mellem dem. Skrives der regler i
`CLAUDE.md` igen, ser Codex dem aldrig.

Ret det frem for at omgå spærringen: flyt teksten til `AGENTS.md`, og skriv pegefilerne på
tværs af alle mapper på én gang:

```
& "AI OS\tools\sync-agents-md.ps1"
```

## Aktivér efter `git clone` (ÉN gang pr. klon — også på Windows/PowerShell)

```
git config core.hooksPath .githooks
```

Git kører ikke versionerede hooks automatisk af sikkerhedshensyn. Uden denne kommando er
begge spærringer inaktive.

Kræver `python` (eller `py`) på PATH. Override en enkelt commit: `git commit --no-verify`.

## Kanonisk kilde

Filerne her vedligeholdes i `AI OS/.githooks/` og udrulles til de øvrige repos med
`AI OS/tools/setup-new-repo.ps1`. Ret dem i AI OS, ikke i kopierne.
