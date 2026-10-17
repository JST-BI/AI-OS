# Jev (TypeSafe) i AI OS — undersøgelse 2026-10-17

Spørgsmål: hvor i AI OS kan en hurtig, typet AI-vurdering (TypeSafe System One, model `jev-1.13.0`)
afløse skrøbelig parsing eller nøgleordsregler? BI-OEKONOMI er undersøgt separat (Codex-session) og
indgår ikke her. Ingen persondata er sendt til API'et: kun DAX-kode (literaler maskeret),
kolonnenavne og AI OS' egne instruktionstekster.

## Resultat 1 — DAX-persondatavagt (implementeret: `tools/dax-persondata-vagt.py`)

Reglen "kun aggregater i samtalen" var kun en kommentar i `dax-query.ps1`. Et nøgleordsfilter er
værdiløst her: de fleste sikre queries bruger `cprnr` inde i `DISTINCTCOUNT`, mens de farlige kan
returnere `TOPN(20, 'Løn')` uden at nævne en personkolonne.

| Datasæt | Metode | Persondata sluppet igennem | Sikre blokeret | Sikre til review |
|---|---|---|---|---|
| 129 queries (103 fra repoerne + 26 syntetiske) | nøgleord (cpr/navn/mail …) | 4 af 17 | 22 af 112 (falsk alarm) | – |
| samme | Jev, trevejspolitik | **0 af 17** | **0** | 5 |
| 14 holdout, skrevet efter tærsklerne var låst | Jev | **0 af 7** | **0** | 2 |
| 106 repo-queries, **produktionens kolonneliste** fra HR_OEKONOMI | Jev v2 | **0 af 2** | **0** | 3 (+2 for lange → review) |

Ende-til-ende mod kørende HR_OEKONOMI: aggregat-query → `pass` (5,1 s inkl. første
kolonneklassifikation); et rigtigt CPR-rækkedump → `BLOKERET` før kørsel (0,95).
Mutationstest: med slappe tærskler melder `--selftest` `FEJL (22)` — kravet kan fejle.

**Lærestreg — produktionens konfiguration:** første version klassificerede kolonner med en generisk
formulering og markerede 105 af HR_OEKONOMI's 1.034 kolonner som personkolonner (Jev læste
`navision_ansvar` som "en ansvarlig person"). Det blokerede 21 sikre repo-queries — usynligt i
testen med håndskreven kolonneliste. En domæneordliste i kriterierne (ansvar, formål, CØSA, hold …)
gav 11 falske, recall uændret 1,00. Den fandt også en reel personkolonne mit facit manglede
(`Regnskabsposteringer[Tjenestenummer]`).

Design: (1) kolonnenavne fra modellens DMV'er → Jev-Noul pr. kolonne (cache i
`%LOCALAPPDATA%\AI-OS\`, nøglet på formuleringsversion); (2) querytekst med literaler maskeret +
de refererede personkolonner → én helheds-Noul + tre bogstavelige delspørgsmål (hele rækker /
id-værdier / én række pr. person); max < 0,35 pass, > 0,70 block, ellers review. Delspørgsmålene
lukkede de to huller helheds-spørgsmålet havde (`TOPN` på hel tabel, `GENERATE` pr. person).

## Resultat 2 — regel kontra historik i instruktionsfiler (foreslået, ikke implementeret)

"Skriv reglen, ikke historien" håndhæves kun manuelt. 106 afsnit (AI OS-instruktionsfiler +
AI OS' auto-hukommelse), 14 status/historik:

| Metode | Recall | Præcision |
|---|---|---|
| regex (dato, #PR, hash, MERGET) | 0,57 | 0,53 |
| Jev Choice {regel, regel-med-historie, status} | 0,86 | 1,00 |

Lovende som rådgivende tjek (fx i md-optimizer eller en `-Check` i `sync-agents-md.ps1`), men kun
14 positive — mål på flere projekters `AGENTS.md` før det bliver et krav.

## Afviste kandidater

- **`check_excel_pii.py`** — hookens opgave er at holde persondata på maskinen; at sende arkets
  tekst til et eksternt API modarbejder den. Hullerne (CPR uden bindestreg, navnekolonner uden
  nøgleord) lukkes deterministisk: `\d{10}` + datotjek, og en kolonneordliste.
- **Øvrige `tools/*.ps1`** — deterministisk VVS (robocopy, git, TMDL, porte); intet at vurdere.

## Beslutninger (JST 2026-10-17)

1. **Opt-in.** BI-OEKONOMI's kalenderprofil-pipeline henter bevidst CPR-rækker gennem
   `dax-query.ps1` til lokal aggregering; den skal ikke brydes.
2. **API nede → brugeren vælger.** Vagten stopper og viser valgene; `-VedVagtNede Noegleord`
   (lokal nøgleordsregel, hit kræver `-BekraeftAggregat`) eller `-VedVagtNede Koer`. Agenten
   spørger JST og vælger aldrig selv. Alle seks spor er afprøvet mod kørende HR_OEKONOMI med
   simuleret nedbrud (`AI_OS_TYPESAFE_URL`).
3. **Model-opgradering:** tærsklerne er målt på `jev-1.13.0` (fastlåst). `jev-1.14` findes som
   preview; kør `--selftest` før `MODEL` ændres.

## Opsætning: API-nøglen

Vagten kalder TypeSafe med JSTs personlige API-nøgle i Windows-brugermiljøvariablen
`TYPESAFE_API_KEY` (sat på denne maskine). Nøglen er en adgangskode: forbruget faktureres JSTs
konto, så den deles ikke med kolleger og committes aldrig. Ny maskine:
`[Environment]::SetEnvironmentVariable('TYPESAFE_API_KEY', '<nøgle>', 'User')` og genstart
terminalen. Mangler nøglen, opfører vagten sig som "API nede" (stopper og lader brugeren vælge).
