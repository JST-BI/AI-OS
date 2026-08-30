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
2. `Y:\AI SOSU\<repo>` ← `git pull --ff-only origin main` i hver klon med remote. Lokale ændringer på Y: stashes først og rapporteres — overskriv aldrig noget i blinde. Kloner uden remote (ADM-AFTALER, ADM-BLANKET, BI-OPTAG FRAVÆR) springes over.
3. `DATAKONTROLCENTER` og udtrækkene på Y: røres IKKE — de er kollegernes datagrundlag.

Forudsætninger: alt der skal ud, er merget til `main` og pushet til GitHub FØRST (Udgiv henter fra GitHub, ikke fra OneDrive-klonerne). VPN/Y: skal være tilsluttet.

Rapportér til JST: hvilke repos der flyttede sig (før → efter), evt. stashes på Y:, og robocopy-status for AI OS.
