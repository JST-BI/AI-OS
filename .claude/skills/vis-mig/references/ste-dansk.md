# STE-reglerne på dansk

ASD-STE100 (Simplified Technical English) er en standard fra luftfartsindustrien. Den gør teknisk
tekst entydig, så en læser med lidt forudsætninger – eller med et andet modersmål – forstår den
første gang. Standarden er skrevet til engelsk. Her er dens regler oversat til dansk skrivepraksis.
Reglerne er nummereret efter standardens afsnit, så de kan genfindes.

Siden skrives på dansk (JST 08-11-2026). Den er derfor ikke formelt STE100, men følger principperne.

## 1. Ord

1.1 **Brug almindelige ord.** Vælg det ord, en lægmand bruger i hverdagen (se tabellen nederst).

1.2 **Ét ord = én betydning.** "Fil" er altid en fil, "ark" er altid et ark i et regneark. Skift
ikke mellem "fane", "ark" og "side" om det samme.

1.3 **Samme ting = samme ord**, hele siden igennem. Har du kaldt det "datafilen", så skriv ikke
senere "udtrækket" eller "eksportfilen" om den samme fil.

1.4 **Tekniske navne er tilladt**, når læseren skal genkende dem: programnavne, filnavne, knapper,
menupunkter, kolonnenavne. Skriv dem præcis som på skærmen eller i kilden, og forklar dem første gang.

1.5 **Undgå navneordsstil (nominalisering).** Skriv verbet, ikke et navneord lavet af verbet.
- ✖ "foretage en opdatering af filen" → ✔ "opdatér filen"
- ✖ "gennemførsel af kontrollen" → ✔ "kontrollen kører"

## 2. Sammensatte ord og ordklynger

2.1 **Højst tre led** i et sammensat ord eller en ordklynge. Dansk laver let lange ord – del dem op.
- ✖ "elevaktivitetsprognosemotoren" → ✔ "motoren, der regner elevaktiviteten frem"
- ✖ "lønafstemningskontrolblokken" → ✔ "kontrollen af lønnen"

2.2 Forklar en lang betegnelse fra kilden første gang, og brug derefter en kort form.

## 3. Udsagnsord

3.1 **Brug simple tider:** nutid ("programmet læser"), datid ("filen blev gemt"), fremtid med "vil"
kun når det er nødvendigt.

3.2 **Aktiv form i vejledninger.** Skriv hvem der gør noget.
- ✖ "Filen gemmes i mappen" → ✔ "Programmet gemmer filen i mappen" / "Gem filen i mappen"

3.3 Passiv form (s-passiv: "kontrolleres", "beregnes") må kun bruges i beskrivende tekst, og kun når
det er ligegyldigt, hvem der gør det.

3.4 **Bydeform i trin:** "Klik", "Åbn", "Skriv", "Vent".

3.5 **Ikke "man".** Skriv "du" i vejledninger og navngiv programmet eller personen i beskrivelser.

## 4. Sætninger

4.1 **Ét emne pr. sætning.**

4.2 **Længde:** højst **20 ord** i en vejledning (et trin), højst **25 ord** i beskrivende tekst.
Kortere er bedre.

4.3 **Lister frem for lange opremsninger.** Mere end tre ting i en sætning → lav en punktliste.

4.4 **Undgå indskudte bisætninger.** Sæt hovedsagen først.
- ✖ "Filen, som – når bygget er færdigt og kontrollen er bestået – lægges i mappen, skal …"
- ✔ "Bygget lægger filen i mappen. Det sker først, når kontrollen er bestået."

4.5 **Bindeord gør sammenhængen tydelig:** "derfor", "så", "men", "før", "efter", "hvis".

## 5. Vejledninger (procedurer)

5.1 **Én handling pr. trin.** To handlinger må kun stå i samme trin, hvis de sker samtidig.

5.2 **Betingelsen først:** "Hvis tallet ikke er 0, så stop og ring til JST."

5.3 **Forventet resultat efter trinnet**, hvis læseren skal kunne se, at det lykkedes:
"Vinduet lukker. Der står 'OK' nederst."

5.4 **Nummerér trinnene.** Brug samme numre i teksten og i grafikken.

## 6. Beskrivende tekst

6.1 **Vigtigste oplysning først** i hvert afsnit (emnesætning).

6.2 **Højst 6 sætninger pr. afsnit.**

6.3 **Ét emne pr. afsnit.**

## 7. Advarsler

7.1 Sæt advarslen **før** det trin, den gælder.

7.2 Tre niveauer – brug det rette ord og et ikon:
- **ADVARSEL** – risiko for tab af data, forkerte tal i en rapport, eller at andre rammes.
- **FORSIGTIG** – risiko for at arbejde går tabt eller skal laves om.
- **BEMÆRK** – nyttig oplysning, ingen risiko.

7.3 Start med en klar ordre, forklar derefter risikoen:
"ADVARSEL: Gem ikke filen nu. Tabellerne er ikke opdateret endnu, og filen bliver tom."

## 8. Tegnsætning og tal

8.1 **Ingen forkortelser uden forklaring.** Skriv ordet helt (se fy-listen).

8.2 **Tal med enhed:** "86 sekunder", "3 filer", "0 kr.".

8.3 **Ingen udråbstegn og ingen ironi.** Teksten skal være rolig og saglig.

## Foretrukne ord

| Undgå | Skriv i stedet |
|---|---|
| eksekvere, afvikle | køre |
| initiere, igangsætte | starte |
| implementere | lave, bygge, indføre |
| validere, verificere | kontrollere, tjekke |
| konfigurere | indstille |
| påkrævet, obligatorisk | skal |
| foretage, gennemføre (+ navneord) | brug verbet direkte |
| endvidere, desuden, herudover | også |
| således | sådan, derfor |
| hvorvidt | om |
| i henhold til | efter |
| anvende | bruge |
| afvigelse | forskel |
| parameter | indstilling, værdi |
| iterere | gentage |
| aggregere | lægge sammen |
| output / input | resultat / det programmet læser |

## Fy-listen (scriptet melder dem)

`man`, `evt.`, `mv.`, `m.m.`, `osv.`, `bl.a.`, `ift.`, `ifm.`, `jf.`, `dvs.`, `pga.`, `vha.`,
`hhv.`, `herunder`, `således`, `hvorvidt`, `endvidere`, `eksekvere`, `initiere`, `implementere`,
`validere`, `påkrævet`, `foretage`.
