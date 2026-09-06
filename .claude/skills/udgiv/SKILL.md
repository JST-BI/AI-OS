---
name: udgiv
description: "Udgiv" — ajourfør kollegernes delte kopier på Y: (Y:\AI OS som filkopi af OneDrive-AI OS, Y:\AI SOSU\<repo> via git pull --ff-only fra GitHub). Kør ved JSTs kodeord "Udgiv" eller efter merges, der skal ud til kollegerne.
---

# Udgiv — kollegernes Y:-kopier ajourføres

Kør scriptet og rapportér loggen:

```powershell
& "C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers\AI OS\tools\udgiv-til-y.ps1"
```

Hvad det gør:
1. `Y:\AI OS` ← filkopi af `<OneDrive>\AI OS` (robocopy `/E /XO`: kun nyere filer, intet slettes; `.git`, `.claude`, `.codex-tmp`, `.obsidian\workspace.json`, `node_modules` udelades).
2. Rapporterer **forældede filer** på `Y:\AI OS` — dem kilden ikke længere har. Sletter dem kun med `-RyddForaeldede`.
3. `Y:\AI SOSU\<repo>` ← `git pull --ff-only origin main` i hver klon med remote. Lokale ændringer på Y: stashes først og rapporteres — overskriv aldrig noget i blinde. Kloner uden remote (ADM-AFTALER, ADM-BLANKET, BI-OPTAG FRAVÆR) springes over.
4. `DATAKONTROLCENTER` og udtrækkene på Y: røres IKKE — de er kollegernes datagrundlag.

Forudsætninger: alt der skal ud, er merget til `main` og pushet til GitHub FØRST (Udgiv henter fra GitHub, ikke fra OneDrive-klonerne). VPN skal være tilsluttet.

## To ting der er gået galt før

**En FLYTNING i kilden efterlader filen begge steder på Y:.** robocopy sletter aldrig noget — bevidst og rigtigt — men en flytning ligner en ren tilføjelse. Da 11 agenter flyttede til `agents-inaktive/` 2026-09-05, viste `Y:\AI OS\agents\` 19 filer, mens `CLAUDE.md` samme sted sagde 8 aktive. Derfor rapporteres forældede filer nu altid. **Sletning på Y: er uden for projektrødderne — spørg JST før du kører `-RyddForaeldede`.**

**`task 'geometric-repack' failed` er IKKE en fejl i udgivelsen.** Ved et stort pull kører git
sin baggrundsvedligeholdelse, og repack fejler rutinemæssigt på en netværksshare (fil-låsning og
rename-semantik er anderledes end lokalt). Loggen viser den ved siden af det rigtige resultat:
`BI-OEKONOMI : 420d1c1d -> b1c5dc59 (error: task 'geometric-repack' failed)` — repoet **flyttede
sig**, så pull'en lykkedes. Efterprøv frem for at gætte:

```powershell
git -C 'Y:\AI SOSU\<repo>' log --oneline -1        # skal vise den ventede commit
git -C 'Y:\AI SOSU\<repo>' status -sb              # skal stå på main, synkron
git -C 'Y:\AI SOSU\<repo>' fsck --connectivity-only
```

`dangling commit`/`dangling blob` i fsck er **ikke** korruption — det er uafhentede objekter der
venter på oprydning, og de ligger der netop fordi repack ikke kørte. Kun `missing`, `broken` eller
`corrupt` er alvorligt.

**Drevbogstavet `Y:` kan svare `False`, selv om delingen er oppe.** Mappingen er pr. logon-session, og agentens PowerShell kører ikke nødvendigvis i den samme. `net use` viser da mappingen som "Ikke tilgæng". Tjek UNC-stien før du melder VPN-fejl — virker den, så kør scriptet mod den:

```powershell
$u = '\\sosurdata.net.local\Groups$\Ansatte'
& "C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers\AI OS\tools\udgiv-til-y.ps1" -YAIOS "$u\AI OS" -YAISOSU "$u\AI SOSU"
```

Rapportér til JST: hvilke repos der flyttede sig (før → efter), evt. stashes på Y:, robocopy-status for AI OS, og eventuelle forældede filer.
