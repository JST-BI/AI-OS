# Versionerede git-hooks

`pre-commit` kører tre spærringer. Alle skal passere, før en commit går igennem.

## 1. Persondata i Excel — `check_excel_pii.py`

Blokerer commits af Excel-filer (`.xlsx/.xlsm/...`) der indeholder persondata: CPR
(`DDMMYY-XXXX`), e-mailadresser eller kolonner med
`navn/fornavn/efternavn/cpr/personnummer/mail`. Rene Excel-filer tillades.

## 2. AGENTS.md er eneste instruktionsfil — `check_kun_agents_md.py`

Blokerer commits af `CLAUDE.md`, `.claude/CLAUDE.md` og `CLAUDE.local.md`, uanset indhold.

Codex og Claude Code (fra v2.1.277) læser begge `AGENTS.md` direkte. Claude Code springer
`AGENTS.md` over, så snart der ligger en `CLAUDE.md`-variant i mappen eller over den — en sådan fil
slukker altså stille for reglerne. Flyt teksten til `AGENTS.md`, og fjern gamle pegefiler på
tværs af alle mapper på én gang:

```
& "AI OS\tools\sync-agents-md.ps1"
```

## 3. .agents/skills er kilden, .claude/skills et spejl — `check_skills_mirror.py`

Blokerer commits der rører en skill, hvis `.claude/skills/` ikke har præcis de samme filer med
samme indhold som `.agents/skills/` (sammenlignet i git-index). Codex læser `.agents/skills/`,
Claude Code `.claude/skills/`; spejlet skrives kun af sync-scriptet, så ingen skill kan drive
mellem værktøjerne. Redigér i `.agents/skills/` og kør:

```
& "AI OS\tools\sync-skills.ps1"
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
