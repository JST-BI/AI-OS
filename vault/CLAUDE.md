# Obsidian-vault — noteregler

Gælder **kun** filer under `vault/`. De gælder ikke `CLAUDE.md`, `AGENTS.md`, `INDEX.md` eller
`agents/*.md` — de læses som instruktion og har ingen note-frontmatter. Skriv aldrig `tags`,
`created` eller `status` i en agentfil; det brækker agent-indlæsningen.

Projekt-noter hører i projektets eget repo under `<OneDrive>\AI SOSU\`, ikke her. Derfor findes
`vault/projects/` bevidst ikke.

## Grundregler

- **Ingen absolutte stier i interne links.** Wikilinks: `[[Note]]`, `[[Note|alias]]`, embeds
  `![[fil]]`, callouts `> [!note] Titel` (note, tip, warning, info, example, abstract, todo).
- **Slet, omdøb eller overskriv aldrig JSTs egne noter og formuleringer uden en direkte
  instruktion.** Uopfordrede tilføjelser lægges nederst under `## AI Indsigter (YYYY-MM-DD)`.
  Ved større omstrukturering: foreslå først.
- **Brug den reelle dags dato** i `created:`/`updated:` — slå den op. `updated:` sættes ved
  enhver redigering.
- **Ved tvivl om placering, navngivning eller indhold: spørg.** Samme regel som "læs kilden —
  antag aldrig et navn".
- Markér AI-berørte noter med `#ai-assisted` hvor det er relevant.

## Frontmatter — obligatorisk på nye noter

```yaml
---
tags: []          # kebab-case, genbrug eksisterende
created: YYYY-MM-DD
updated: YYYY-MM-DD
status: draft     # draft | review | permanent | archived
aliases: []
type:             # meeting | project | note | resource | daily | person | decision | index
---
```

Skabeloner: `vault/_templates/` ([[Daily]], [[Note]], [[Meeting]], [[Decision]]).

## Routing

| Indholdstype | Placering | Filnavn | `type:` |
|---|---|---|---|
| Daglig note | `vault/journal/` | `YYYY-MM-DD.md` | daily |
| Møde | `vault/meetings/` | `YYYY-MM-DD - Mødetitel.md` | meeting |
| Permanent note | `vault/notes/` | `Titel.md` | note |
| Person | `vault/notes/people/` | `Fornavn Efternavn.md` | person |
| Beslutning | `vault/notes/decisions/` | `YYYY-MM-DD - Beslutning.md` | decision |
| Ressource/kilde | `vault/resources/` | `Titel.md` | resource |
| Uforarbejdet | `vault/inbox/` | `YYYY-MM-DD - Kort titel.md` | – |
| Index/MOC | `vault/` | `Index - Emne.md` | index |
| Vedhæftning | `vault/_attachments/` | beskrivende filnavn | – |

Filnavne i Title Case eller `YYYY-MM-DD - Titel`. Undgå `/ \ : * ? " < > |`.
**Opret aldrig en ny mappe i `vault/` uden at sige det.**

Rækkefølge når du router: findes emnet allerede, så udvid frem for at oprette. Hører noten til et
projekt, hører den i projektets repo. Er du i tvivl, så foreslå — eller læg den i `vault/inbox/`
og sig det.

Obsidian er konfigureret til at følge dette: `.obsidian/app.json` lægger nye filer i
`vault/inbox/`, `daily-notes.json` peger på `vault/journal/`, `templates.json` på
`vault/_templates/`. Uden den opsætning skrev daily-notes-pluginet i roden.

## Index/MOC-vedligehold

[[Index - Vault]] er vaultens MOC. `INDEX.md` i AI OS-roden er noget andet — filindekset over
styrede filer i alle projekter. Vault-noter hører ikke i `INDEX.md`.

- Index-noter er rene oversigter: korte beskrivelser + wikilinks. Ingen brødtekst.
- Opretter du en note under et eksisterende index → tilføj wikilinket der. Ny kategori → foreslå
  et nyt index, opret det først efter tilladelse.
- **Tjek for dubletter før du tilføjer**, fjern dem du støder på, og nævn oprydningen kort.
- Sortér alfabetisk, medmindre kronologisk giver bedre mening. Bliver et index for langt →
  foreslå opdeling. Opdatér `updated:`.

## Svarprotokol

Når — og kun når — du opretter, opdaterer eller omstrukturerer filer i `vault/`, indled svaret med:

```yaml
# AI_ACTION_METADATA
action: [created | updated | restructured]
target_file: "vault/relativ/sti.md"
frontmatter_updated: [true | false]
indexes_updated: ["Index - Vault"]
changes_summary: "Kort, præcis beskrivelse"
ai_confidence: [high | medium | low]
```

Udelades ved læsning, analyse, almindelige spørgsmål og alt arbejde uden for `vault/`.

> [!warning] Obsidian skriver sin egen konfiguration tilbage
> En kørende Obsidian holder indstillingerne i hukommelsen og skriver **hele** `.obsidian/*.json`
> til disk ved enhver UI-ændring. Redigerer du filerne mens programmet kører, kan ændringen blive
> overskrevet uden varsel. Genstart Obsidian efter du har rørt `.obsidian/`, og verificér på
> adfærden — opret en note og se hvor den lander — ikke på filens indhold.
