---
name: pause
description: Gem og sikr den aktuelle arbejdsstatus ved JSTs kommando "pause", så arbejdet kan genoptages efter internetafbrydelse, sessionsskift eller genstart. Brug også ved "gem status og stop". Almindelig omtale af pauser udløser ikke kommandoen.
---

# Pause — gem, sikr og stop

JSTs "pause" er en handlingskommando. Udfør sikringen lokalt uden at vente på internet, GitHub eller Y:. Bevar opgaven som uafsluttet. En allerede pauset opgave genoptages ikke, fordi JST beder om at ændre pausekommandoen.

## Gennemfør pausen

1. Stands nye arbejdsopgaver. Bed aktive subagenter om at stoppe og aflevere deres lokale status: ændrede filer, ikke-kørte tests og næste trin. Afvent kun igangværende operationer, der skal afsluttes for at undgå tab; notér operationer, der fortsætter. Afbryd ikke en skrivning ved tvangslukning.
2. Gem først et foreløbigt, persondatafrit genoptagelsesnotat i projektets `.codex/tmp/pause/GENOPTAG.md`. Så bevares opgaven, selv hvis resten af sikringen afbrydes. Bevar tidligere noter og backups. Sørg for, at `.codex/tmp/` er gitignoreret, før nye filer lægges dér; brug om nødvendigt repoets lokale `.git/info/exclude`.
3. Gem de berørte dokumenter i deres faktiske programmer gennem den projektspecifikke, verificerede gemmemetode. Kontrollér dokumentets/projektets identitet først. Ved Power BI: læs projektets Desktop-cyklus, afstem indlæst model mod disk før gemning, og brug den kendte gemmekontrol på korrekt proces/vindue. Et gem må aldrig overskrive nyere diskændringer. Ved konflikt bevares begge versioner særskilt, og konflikten beskrives; meld ikke dokumentet gemt. En backup af disk alene sikrer ikke ændringer, der kun findes i programmets hukommelse.
4. Kontrollér at gemningen er afsluttet: fil/cache er stabil, og relevante ændringer er skrevet. Tag en separat, tidsstemplet lokal backup under `.codex/tmp/pause/<tidspunkt>/` af de berørte arbejdsfiler, nye/ignorerede kandidater og nødvendig programcache. Afgræns til det aktuelle arbejde; medtag aldrig backupmappen selv eller `.git/`, og følg ikke junctions/symlinks. Verificér hver medtaget fils størrelse og SHA-256 mod kilden; registrér manifest og kontrollér, at kilden ikke ændrede sig under kopieringen. Fejl eller oversprungne nødvendige filer skal stå som manglende sikring. Slet eller overskriv ikke tidligere backups.
5. Færdiggør notatet med nedenstående indhold og en kopi i den tidsstemplede backup. Registrér den seneste pauses notatsti i `.codex/tmp/pause/SENESTE.md`, især hvis der bevares et eksisterende, mere detaljeret notat et andet sted. Kontrollér at notatet kan læses, og at de nævnte backup- og kandidatfiler findes.
6. Hvis et aktivt mål findes og værktøjet understøtter det, sæt det til pauset på JSTs udtrykkelige anmodning. Opret ikke et nyt mål for at pause. Stop derefter opgavearbejdet. Svar kort med gemmestatus, backupstatus, link til notatet og eventuelle konkrete mangler. Bekræft kun verificerede forhold.

## Genoptagelsesnotat

Notatet skal kunne bruges af en ny session uden samtalehistorikken. Skriv kun nødvendige arbejdsoplysninger og aggregater; ingen persondata, tokens eller kodeord.

- Tidspunkt og årsag; JST har bedt om pause.
- Opgavens mål, accepteret scope, faste beslutninger og begrænsninger.
- Projektsti, gitbranch/HEAD, relevante PR-links og ændrede filer. Skeln mellem agentens og brugerens filer samt produktion, kladder og ikke-integrerede kandidater. Læs Git-filnavne med NUL-separation og UTF-8; gem filoversigter lokalt og undlad personhenførbare filnavne i svaret.
- Hvad der er gemt i programmerne, hvordan det blev verificeret, program-/dokumentidentitet og eventuelle ikke-gemte ændringer. Proces-id'er er historiske oplysninger og skal efterprøves ved genoptagelse.
- Backupsti, omfang, manifest/hashkontrol og eventuelle mangler. OneDrive-placering er ikke bevis på gennemført cloudsynkronisering.
- Udførte tests og konkrete resultater, udestående tests, kendte fejl/blokeringer og reviewstatus. Skeln mellem læst kode, strukturelt valideret kode og faktisk kørt kode.
- Præcist næste handling, nødvendige afhængigheder og hvilke filer der ikke må røres. Medtag subagenternes leverancer og stade.

## Ved "genoptag" eller "resume"

Læs `.codex/tmp/pause/SENESTE.md` og det angivne notat, eller `.codex/tmp/pause/GENOPTAG.md`. Læs projektreglerne igen, efterprøv nuværende filer/gitstatus og åbne dokumenter, og sammenlign med pausestatus. Bevar nyere brugerændringer; gendan aldrig en gammel backup automatisk. Fortsæt fra næste udestående trin, og behandl ikke ukørte tests som beståede.

## Kommandogrænser

"Pause" kræver hverken commit, push, merge, publicering, Y:-spejling, lukning af programmer eller færdiggørelse af opgaven. Åbne dokumenter må blive åbne efter verificeret gemning. Kræv ikke en kold genstart eller nye tunge tests for at kunne pause. Hvis sikker gemning ikke kan gennemføres, bevar de mulige lokale kopier og beskriv præcist hvad der stadig kun findes i hukommelsen. Sig aldrig at alt er sikret, når det ikke er verificeret.

"Bogfør" og "udgiv" er særskilte kommandoer med deres egne regler; pause udløser dem ikke. Udfør ikke netværkshandlinger alene for at bekræfte en pause.
