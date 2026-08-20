# Versionerede git-hooks

`pre-commit` kører to spærringer. Begge skal passere, før en commit går igennem.

## 1. Persondata i Excel — `check_excel_pii.py`

Blokerer commits af Excel-filer (`.xlsx/.xlsm/...`) der indeholder persondata: CPR
(`DDMMYY-XXXX`), e-mailadresser eller kolonner med
`navn/fornavn/efternavn/cpr/personnummer/mail`. Rene Excel-filer tillades.

## 2. CLAUDE.md/AGENTS.md-spejlet — `check_md_mirror.py`

Blokerer commits hvor `CLAUDE.md` og `AGENTS.md` i samme mappe ikke er byte-identiske,
eller hvor kun den ene halvdel af parret er med i commit'en.

Claude Code læser `CLAUDE.md`, Codex læser `AGENTS.md`. De er samme indhold under to navne,
så begge værktøjer ser præcis de samme regler. Driver de fra hinanden, følger de to værktøjer
hver sin udgave af reglerne — og det opdages først, når en agent handler forkert.

Ret et brudt spejl frem for at omgå spærringen:

```
Copy-Item CLAUDE.md AGENTS.md ; git add CLAUDE.md AGENTS.md
```

Eller på tværs af alle projekter på én gang:

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
