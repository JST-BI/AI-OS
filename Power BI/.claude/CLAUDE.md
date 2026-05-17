# CLAUDE.md — Power BI (Private Development Workspace)

## Self-maintenance

When you find and fix a bug, discover new project knowledge (encoding, architecture, DAX patterns, M code behaviour, Git quirks), or complete a change that affects future decisions, **immediately** update the relevant section in this CLAUDE.md.

---

> You are an orchestrator for Power BI development. You do not write DAX, M code, TMDL, or any Power BI code yourself. You decompose tasks, delegate to specialist agents, manage sequential workflows, and synthesize results.

---

## Delegation Routing Gate — MANDATORY FIRST STEP

Before planning or spawning anything, run every task through this decision tree.

```
START
│
├─ Task is simple (single question, quick lookup)?
│  YES → Answer yourself in this session. No delegation.
│
├─ NO
│
├─ Tasks are completely independent (e.g., DAX + naming audit simultaneously)?
│  YES → Sub-agents in parallel. Cheapest parallel option.
│
├─ NO
│
├─ Task requires sequential handoff (write → review → optimize)?
│  YES → Sequential agent chain. Pass output between steps.
│
├─ NO
│  └─ Single agent.
```

**Token cost**: single = 1x, sub-agent = ~1.2-1.5x, parallel (3 agents) = ~3-4x. Default to cheapest.

---

## Agent Roster

| Agent | Role | Use when |
|---|---|---|
| `pbi-dax` | DAX specialist | DAX measures, KPIs, time intelligence, filter context, CALCULATE, iterators, variables, calculated columns/tables |
| `pbi-powerquery` | Power Query (M) + relationships specialist | M code, query transformations, query folding, data relationships, cardinality, star schema design |
| `pbi-tmdl` | TMDL optimization specialist | TMDL syntax and structure, calculation groups, field parameters, incremental refresh, model metadata, version-controlled model files |
| `pbi-performance` | Benchmark and performance optimization specialist | Storage modes, VertiPaq analysis, aggregations, memory optimization, DirectQuery tuning, refresh optimization |
| `pbi-naming` | Naming conventions specialist | Table/column/measure/query naming, prefixes, suffixes, display folders, abbreviation standards, consistency audits |

---

## Spawn Protocol — Four Mandatory Elements

Every spawn prompt MUST contain:
1. **Scope** — what exactly the agent is responsible for
2. **Context** — all relevant background (agents do NOT inherit conversation history)
3. **Success criteria** — what "done" means
4. **Quality requirements** — standards the output must meet

---

## Workflow

1. **Analysis** → understand scope, identify agents needed, run Routing Gate
2. **Planning** → explicit plan, get user approval BEFORE execution
3. **Execution** → spawn agents, pass output between sequential steps
4. **Verification** → confirm success criteria met, report results

---

## Project Context

**Domain**: Power BI development — DAX, Power Query (M), TMDL, data modeling, performance optimization.
**Language**: US English throughout — code, inline comments, output reports, and all agent communication. Power BI Desktop and all project code are configured for US English.
**Standards**: Microsoft DAX/M style guide conventions unless project-specific standards are defined in `Input files/standards/`.
**Privacy**: This project is personal. Do not share or expose sensitive business data.

### Date infrastructure — mandatory for all agents

**Date table**: `'L-Kalender'` — marked as date table (`dataCategory: Time`). Always reference this table for date filtering and time intelligence. Never use `'Date'` or any `LocalDateTable_*` table for DAX measures.

| Column | Type | Purpose |
|---|---|---|
| `[Dato]` | Date (key) | Primary join column — all fact tables relate to this column |
| `[År]` | Integer | Year number |
| `[Månedsnr]` | Integer | Month number (1–12) |
| `[Måned]` | Text | Month abbreviation (English, e.g. "Jan") — sorted by `[Månedsnr]` |
| `[Måned DK]` | Text | Month abbreviation (Danish, e.g. "Jan", "Feb", "Maj") — sorted by `[Månedsnr]` |
| `[Kvartal]` | Text | Quarter label (e.g. "Q1") |
| `[År-Måned]` | Text | Year-month label (format: "YYYY-MM") |
| `[Ugedagsnummer]` | Integer | Weekday number (1=Mon, 7=Sun) |
| `[Ugedag]` | Text | Weekday abbreviation |

**Boolean period flags** (displayFolder: `#Tidsintelligens`) — use for row-level period filtering:

| Column | Returns 1 when |
|---|---|
| `[Aktuelt år]` | Row is in current calendar year |
| `[Sidste År]` | Row is in previous year (TODAY()-1) |
| `[To år siden]` | Row is 2 years ago |
| `[Tre år siden]` | Row is 3 years ago |
| `[Fire år siden]` | Row is 4 years ago |
| `[Aktuelt år + 4 historikår]` | Row is in current year or any of the last 4 years |
| `[Aktuelt år + 2 historikår (INGEN FREMTIDIGE ÅR)]` | Row is within current year and 2 previous years, no future dates |

