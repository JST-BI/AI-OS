# Versionerede git-hooks

`pre-commit` blokerer commits af Excel-filer (`.xlsx/.xlsm/...`) der indeholder
persondata: CPR (`DDMMYY-XXXX`), e-mailadresser eller kolonner med
`navn/fornavn/efternavn/cpr/personnummer/mail`. Rene Excel-filer tillades.

## Aktivér efter `git clone` (ÉN gang pr. klon — også på Windows/PowerShell)
```
git config core.hooksPath .githooks
```
Kræver `python` (eller `py`) på PATH. Override en enkelt commit: `git commit --no-verify`.
