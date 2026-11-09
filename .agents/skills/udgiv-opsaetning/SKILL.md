---
name: udgiv-opsaetning
description: "Udgiv opsætning" — samler alle skills (AI OS, projekterne og JSTs personlige) og JSTs indstillinger i VS Code, Claude Code og Codex i en pakke til kollegerne på Y:\AI OS\Opsaetning, med vejledning, licensfilter, stiomskrivning og stop ved nøgler, CPR eller e-mail. Kør ved JSTs kodeord "Udgiv opsætning", eller når JST vil dele sine skills eller indstillinger med kollegerne eller lægge dem på Y:.
---

# Udgiv opsætning — skills og indstillinger til kollegerne

Kør først en prøve, læs loggen, og kør så for alvor:

```powershell
& "C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers\AI OS\tools\udgiv-opsaetning.ps1" -Proev
& "C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers\AI OS\tools\udgiv-opsaetning.ps1"
```

Kør det fra PowerShell, ikke Bash (stier og robocopy). `Y:` falder ud: brug UNC som i `/udgiv`
(`-YAIOS '\\sosurdata.net.local\Groups$\Ansatte\AI OS'`).

## Hvad scriptet gør

1. **Bygger pakken** i `%TEMP%` med tre dele:
   - `Skills\AI-OS` og `Skills\Projekter\<repo>`: hentet fra `main` med `git archive`, så kun committet
     arbejde kommer med.
   - `Skills\Personlige\{claude,claude-ai,agents,codex}`: hentet fra `~\.claude\skills`, `~\.agents\skills`
     og `~\.codex\skills`.
   - `Indstillinger\{VSCode,ClaudeCode,Codex}` og `LAESMIG.md`, der laves fra `assets\LAESMIG-skabelon.md`.
2. **Filtrerer** pakken:
   - Projekter i `$IkkePaaY` springes over. Listen læses fra `udgiv-til-y.ps1`, så der kun er én liste.
   - Skills med licensen "All rights reserved" eller "Proprietary" kommer ikke med (i dag Anthropics
     docx/pdf/pptx/xlsx). De står i LAESMIG.
   - Junctions og `.`-mapper springes over.
   - Codex beholder kun en hvidliste af tabeller. `[projects.*]` fjernes, fordi mappenavnene afslører
     samtalernes emner. Linjer med maskinstier fjernes også.
   - Stier til JSTs OneDrive skrives om til `Y:\AI OS` og `Y:\AI SOSU`. Stier til profilen skrives om
     til `%USERPROFILE%`.
3. **Scanner** alle tekstfiler for nøgler og tokens, CPR-lignende tal, e-mailadresser og rester af
   personlige stier. **Et fund stopper alt (exit 3)**: der skrives intet til OneDrive eller Y:.
   Loggen viser kun sti, type og antal (for e-mail også domænet).
4. **Spejler** pakken til `<OneDrive>\AI OS\Opsaetning`. Mappen er genereret og gitignoreret og har
   mærket `.opsaetning-pakke`. Uden mærket rører scriptet den ikke. Derfra kopieres pakken til
   `Y:\AI OS\Opsaetning`.

Exitkoder: 0 = OK · 1 = fejl · 2 = pakken er bygget i OneDrive, men Y: svarer ikke · 3 = fund i scanningen.

## Ved fund (exit 3)

Pakken ligger til eftersyn i den sti, loggen nævner. Fjern ikke fundet ved at slække på mønsteret.
Find kilden, og vælg en af tre veje:

- Fjern fundet i kilden (skillen eller indstillingen).
- Udelad filen.
- Er fundet et falsk alarm-mønster (fx et eksempel på en e-mailadresse), så tilføj det til `$tilladt`.
  Begrund det i commitbeskeden.

Gengiv aldrig selve fundet i samtalen.

## Sammenhæng med Udgiv

`<OneDrive>\AI OS\Opsaetning` ligger i OneDrive. Derfor bærer almindelig "Udgiv" også mappen til
`Y:\AI OS`, og den bliver hverken meldt som "kun på Y:" eller som forældet. Det er den eneste vej,
skills kommer på Y:\AI OS. Udgiv udelader stadig `.agents` og `.claude` i roden.

**Sletning på Y:** kun med `-RyddForaeldede` og kun på JSTs ord. Det er samme regel som i `/udgiv`.

Rapportér til JST:

- Antal skills pr. kilde.
- Hvad der ikke kom med (licens, dubletter, Codex-tabeller).
- Antal omskrevne stier.
- Resultatet af scanningen.
- Hvad der blev kopieret til Y:, og om der er forældede filer på Y:.