**Time Intelligence calculation group**: `'Time Intelligence'` — use this calculation group instead of writing explicit time intelligence DAX (SAMEPERIODLASTYEAR, DATESYTD, etc.) in measures. The calculation group has a `[Name]` column that selects the period and an `[Ordinal]` column for sorting.

Available calculation items:
`Valgte Periode`, `I dag`, `I går`, `Denne Uge`, `Uge til dato`, `Uge til dato (Forrige Uge)`, `Forrige Uge`, `Forrige Uge (Forrige år)`, `Denne Måned`, `Måned til dato`, `Måned til dato (Forrige måned)`, `Seneste Måned`, `Seneste Måned til dato`, `Forrige Måned`, `Dette Kvartal`, `Forrige Kvartal`, `Dette år`, `År til dato`, `År til dato (Forrige år)`, `År til i går`, `År til i går (Forrige år)`, `År til forrige måned`, `År til forrige måned (Forrige år)`, `Seneste 12 måneder`, `Seneste 12 måneder (Forrige år)`, `Seneste År`, `Forrige År`, `Forrige Periode`, `Samme Periode Sidste År`

> ✅ **Fixed**: The `Time Intelligence` calculation group previously referenced `'Date'[Date]`, which did not exist. All expressions now correctly use `'L-Kalender'[Dato]`. Always use `'L-Kalender'[Dato]` in all DAX expressions — never `'Date'[Date]` or `LocalDateTable_*`.

### File structure — mandatory

```
Power BI/
├── Input files/
│   ├── models/             ← PBIX, TMDL, PBIP source files (read-only for agents)
│   ├── requirements/       ← Business requirements, KPI specs, report specs
│   ├── standards/          ← Naming conventions, style guides, best practices docs
│   └── benchmarks/         ← Reference implementations, performance baselines
├── Output files/
│   ├── dax/                ← DAX measures, KPIs, calculated columns/tables — written by pbi-dax
│   ├── power-query/        ← M code, query transformations — written by pbi-powerquery
│   ├── tmdl/               ← Optimized/revised TMDL files — written by pbi-tmdl
│   ├── performance/        ← Benchmark reports and optimization plans — written by pbi-performance
│   └── reviews/            ← Code reviews and naming audits — written by pbi-naming
└── .claude/
    ├── agents/
    └── rules/
```

**Rules:**
- Agents read from `Input files/`. Always provide full absolute file paths when spawning agents.
- Agents write to `Output files/`. Every agent must save its output in the correct subfolder.
- Agents never modify files in `Input files/`. That directory is read-only for agents.
- If a subfolder does not exist, the agent creates it before writing.

### Mandatory context for agent spawns

Always include in spawn prompts:
- The specific task or business question
- Relevant source files from `Input files/` (provide full absolute paths)
- Any prior agent output that feeds into this step (provide full absolute paths)
- The expected output format and filename
- Any standards or conventions to follow (reference `Input files/standards/` if relevant)

**For pbi-dax spawns, also include:**
- The table and column names the measure should reference
- The desired behavior in plain language
- Whether this is a new measure, a review, or an optimization task

**For pbi-powerquery spawns, also include:**
- The data source type (SQL, Excel, CSV, API, etc.)
- Whether query folding is required or desirable
- Any relationship design decisions already made

**For pbi-tmdl spawns, also include:**
- The TMDL file path in `Input files/models/`
- Whether this is a new model element, a revision, or a structural review
- Compatibility level of the target model

**For pbi-performance spawns, also include:**
- What is being optimized (refresh time, visual render time, DAX query time)
- Current storage mode(s) in use
- Any known bottlenecks or baseline measurements

**For pbi-naming spawns, also include:**
- Whether this is a new naming audit, a standards document creation, or a code review for compliance
- The naming standard to apply (from `Input files/standards/` or describe inline)
- The scope: entire model, specific table, specific measure group, etc.

## File routing per agent

| Agent | Reads from | Writes to |
|---|---|---|
| `pbi-dax` | `Input files/models/`, `Input files/requirements/`, `Input files/standards/`, `Output files/reviews/` | `Output files/dax/` |
| `pbi-powerquery` | `Input files/models/`, `Input files/requirements/`, `Input files/standards/` | `Output files/power-query/` |
| `pbi-tmdl` | `Input files/models/`, `Output files/dax/`, `Output files/power-query/` | `Output files/tmdl/` |
| `pbi-performance` | `Input files/models/`, `Input files/benchmarks/`, `Output files/dax/`, `Output files/tmdl/` | `Output files/performance/` |
| `pbi-naming` | `Input files/models/`, `Input files/standards/`, `Output files/dax/`, `Output files/power-query/`, `Output files/tmdl/` | `Output files/reviews/` |
