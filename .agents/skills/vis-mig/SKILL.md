---
name: vis-mig
description: "Vis mig" — teknisk dokumentation som en artefakt-side (HTML på claude.ai) skrevet på dansk efter ASD-STE100-principperne (Simplified Technical English) og forklaret, så en uerfaren lægmand forstår den, med en blanding af tekst og grafik (diagrammer, trin-kort, tabeller). Brug den ved kodeordet "Vis mig" og hver gang JST vil have noget teknisk forklaret, dokumenteret eller vist – et script, en byggekæde, en Power BI-model, en datafil, en arbejdsgang, en kontrol, en fejl – også når ordet "dokumentation" ikke falder, fx "forklar mig hvordan X virker", "lav en vejledning til kollegerne", "hvad gør det her script?", "tegn det for mig".
---

# Vis mig — teknisk dokumentation for lægfolk

Læseren er en normalt begavet person uden teknisk baggrund. Hun kender ikke ordene, men hun kan godt
følge et ræsonnement, når hvert trin er tydeligt. Siden skal kunne læses uden at nogen er til stede
for at forklare den – derfor skal den stå alene.

Tre ting bærer siden: **enkelt sprog** (STE-principperne på dansk), **billeder der viser
sammenhængen** (diagrammer og trin-kort), og **sandhed fra kilden** (alt, siden påstår, er læst i
filerne – ikke husket).

## Arbejdsgang

1. **Find emnet og læs kilden.** Læs de filer, emnet består af (kode, konfiguration, README,
   AGENTS.md). Navne på filer, kolonner, målere, trin og knapper skrives præcis som i kilden. Et
   opfundet navn sender læseren efter noget, der ikke findes. Er noget uklart i kilden, så skriv det
   som uklart frem for at gætte.
2. **Svar på læserens fem spørgsmål**, i denne rækkefølge, før du skriver noget andet:
   - Hvad er det? (én sætning + en hverdagssammenligning)
   - Hvorfor findes det? (hvilket problem løser det)
   - Hvordan virker det? (de store trin – ikke detaljerne)
   - Hvad skal jeg selv gøre? (konkrete handlinger, hvis der er nogen)
   - Hvad gør jeg, hvis det går galt? (tegn → årsag → handling)
3. **Tegn før du skriver.** Lav først oversigtsdiagrammet (se "Grafik"). Kan du ikke tegne
   sammenhængen, forstår du den ikke godt nok endnu – gå tilbage til kilden.
4. **Skriv teksten efter STE-reglerne** i `references/ste-dansk.md`. Læs filen hver gang; reglerne
   er få, men de skal følges konsekvent for at virke.
5. **Byg siden som artefakt.** Følg Artifact-værktøjets regler: kør `quickstart` først, og indlæs
   skills `artifact-design` og `artifact-diagramming`, før du skriver HTML'en. Skriv filen i
   jobbets/sessionens scratch-mappe, ikke i et repo.
6. **Tjek teksten maskinelt:** `python -I -B -X utf8 <denne skill>/scripts/ste_tjek.py <side.html>`.
   Scriptet melder for lange sætninger, passiv form, "man", forkortelser uden forklaring og ord fra
   fy-listen. Ret hvert fund, eller lad det stå med god grund (fx et navn fra kilden).
7. **Udgiv** med Artifact-værktøjet og giv JST linket.

## Sidens opbygning (skabelon)

Brug denne rækkefølge. Den følger læserens spørgsmål, så hun aldrig skal hoppe frem for at forstå.

