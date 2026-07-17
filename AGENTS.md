# AGENTS.md — jabil-motor-semantico

## Project

Single-file semantic motor for DEXCOM downtime code normalization. Web app (HTML/CSS/JS) + SQL backend. Deployed to GitHub Pages.

**MVP scope**: 247 DEXCOM codes (TSA, DSD05, Fast Line). SQL Server 2016+ compatible for Power Apps integration.

## Key Files

| File | Purpose |
|------|---------|
| `motor-gui-lite.html` | **Main deliverable** — production GUI. 720 lines, zero inline event handlers, semantic HTML, event delegation. Synced to `index.html` for GitHub Pages. |
| `motor_normalizacion.sql` | SP `sp_estandarizar_downtime` (3 search strategies: exacta 100%, parcial 75%, fuzzy 50%). View `v_referencia_dexcom`. 6 test cases. Top 3 results per query. |
| `schema.sql` | Table defs: `codigos_historial` (flat, linea_id 1–3), `tbl_cliente`, `tbl_linea_produccion`. Not required for web; documented for Power Apps. |
| `index.html` | **GitHub Pages entry point** — synced copy of `motor-gui-lite.html` via cherry-pick. Always keep them in sync. |

## Code Style

**Strict rules** (enforced, not suggestions):
- Comments: **lowercase, no accents, no spaces** (e.g. `//evento listeners` not `// Event Listeners`)
- No emojis anywhere
- No inline event handlers (`onclick`, `oninput`) — use `addEventListener` with event delegation
- Template literals over string concat
- Arrow functions, `let`/`const`, no `var`
- Semantic HTML: `<header>`, `<main>`, `<aside>`, `<footer>`
- No `!important` in CSS

**Why**: User sees refactored code and expects human quality; comments signal "this was AI", lowercase signals "human wrote this".

## Data & Mapping

**Line IDs** (hardcoded in SQL):
- `linea_id = 1` → Fast Line (87 codes)
- `linea_id = 2` → TSA (73 codes)
- `linea_id = 3` → DSD05 (86 codes)

**Search behavior**:
- Filters by `linea_id` at query time — **hermetic per line** (no cross-line leakage)
- Scoring: equivalences (`EQS` object in JS) > description > code substring
- Returns TOP 3, ordered by confidence DESC

**Important**: Frontend data (`LINEAS`, `EQS`) drives MVP. SQL is for Power Apps future integration; web doesn't call it.

## Deployment

**GitHub Pages**: Live at https://jester358.github.io/jabil-motor-semantico/

Auto-synced via:
```bash
cp motor-gui-lite.html index.html
git add index.html && git commit -m "sync: index.html..." && git push
```

Deployment is **automatic on push**; no build step needed.

## Git Workflow

**Branch strategy**:
- `master` → production, always deployable
- `feature/3m-asist-boston` → in progress for next clients (3M + ACIST)

**Commit conventions**: verb-first, lowercase, no AI attribution.
- `feat: add X`
- `fix: resolve Y`
- `refactor: clean Z`
- `style: comentarios en minusculas` (code style only)
- `docs: update README`
- `sync: index.html con motor-gui-lite.html cambios`

No "Co-Authored-By". Ever.

## Frontend Architecture (Motor Logic)

**Three-tier search** in `buscar()` function:

1. **Exact match** on equivalence: `EQS[code]` contains user input (100% confidence)
2. **Partial match** per word: split input by space, filter `EQS` entries by word membership (75%)
3. **Fuzzy match** on description: `DESC.includes(input)` (50%)

**Line filtering is hermetic**: before each strategy, filter `LINEAS[selectedLine]` — results only from that line's codes.

**History**: manually managed in-memory array; clears on page reload (MVP).

## SQL Backend (Power Apps Readiness)

**Not yet called by web; documented for Noé's integration.**

Procedure signature:
```sql
EXEC sp_estandarizar_downtime @descripcion VARCHAR(255), @linea_id INT
```

Returns 3-column result set: `codigo`, `descripcion`, `modulo`, `confianza_pct`, `metodo`.

**Quirks**:
- `codigos_historial` is the single source of truth (flat table)
- Temporary table `#candidatos` accumulates all 3 strategies; returns TOP 3 at end
- No JOINs to `tbl_codigo_falla` or `tbl_equivalencias` (those don't exist in runtime)
- Uses `STRING_SPLIT()` for partial matching (SQL 2016+)

## Common Mistakes

1. **Editing `motor-gui.html` instead of `motor-gui-lite.html`**: Lite is production. GUI is old archive.
2. **Forgetting to sync `index.html`**: GitHub Pages reads `index.html`, not `motor-gui-lite.html`.
3. **Copying SQL logic into JS**: They're different contexts. SQL is future (Power Apps); JS is live.
4. **Adding capitalization or accents to comments**: User specifically said lowercase + no accents. Non-negotiable.
5. **Using `onclick` or inline handlers**: Use `addEventListener` + event delegation pattern.

## Pending (Not This Repo)

- 3M glosario (28 codes) — awaiting delivery from Uriel
- ACIST (PNG only, needs xlsx) — awaiting Uriel
- STRIKER/MEDTRONIC clarification — awaiting Noé (lunes)
- BOSTON glosario — awaiting Uriel

These are **out of scope** for current session; tracked in `/Desktop/JABIL/Mapa_Clientes_*.xlsx`.

## No Tests, No Build

This is a **functional MVP**. No test suite, no bundler, no dev server. Works as-is.

If adding new clients later:
1. Extract codes + descriptions
2. Add to `LINEAS[linea]` array in HTML
3. Add equivalences to `EQS` object
4. Test filtering by selecting line (inspect element to verify no cross-line codes)
5. Sync to `index.html`
6. Commit + push (auto-deploys)
