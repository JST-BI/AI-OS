# REVIEW.md — review-instruktioner

Facit for hvad et review leder efter og hvordan fund mærkes. Læses af lokal `/code-review` i
Claude Code (via linjen `@REVIEW.md` i `AGENTS.md` — kommandoen læser ellers kun
projektinstruktionerne), af review-agenter som `pbi-kritik` og af andre værktøjer direkte.
Hold filen til regler der ændrer review-adfærd; projektregler hører i `AGENTS.md`.
Fælles del fra `AI OS/tools/review-skabelon.md`; projektets egne regler står nederst.

## Hvad Important betyder her

Brug samme tre mærker som Claude Code Review:

| Mærke | Betydning | Blokerer merge |
|---|---|---|
| 🔴 `Important` | Forkert tal eller resultat, datatab, brud på sikkerhed eller persondata, eller noget der forhindrer en tilbagerulning | Ja |
| 🟡 `Nit` | Lille forbedring, værd at rette men ikke blokerende | Nej |
| 🟣 `Pre-existing` | Fejl der fandtes før ændringen | Nej — opret et issue |

Et tal der *ser* rigtigt ud men er forkert, er altid `Important` — plausibelt forkert er værre end
synligt brudt. Stil, navngivning og refaktorering er højst `Nit`.

## Begræns nits

Rapportér højst fem `Nit` pr. review.

## Rapportér ikke

- Formatering, stavning og stil.
- `.claude/skills/`: genereret kopi af `.agents/skills/` — review kilden.
- Det pre-commit allerede håndhæver: Excel med persondata og `CLAUDE.md`-varianter.
- Fund der allerede er rapporteret i en tidligere runde.

## Tjek altid

- **Persondata.** Navne, CPR og e-mail må ikke i kode, log, fejlbeskeder, committede filer eller
  output der vises i samtalen — kun aggregater.
- **Navne fra kilden.** Felt-, kolonne-, måler- og egenskabsnavne (TMDL, PBIR, M, Excel) skal
  findes i kilden. Et opfundet navn er `Important`.
- **Tal med facit.** En ændring der flytter et tal i en rapport, skal være efterprøvet mod et
  eksternt facit. Kan den ikke det, er en bevidst udfasning bedre end et gæt.
- **Fejlklassen, ikke tilfældet.** Søg samme mønster i hele filen og de berørte filer, og
  rapportér klassen med alle forekomster.
- **Replace-all.** Antallet af forekomster er talt før og efter.

## Bevis før fund

Et fund om adfærd kræver en `fil:linje`-henvisning i kilden og et konkret scenarie
(input → forkert resultat) — aldrig en slutning ud fra et navn alene.

## Projektets egne regler

<!-- Review-regler der kun gælder dette projekt. -->

## Lærte regler

Én linje pr. regel: hvad man skal gøre — og den fejl, den forhindrer. Tilføjes når en fejl er
sluppet igennem review, eller når samme review-kommentar optræder to gange.

<!-- Format: - **Regel.** Forhindrer: <konkret fejl> (ÅÅÅÅ-MM-DD) -->