| Afsnit | Indhold | Grafik |
|---|---|---|
| **Titel** | Emnets navn, 2–4 ord | – |
| **Kort fortalt** | 3 sætninger: hvad, hvorfor, hvad læseren skal gøre | En stor nøgletal- eller statusboks, hvis det giver mening |
| **Hvad er det?** | Definition + én hverdagssammenligning ("Det virker som en …") | En simpel tegning af sammenligningen eller af tingen selv |
| **Overblik** | Hvordan delene hænger sammen | **Oversigtsdiagram** (altid) |
| **Sådan virker det** | De store trin, nummereret | Trin-kort eller flowdiagram med samme numre |
| **Det skal du gøre** | Procedure: ét trin = én handling | Nummererede trin-kort; advarsler før trinnet |
| **Hvis noget går galt** | Tabel: Det ser du · Det betyder det · Gør dette | Statusikoner (✔ / ⚠ / ✖) med tekst – aldrig farve alene |
| **Ord du møder** | Fagord → forklaring i én sætning | – |
| **Hvor ligger det** | Den fulde sti til hver kildefil som én tekst, der kan kopieres (ikke mappe og filnavn hver for sig – læseren skal kunne sætte stien direkte ind i Stifinder), samt links | – |
| **For teknikere** (valgfri, sammenfoldet) | Kode, kommandoer, detaljer | – |

Kode og kommandoer hører kun til i "For teknikere" eller i "Det skal du gøre", når læseren selv skal
skrive dem. I resten af siden forklares hvad koden gør, ikke hvordan den er skrevet.

## Lægmandsniveau – sådan rammer du det

- **Én ny ting ad gangen.** Introducér et begreb, forklar det, og brug det først derefter.
- **Hverdagssammenligninger** gør det abstrakte konkret: en kontrol er "som en kassekontrol ved
  dagens slutning"; en datafil er "som et regneark, en anden har fyldt ud". Hold sammenligningen
  til ét billede pr. begreb, og sig hvor den holder op med at passe, hvis det kan misforstås.
- **Hvorfor før hvordan.** Folk husker en handling bedre, når de ved hvad den beskytter imod.
- **Tal med enhed og betydning:** "86 sekunder", "0 kr. i forskel – det er det, vi vil have".
- **Ingen fagord uden forklaring.** Forklar ordet første gang (og sæt det i "Ord du møder").
  Programnavne, filnavne og knapnavne er tilladt – de er det, læseren skal kunne genkende på skærmen.

## Grafik

Grafikken skal vise noget, teksten har svært ved: rækkefølge, sammenhæng, mængde, status.
Pynt uden information hjælper ikke en lægmand – den forsinker hende.

- **Oversigtsdiagram (altid):** kasser for delene, pile for det der flyttes (data, filer, beslutninger).
  Højst ca. 7 kasser; flere dele grupperes. Læseretning venstre→højre eller top→ned.
- **Trin-kort:** ét kort pr. trin med stort nummer, et verbum i bydeform og evt. et ikon.
- **Før/efter eller sammenligning:** to kolonner side om side.
- **Mængder:** et simpelt søjlediagram frem for en talrække, når størrelsesforholdet er pointen.
  Følg skill `dataviz`, hvis du laver et egentligt diagram.
- Brug inline SVG (virker i lys og mørk tilstand) eller mermaid (`<pre class="mermaid">`).
- **Hver figur får en billedtekst på én sætning**, der siger hvad man skal se. Ingen information må
  kun stå i figuren – en skærmlæser eller en printer i sort-hvid skal ikke miste noget.

## Grænser

- **Persondata:** ingen navne, CPR-numre eller e-mailadresser på siden – heller ikke som eksempel.
  Brug aggregater (antal, summer) og opdigtede, tydeligt fiktive eksempler ("Medarbejder A").
  Artefakter ligger på claude.ai; det er data, der forlader maskinen.
- **Ingen gætværk:** står noget ikke i kilden, så skriv "ikke beskrevet i kilden".
- Siden er dokumentation, ikke en rapport om dagens arbejde – undgå "jeg har …".

## Eksempel på tonen

Dårligt (fagsprog, passiv, lang sætning):
> Slutkontrollen eksekveres efter genberegningen, hvorved samtlige kontrolceller valideres, og ved
> afvigelse afbrydes bygget.

Godt (STE-dansk, lægmandsniveau):
> Slutkontrollen er den sidste kontrol. Den læser alle kontroltallene i regnearket. Hvert tal skal
> være 0. Er ét tal ikke 0, stopper programmet. Så kommer der ingen ny fil – og ingen kan bruge en
> forkert fil ved en fejl.
