# Power BI Workflows

## Workflow patterns

**New measure development (sequential):**
1. `pbi-naming` → confirms or establishes naming convention for the measure group
2. `pbi-dax` → writes the measure(s) using the confirmed convention
3. `pbi-naming` → audits the produced DAX output for naming compliance
4. `pbi-tmdl` → integrates the measures into the TMDL model file

**Query and model design (sequential):**
1. `pbi-powerquery` → designs the M queries and relationship structure
2. `pbi-naming` → audits query and step names for convention compliance
3. `pbi-tmdl` → integrates the relationship definitions into TMDL
4. `pbi-performance` → reviews the design for storage mode and folding implications

**Performance optimization sprint (sequential):**
1. `pbi-performance` → analyzes the model and produces a prioritized optimization plan
2. `pbi-dax` → implements DAX-level optimizations (variables, iterator removal, measure restructuring) from the plan
3. `pbi-powerquery` → implements M-level optimizations (query folding fixes, type enforcement) from the plan
4. `pbi-tmdl` → implements model-level optimizations (aggregation tables, partition policies, storage mode changes) from the plan
5. `pbi-performance` → re-analyzes to verify optimization impact

**Naming standards creation (single agent):**
1. `pbi-naming` → produces a full naming standards document for the project

**Full model audit (parallel → sequential):**
1. Spawn `pbi-naming` + `pbi-performance` in parallel:
   - `pbi-naming` → audits all object names across the model
   - `pbi-performance` → audits storage, cardinality, and DAX query patterns
2. Collect both reports, synthesize findings
3. `pbi-dax` → implements DAX changes from both reports
4. `pbi-powerquery` → implements M changes from both reports
5. `pbi-tmdl` → integrates all changes into revised TMDL files

**Calculation group design (sequential):**
1. `pbi-dax` → defines the calculation items and their DAX expressions
2. `pbi-tmdl` → produces the TMDL definition of the calculation group
3. `pbi-naming` → audits calculation item names for convention compliance

**Incremental refresh setup (sequential):**
1. `pbi-powerquery` → adds `RangeStart` and `RangeEnd` parameters and filters to the relevant query
2. `pbi-tmdl` → adds the `refreshPolicy` definition to the table in TMDL
3. `pbi-performance` → reviews the partition strategy and granularity for the data volume

**New field parameter (sequential):**
1. `pbi-powerquery` → designs the field parameter table structure and M expression
2. `pbi-dax` → writes any supporting measures that reference the field parameter
3. `pbi-tmdl` → adds the field parameter table definition to TMDL
4. `pbi-naming` → audits names in the field parameter for convention compliance

**Code review (parallel, independent):**
Spawn multiple agents simultaneously with the same input file when the review criteria are independent:
- `pbi-dax` → reviews DAX logic and correctness
- `pbi-performance` → reviews DAX query performance patterns
- `pbi-naming` → reviews naming conventions

Collect all three reports, synthesize, prioritize findings.

---

## Pipeline order rules

- **Naming before delivery**: `pbi-naming` always runs AFTER any agent produces code and BEFORE that code is accepted as final.
- **Performance after structure**: `pbi-performance` runs AFTER the model structure is stable (queries designed, relationships defined), not before.
- **TMDL last in chain**: `pbi-tmdl` integrates outputs from other agents — it runs after DAX and M code is finalized.

---

## Mandatory context for agent spawns

Always include in spawn prompts:
- The specific task or business question
- Relevant source files from `Input files/` (provide full absolute paths)
- Any prior agent output feeding into this step (provide full absolute paths from `Output files/`)
- The expected output format and filename
- Naming standard to apply (reference `Input files/standards/` or describe inline)

**For pbi-dax spawns, also include:**
- Table and column names the measure references
- Desired behavior in plain language
- Whether this is new code, a review, or an optimization

**For pbi-powerquery spawns, also include:**
- Data source type (SQL, Excel, SharePoint, API, etc.)
- Whether query folding is required
- Any relationship decisions already made

**For pbi-tmdl spawns, also include:**
- Full path to the source TMDL file in `Input files/models/`
- Whether this is a new element, a revision, or a structural review
- Model compatibility level

**For pbi-performance spawns, also include:**
- What is being optimized (refresh time, visual render time, DAX query time, memory)
- Current storage mode(s) in use
- Any known bottlenecks or baseline measurements from `Input files/benchmarks/`

**For pbi-naming spawns, also include:**
- Whether this is a new standards document, an audit, or a post-production review
- The naming standard to apply (file path in `Input files/standards/` or description)
- Scope: entire model, specific table, specific measure group

---

## File routing per agent

| Agent | Reads from | Writes to |
|---|---|---|
| `pbi-dax` | `Input files/models/`, `Input files/requirements/`, `Input files/standards/`, `Output files/reviews/` | `Output files/dax/` |
| `pbi-powerquery` | `Input files/models/`, `Input files/requirements/`, `Input files/standards/` | `Output files/power-query/` |
| `pbi-tmdl` | `Input files/models/`, `Output files/dax/`, `Output files/power-query/` | `Output files/tmdl/` |
| `pbi-performance` | `Input files/models/`, `Input files/benchmarks/`, `Output files/dax/`, `Output files/tmdl/` | `Output files/performance/` |
| `pbi-naming` | `Input files/models/`, `Input files/standards/`, `Output files/dax/`, `Output files/power-query/`, `Output files/tmdl/` | `Output files/reviews/` |
