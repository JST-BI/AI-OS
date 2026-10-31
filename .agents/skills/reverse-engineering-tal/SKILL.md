---
name: reverse-engineering-tal
description: Brug når et vedtaget, rapporteret eller tidligere beregnet tal (budget, 4.2, regnskab, PBI-måler, regnearkscelle) skal genskabes, forklares eller oversættes til de forudsætninger der gav det – fx "hvad svarer budgettets årselever til i optag", "hvorfor rammer PBI ikke det vedtagne", "hvilken version af filen er den rigtige", eller når to kilder til samme tal afviger og en fil skal rettes tilbage.
---

# Reverse engineering af tal

## Princip
Et genskabt tal er først **bevist**, når den fundne regel kørt forlæns på de fundne input rammer et **frosset, eksternt facit** (inden for afrunding). Alt andet er en hypotese og skal mærkes sådan.

## Fremgangsmåde (leverancen følger disse trin)

1. **Frys facit.** Facit er det låste dokument fra beslutningstidspunktet (PDF, bestyrelsesbilag) – ikke et levende regneark. Peger formlerne på celler opdateret siden (fx `=M6`, M = "regnskab/forventet"), har tallet flyttet sig: sammenlign med det låste dokument før brug.
2. **Proveniens for hver kilde.** Hvornår og af hvem er filen ændret i forhold til facit-datoen? En ældre kopi er ikke "den vedtagne version" – kun en kopi fra facit-tidspunktet er. Søg beslutningshistorikken *før* noget rettes: ændringslog/afstemningsark, `git log`, noter, tidligere samtaletransskripter (søg på filnavnet). En senere bevidst ændring ("lad den være") vinder over en antagelse.
3. **Læs reglen, ikke værdien.** Formler (`openpyxl` uden `data_only`), forklaringskolonner, M/DAX-kode. En tastet konstant har ingen regel i arket – spor den andetsteds eller mærk den "manuel værdi".
4. **Konkurrerende hypoteser + den test der skiller dem.** Skriv hver plausibel forklaring op og regn hver enkelt frem til ejerens *eget* facit (fx "underskud knap 2,5 mio."): den der rammer vinder. Rammer ingen, rapportér afvigelsen – tilpas ikke input til de passer.
5. **Identificerbarhed.** Er facit grovere end spørgsmålet (årselever → optag pr. måned), kan svaret kun være *konsistent med*. Hent antagelsen fra den dokumenterede forudsætning ("Samme som R2025" → 2025's faktiske mønster), skil **bestand/afløb** (tidligere kohorter) fra **nyt flow**, og skriv antagelsen ud.
6. **Forlæns verifikation.** Genberegn række for række og i alt; mutér ét input og se kontrollen blive rød (en kontrol der ikke kan fejle er intet værn).
7. **Ret kun ved kilden, med backup** – og ved konflikt med en tidligere beslutning: ejerens udtrykkelige ord først.

## Leverance
Én tabel pr. genskabt tal:

| Tal | Facit (kilde, dato) | Regel fundet | Input | Genberegnet | Afvigelse | Status |
|---|---|---|---|---|---|---|

Status = **bevist** (rammer facit) · **konsistent** (rammer facit, men antagelse nødvendig – skriv den) · **antaget** · **uopklaret** (afvigelse står). Derefter åbne spørgsmål til ejeren.

## Røde flag
| Tanke | Virkelighed |
|---|---|
| "Den gamle kopi er den rigtige" | Tjek dens dato mod facit og diff begge veje – der kan være ændringer i begge retninger. |
| "Ejeren sagde X i dag, så ret filen" | Søg historikken: modsiger det en tidligere beslutning, så spørg med begge citater. |
| "Arket viser det vedtagne tal" | Kun hvis cellen er frosset eller stemmer med det låste dokument. |
| "Optaget må være det samme som sidste år" | Det er en antagelse – mærk den, og skil bestand fra nyt flow. |
| "Afvigelsen er bare afrunding/timing" | ≠ 0 ud over ±1 kr. pr. række er et rødt flag, ikke en forklaring. |

Persondata: kun aggregater i samtalen (se `AGENTS.md`, Persondata).
