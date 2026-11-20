---
name: udgiv
description: "Udgiv" — gør Y: identisk med OneDrive (Y:\AI OS som filkopi, Y:\AI SOSU\<repo> via git ff-only + filerne uden for git, og melding om filer der kun findes på Y:). Kør ved JSTs kodeord "Udgiv" eller efter merges, der skal ud til kollegerne.
---

# Udgiv — kollegernes Y:-kopier ajourføres

Kør scriptet og rapportér loggen:

```powershell
& "C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers\AI OS\tools\udgiv-til-y.ps1"
```

Hvad det gør:
1. `Y:\AI OS` ← filkopi af `<OneDrive>\AI OS` (robocopy `/E /XO`: kun nyere filer, intet slettes; `.git`, `.claude`, `.codex-tmp`, `.obsidian\workspace.json`, `node_modules` udelades). En fil der er nyere på `Y:\AI OS` og har andet indhold (SHA256), overskrives ikke, men står under `Nyere paa Y: (ikke overskrevet)`.
2. Rapporterer **forældede filer** på `Y:\AI OS` — dem kilden ikke længere har. Sletter dem kun med `-RyddForaeldede`.
3. `Y:\AI SOSU\<repo>` ← `git pull --ff-only origin main` i hver klon med remote. **Har Y: lokale ændringer, stopper repoet** (ingen stash, ingen pull, `FEJL`) — hent ændringerne ind i OneDrive; `-StashPaaY` stasher i stedet, kun på JSTs ord. Kloner uden remote (ADM-AFTALER, ADM-BLANKET, ADM-RETTIGHEDSSTYRING, BI-OPTAG FRAVÆR) fast-forwardes fra OneDrive-klonens **`main`** (aldrig dens aktuelle gren; ingen `main` = `FEJL`); et repo der mangler på Y:, klones derud fra `main`, og `origin` peger på OneDrive-klonens GitHub-remote (fjernes kun, hvis den ingen har). Y:-klonen skal stå på `main`, ellers `FEJL`.
4. **Filer git ikke følger** (gitignoreret `Input/`/`Output/`, persondata inkluderet) kopieres OneDrive → Y:, når de mangler på Y: eller OneDrive-udgaven er nyere. JST besluttede 2026-09-15, at Y: og OneDrive skal være identiske — også dér. Filer Y:-klonens git følger, røres aldrig. **Er Y:-udgaven nyere og har andet indhold (SHA256), overskrives den ikke** — den står under `Nyere paa Y: (ikke overskrevet)` og skal hentes ind i OneDrive (hash-tjek) eller afgøres med JST.
4a. **FB <år>-mappen** (`BI-OEKONOMI\DATA-BUDGET_PROGNOSE\Output\FB <år>`, årstallet fra `BUDGETAAR` i `tools\budget2027\budgetaar.py`) spejles HELT — også filerne med navne — til `Y:\Økonomi\Økonomistyring\FB <år>` (økonomichefen/JST 20-11-2026). Samme regler som trin 4: kun nyere/manglende filer kopieres, nyere med andet indhold på målet overskrives aldrig (`Nyere paa Y:`), filer kun på målet meldes i trin 5, intet slettes. Log: `Økonomistyring: n filer kopieret, m ens`. Mangler `Økonomistyring` eller `budgetaar.py` = `FEJL`.
4b. Melder `Foraeldede filer paa Y:\AI SOSU\<repo>` — filer hverken Y:-git eller OneDrive har. De kan være forældede kopier ELLER kollegers nye arbejde, så Udgiv sletter aldrig noget i AI SOSU (heller ikke med `-RyddForaeldede`).
5. Melder **"Filer der kun findes paa Y:"**. Skal være 0 — ellers hentes de ind i OneDrive (hash-tjek, aldrig overskrivning).
5a. Sidste linje er `UDGIV OK` (exit 0) eller `UDGIV FEJL: n (fejl …, nyere paa Y: …, kun paa Y: …)`: exit 1 ved enhver fejl (robocopy ≥ 8, repo der ikke kan/må fast-forwardes, fejlet kopi eller hash, fortrolige data på Y:), exit 2 ved filer kun/nyere på Y:. Junctions/symlinks følges ikke; hvert overspringet link logges og tælles i slutlinjen. Alt andet end `UDGIV OK` = udgivelsen er ikke færdig; rapportér linjerne med `FEJL:` til JST. Værn: `tools\test_udgiv_til_y.ps1` (falske OneDrive/Y: under `C:\Temp\udgiv-test`).
5b. Skills og JSTs indstillinger kommer kun på Y: via `/udgiv-opsaetning` (`AI-SETUP\`, som Udgiv bærer videre som en almindelig mappe).
6. `DATAKONTROLCENTER` og udtrækkene på Y: røres IKKE — de er kollegernes datagrundlag.
7. **`ADM-BESPARELSER` kopieres ALDRIG til Y:** (listen `$IkkePaaY` i scriptet; JST 2026-10-16 —
   afskedigelsesvarslinger med navn og CPR). Melder loggen `FEJL: ADVARSEL ADM-BESPARELSER : ligger paa Y:` (exit 1),
   så stop og sig det til JST — mappen skal fjernes, men slet ikke selv uden JSTs ord.
   Undermapper med samme følsomhed står i `$IkkePaaYStier` (i dag DATA-BUDGET's
   `Output/Grundlag/budget*/` – mønster, så det gælder hvert FB-år, uden forskel på store/små bogstaver) og springes over i trin 4; `FEJL: ADVARSEL <repo>/<sti> : ligger paa Y:` (exit 1) = samme fremgang.

Forudsætninger: alt der skal ud, er merget til `main` og pushet til GitHub FØRST (Udgiv henter fra GitHub, ikke fra OneDrive-klonerne). VPN skal være tilsluttet.

## To ting der er gået galt før

**En FLYTNING i kilden efterlader filen begge steder på Y:.** robocopy sletter aldrig noget — bevidst og rigtigt — men en flytning ligner en ren tilføjelse. Da 11 agenter flyttede til `agents-inaktive/` 2026-09-05, viste `Y:\AI OS\agents\` 19 filer, mens `AGENTS.md` samme sted sagde 8 aktive. Derfor rapporteres forældede filer nu altid. **Sletning på Y: er uden for projektrødderne — spørg JST før du kører `-RyddForaeldede`.**

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

**Git afviser Y:-klonerne som `dubious ownership`.** Filserveren ejer dem, og uden undtagelse
melder scriptet hvert repo som "kan ikke fast-forwardes" og springer pull over. Scriptet sætter
selv `safe.directory=*` for sin egen proces. Skriv det ikke med `git config --global`.

**Drevbogstavet `Y:` kan svare `False`, selv om delingen er oppe.** Mappingen er pr. logon-session, og agentens PowerShell kører ikke nødvendigvis i den samme. `net use` viser da mappingen som "Ikke tilgæng". Tjek UNC-stien før du melder VPN-fejl — virker den, så kør scriptet mod den:

```powershell
$u = '\\sosurdata.net.local\Groups$\Ansatte'
& "C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers\AI OS\tools\udgiv-til-y.ps1" -YAIOS "$u\AI OS" -YAISOSU "$u\AI SOSU"
```

Rapportér til JST: slutlinjen (`UDGIV OK` / `UDGIV FEJL: n`), hvilke repos der flyttede sig (før → efter), alle `FEJL:`-linjer, listen "Nyere paa Y:", robocopy-status for AI OS og eventuelle forældede filer.
