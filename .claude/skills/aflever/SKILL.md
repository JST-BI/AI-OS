---
name: aflever
description: "Aflever" — alt i ét ved en milepæl eller dagens afslutning: sikr arbejdet (commit/push af egne grene), bogfør, merge de PR'er JST vælger, ajourfør OneDrive-klonerne og INDEX, udgiv til Y:, hent Y:-filer ind, ryd egne worktrees op og aflever en samlet rapport. Kør ved JSTs kodeord "Aflever" eller "bogfør, merge og udgiv".
---

# Aflever — bogfør, merge, udgiv og alt det imellem

Én kommando for hele afleveringen. Trinene kører i rækkefølge; et trin der fejler, stopper kun
sig selv — resten køres, og fejlen står i rapporten. Bogfør og Udgiv er stadig selvstændige
kommandoer (`AGENTS.md` → "Faste kommandoer"); her er de trin 3 og 6.

`<OneDrive>` = `C:\Users\jst\OneDrive - Social og Sundhedsskolen Randers`. Kør git- og
robocopy-trin fra PowerShell, git med `-c gc.auto=0 -c maintenance.auto=false`.

## 1. Opgør stillingen (kun læsning)

- Åbne PR'er i hele organisationen: `gh search prs --owner JST-BI --state open --json repository,number,title,isDraft`.
  Kør `gh` fra Bash — PowerShell ødelægger jq-udtryk med mellemrum.
- Pr. repo i `<OneDrive>\AI SOSU\*` og `<OneDrive>\AI OS` samt hver worktree (`git worktree list`
  i hvert repo; typisk `C:\Temp\*` og `.claude\worktrees\*`): gren, ucommittede filer, commits
  foran `@{u}`.
- Kørende baggrundsagenter, løsrevne refresh-processer og åben Power BI (`Get-Process PBIDesktop*`).
  En agent der stadig skriver i en worktree, afventes eller bedes om status — dens filer
  committes ikke af dig midt i arbejdet.

## 2. Sikr arbejdet

- Egne grene: commit det sessionen har lavet, og push. Aldrig til `main`, aldrig `--force`.
- Fremmede ucommittede filer (JSTs, en anden sessions) røres ikke — de nævnes i rapporten.
- Stag eksplicitte stier; `git add -A` fanger `Input/` med persondata, og hooken blokerer.

## 3. Bogfør

Udfør `AGENTS.md` → "Kodeordet bogfør" trin 1–5 (gem PBI hvis ændret, hukommelse, `MEMORY.md`,
opgaveliste, instruktionsfiler). Statusrapporten (trin 6) samles i trin 8 herunder.

## 4. Merge — JST vælger, du udfører

Merge kræver JSTs ord pr. PR; et kodeord er ikke det ord, og auto-mode afviser `gh pr merge` uden
PR-nummeret i JSTs egen tekst. Derfor:

1. Klassificér hver åben PR: **klar** (ikke draft, `mergeable`, og pbi-kritik GO hvis den rører
   model, M, DAX, motor eller data) · **ikke klar** (draft, NO-GO, gate i gang, konflikt) ·
   **fremmed** (en anden sessions arbejde — merges kun hvis JST nævner den).
2. Løs konflikter på egne klare PR'er først (merge `origin/main` ind, verificér, push).
3. Stil **ét** `AskUserQuestion` med `multiSelect` over de klare PR'er (repo + nummer + titel +
   gate-status i beskrivelsen). Ikke-klare nævnes i spørgsmålsteksten med grunden.
   Tjek basen før spørgsmålet: `gh pr view <n> --repo JST-BI/<repo> --json baseRefName` skal være
   `main`. En stablet PR, hvis base allerede er squash-merget, lander i den gamle gren og aldrig i
   main (BI-OEKONOMI #127, 08-11-2026) – flyt basen til `main` (eller lav en ny PR fra `main`) først.
4. Merge de valgte i afhængighedsrækkefølge (stablede PR'er nedefra; AI OS-INDEX-PR'en efter den
   PR den indekserer). Efterprøv hver: `gh api repos/JST-BI/<repo>/pulls/<n> --jq '[.merged, .base.ref]'`
   skal give `[true, "main"]`.
   En UI-svarknap er ikke en merge.
5. PR'ens egne "Efter merge"-trin (fx `dagskoersel.ps1 -Registrer`) udføres nu — et trin der
   registrerer noget udadtil eller sender noget, bekræftes først.

## 5. Efter merge

- **OneDrive-klonerne** er JSTs arbejdskopier og følger ikke selv med: `git -C "<OneDrive>\AI SOSU\<repo>" pull --ff-only`
  (og `<OneDrive>\AI OS`) for hvert repo der fik en merge — kun når klonen står på `main`
  uden ucommittede filer i de berørte stier. Ellers rapportér, ret intet.
- **INDEX.md**: kom der filer til, forsvandt eller blev omdøbt i et projekt, så åbn en INDEX-PR i AI OS
  (den merges i næste runde, eller nu hvis JST valgte den).
- **Genererede produkter** (fx FB-arbejdsbøger (budgetforslaget) i `DATA-BUDGET_PROGNOSE\Output\Budget`) udgives kun
  når JST har sagt det for netop den leverance — forrige version gemmes først som "- foer …".

## 6. Udgiv

Kør `/udgiv` (`tools/udgiv-til-y.ps1`). Krav før trinnet er færdigt:

- "Filer der kun findes paa Y:" = 0. Er der nogen, hentes de ind i OneDrive (hash-tjek, aldrig
  overskrivning), og Udgiv køres igen.
- Forældede filer på `Y:\AI OS` og en `ADVARSEL ADM-BESPARELSER` rapporteres — slet intet på Y:
  uden JSTs ord (`-RyddForaeldede`).
- Hver repo der flyttede sig: før → efter, og evt. stashes på Y:.

## 7. Ryd op efter dig selv

- Egne worktrees hvis gren er merget og pushet: `git worktree remove <egen sti>`. Aldrig
  `git worktree prune` i et delt repo — den rammer andre sessioners registreringer.
- Sletning af fjerngrene, mere end 5 filer eller noget uden for projektrødderne: læg kommandoen frem
  til JST, kør den ikke selv.

## 8. Rapport

Én samlet rapport, fulde stier:

| Del | Indhold |
|---|---|
| Merget | repo #nr → merge-sha, verificeret |
| Ikke merget | repo #nr — grund (draft / NO-GO / gate kører / fremmed / ikke valgt) |
| Udgivet | repo før → efter; "kun på Y:" = 0; forældede filer |
| Klonerne | OneDrive-kloner ff'et / sprunget over (grund) |
| Sikret | pushede grene; fremmede ucommittede filer der blev ladt i fred |
| Venter på JST | valg, sletninger, afsendelser — én linje hver |
| Næste skridt | hvad arbejdet fortsætter med |
