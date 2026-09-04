# Codex-opsætning på en ny maskine

Læs denne når Codex skal sættes op et nyt sted, eller når projekt-lokale indstillinger ikke ser
ud til at slå igennem. Den er ikke relevant i det daglige arbejde.

## De to værktøjer konfigureres helt forskelligt

Antag aldrig at en indstilling for det ene også gælder det andet — de læser hvert sit format fra
hver sin mappe:

| | Claude Code | Codex |
|---|---|---|
| Instruktionsfil | `CLAUDE.md` | `AGENTS.md` (byte-identisk spejl) |
| Projektkonfiguration | `.claude/settings.json` | `.codex/config.toml` — **små bogstaver, TOML** |
| Personlig konfiguration | `~/.claude/` | `~/.codex/config.toml` |
| Agenter | `agents/` via `~/.claude/agents`, spawnes som subagenter | samme filer læses som rolleinstruks; ingen subagenter |
| Kommandotilladelser | `permissions.allow` i JSON | `sandbox_mode` + `approval_policy`, evt. Starlark i `.codex/rules/*.rules` |

**JSON-filer i `.codex/` har ingen virkning.** AI OS havde indtil 2026-08-20 en
`.Codex/settings.json` i Claude Codes format. Codex læste den aldrig — den så bare rigtig ud.

**Mappenavnet er `.codex` med små bogstaver.** Windows er case-insensitivt, så en fejlkapitaliseret
`.Codex/` virker tilfældigvis lokalt — men navnet gemmes med stort C i git, og på ethvert andet
system (Linux, CI, en frisk klon) finder Codex ingenting.

## Tre ting der skal gøres én gang pr. maskine

**1. Markér projekterne som betroede.** Codex indlæser kun projekt-lokale `.codex/`-lag, hvis
projektet er betroet. Er det ikke det, springes hele laget over uden fejlmeddelelse — en bevidst
sikring mod at et klonet repo medbringer sine egne løsslupne indstillinger. Trust sættes i din
**personlige** `~/.codex/config.toml`, ikke i repoet, netop fordi repoet ellers kunne erklære sig
selv betroet:

```toml
[projects]
"C:\\Users\\jst\\OneDrive - Social og Sundhedsskolen Randers\\AI OS".trust_level = "trusted"
"C:\\Users\\jst\\OneDrive - Social og Sundhedsskolen Randers\\AI SOSU\\BI-OEKONOMI".trust_level = "trusted"
# ... én linje pr. projekt
```

**2. Verificér at `project_doc_max_bytes` slår igennem.** Standardloftet er 65536 bytes.
`BI-OEKONOMI/AGENTS.md` var 91.960 bytes da loftet blev hævet — Codex afkortede den altså og
mistede de nederste ~26 KB regler uden at sige det. Loftet hæves til 262144 i hvert repos
`.codex/config.toml`, men **kun hvis projektet er betroet** (punkt 1).

**3. Aktivér de versionerede hooks:** `git config core.hooksPath .githooks` — én gang pr. klon.
Git kører ikke versionerede hooks automatisk. Uden dette virker hverken Excel-persondata-
spærringen eller spejlkontrollen.

## AGENTS.md findes ved at gå opad — ikke på tværs

Codex leder efter `AGENTS.md` fra arbejdsmappen og opad mod projektroden (mappen med `.git`).
Arbejder du i `AI SOSU\BI-OEKONOMI\`, læses **kun** det projekts `AGENTS.md` — ikke AI OS'. Enhver
regel der skal gælde på tværs, skal derfor stå i hvert projekts egen fil eller udtrykkeligt henvise
til `../../AI OS/AGENTS.md`. Det samme gælder Claude Code og `CLAUDE.md`.

`project_doc_fallback_filenames = ["CLAUDE.md"]` i hver `.codex/config.toml` gør at Codex falder
tilbage på Claude Codes fil, hvis `AGENTS.md` mangler. Det er et sikkerhedsnet mod et brudt spejl
— ikke en erstatning for det.

## `.codex/rules/` er ikke stedet for workflow-prosa

Mappenavnet ligner et spejl af `.claude/rules/`, men `.codex/rules/` er et rigtigt Codex-koncept
med et andet formål: **Starlark-baserede `.rules`-filer der styrer om en kommando må køre**
(`prefix_rule(pattern = [...], decision = "prompt", ...)`). Codex scanner mappen ved opstart.
Læg aldrig `.md` der. Mappen står tom med `.gitkeep`, klar til ægte `.rules`-filer.

## Sandkasse

AI OS' `.codex/config.toml` bruger `sandbox_mode = "workspace-write"`,
`approval_policy = "on-request"` og `approvals_reviewer = "auto_review"`: sikre arbejdshandlinger
kører uden prompt, undtagelser risikovurderes automatisk, netværk er lukket som standard.
Sikkerhedsreglerne i `AGENTS.md` er strengere end sandkassen og gælder uanset.

`<OneDrive>\AI SOSU` skal stå som fuld sti i `sandbox_workspace_write.writable_roots` sammen med
`Y:\AI SOSU`; ellers udløser almindelige projektedits gentagne godkendelser.
Konfigurationsændringer indlæses først i en ny Codex-session.

**Kilder** (verificeret 2026-08-20): [Konfigurationsreference](https://learn.chatgpt.com/docs/config-file/config-reference)
· [Rules](https://learn.chatgpt.com/docs/agent-configuration/rules)
