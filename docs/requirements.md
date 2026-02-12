# Requirements & Implementation Plan (Architect-Owned)

This file defines the build order and acceptance tests. **Code mode should implement exactly what is specified here.**

## Repo conventions (must follow)
- Every macro program `macros/**/O####.nc` MUST have a matching explainer `docs/macros/O####.md`.
- Every G-code and M-code used inside a macro MUST be explained in comments in the `.nc` file.
- Canonical machine facts live in `docs/machine_facts.md`. If anything conflicts, update that doc first.
- **Rename any misspelled `docs/saftey.md` to `docs/safety.md` immediately** and update references.

### Repo acceptance
- Repo contains no `X[`, `Y[`, `Z[` in any `.nc` file.

---

## Global macro coding constraints (Fanuc syntax)
- **No bracketed axis words in any motion block (G0/G1/G31/G53).** Use plain `X#nn`, `Y#nn`, `Z#nn` or numeric literals. If computation is needed, store into a temp variable first, then use `X#temp` / `Y#temp` / `Z#temp`.
- **No `IF...THEN`** (use `IF...GOTO`).
- **No nested parentheses in comments** (single `(` and `)` only).
- **M19 before any G31** (or before any feed move section that includes G31).
- **G65 argument mapping must follow the table in `AGENTS.md`; D is `#7`, not `#4`.**
- **Reserve `#1–#9` for args; scratch locals must be `#10–#33` only.**
- **No locals above `#33`.**

---

## Alarm + messaging standard (DECISION — lock this in)
- **Hard faults:** use `#3000 = <code> (message)` (alarm + stop).
- **Informational / training messages:** use `#3006 = 1 (message)` ONLY when `#501 (LIB_VERBOSE) != 0`.

---

## Skip / probing data standard (DECISION — lock this in)
- Do NOT attempt to read PMC bit addresses directly in Macro B (e.g., `F0122.0`).
- For any probing/skip move result, read the captured skip position from **system variables**:
  - `#5061` = X skip position (confirmed via commissioning test)
  - `#5062` = Y skip position (confirmed)
  - `#5063` = Z skip position (confirmed)
- Expect small differences between `#506x` and the current position display due to response/processing delay; macros must treat `#506x` as the measurement truth.

---

## SAFE_Z policy (DECISION — operators use inches)
Operators will work in inches. SAFE_Z is stored as:
- `#526 SAFE_Z_MACHINE_IN` (operator-facing; **inches**; machine coordinate; used for `G53` retract)
- `#527 SAFE_Z_MACHINE_MM` (internal mirror; **mm**; computed as `#526 * 25.4`)

**Rule:**
- Motion macros must retract using `G53 G0 Z#526`.
- Operators should set SAFE_Z using **O9803** (inches input). Operators should not edit `#527` directly.

---

## Persistent variable map (must match `docs/variable_map.md`)
**Persistence rule:** use `#500–#999` only for persistent storage on this machine.

### Key variables used in Phases 1–2
- `#500` LIB_VERSION
- `#501` LIB_VERBOSE (1=messages on, 0=off)
- `#510` UNITS_MODE (1=inch, 2=mm)
- `#511` LAST_ERROR_CODE
- `#512` LAST_ALARM_CODE
- `#520–#525` X/Y/Z min/max in mm (envelope)
- `#526` SAFE_Z_MACHINE_IN (machine coordinate safe Z in inches; used for G53 retract)
- `#527` SAFE_Z_MACHINE_MM (mm mirror; computed as #526 * 25.4)
- `#530` PROBE_SEEK_FEED
- `#531` PROBE_RETRACT_FEED
- `#532` PROBE_MAX_STROKE
- `#533` TS_MAX_STROKE
- `#534` MAX_RETRIES
- `#585` LAST_STATUS (**1 = OK**, negative = error code)

---

## Phase 0 — Repo + docs scaffolding
### Tasks
- [ ] `AGENTS.md` exists and is followed.
- [ ] `docs/machine_facts.md` reflects confirmed facts (travel limits in mm, skip behavior, persistence, etc.).
- [ ] `docs/variable_map.md` exists and matches the persistent blocks above.
- [ ] `docs/safety.md` exists and defines invariants (skip rules, safe retract rules, modal hygiene).
- [ ] `docs/macros/_TEMPLATE.md` exists.

### Acceptance
- Kilo can answer project questions by referencing these docs without re-asking for core facts.

---

## Phase 1 — Core library utilities (implement O9800 and O9802 first, then O9803)
**Goal:** define and implement initialization + alarm/retract utilities before any probing motion.

### 1.1 Documentation tasks (Architect mode)
1) Update `docs/variable_map.md` (if needed) so O9800/O9802/O9803 variable usage is explicit and consistent:
   - LIB_VERSION, UNITS_MODE, VERBOSE
   - SAFE_Z_MACHINE_IN + SAFE_Z_MACHINE_MM mirror
   - Default feeds and stroke caps
   - LAST_* logging rules (especially `#585`)
2) Create `docs/macros/O9800.md` from `docs/macros/_TEMPLATE.md`:
   - Purpose, inputs/outputs, required machine state
   - Explicit list of every G/M code O9800 will use (or confirm none)
   - Variable usage map (local/common/persistent)
3) Create `docs/macros/O9802.md` from `docs/macros/_TEMPLATE.md`:
   - Purpose, inputs/outputs, required machine state
   - Explicit list of every G/M code O9802 will use
   - Variable usage map (local/common/persistent)
4) Create `docs/macros/O9803.md` from `docs/macros/_TEMPLATE.md`:
   - Purpose, inputs/outputs, required machine state
   - Explicit list of every G/M code O9803 will use (expected: none)
   - Variable usage map (local/common/persistent)

### 1.2 O9800 behavior specification (NO MOTION)
**File:** `macros/core/O9800.nc`

Rules:
- **No axis motion** (no G0/G1/G31). No spindle/coolant M-codes.
- Initialize defaults **only if unset** (`#0`); never overwrite non-zero configured values.
- Set library version:
  - `#500 = 9800.01` (or chosen version constant)
- Defaults (only if unset):
  - `#501` verbose default = 1
  - `#510` units default = 1 (inch). Validate: if not 1 or 2 → set error status and alarm (#3000).
  - `#530` probe seek feed default: 10.0 (inch) or 254.0 (mm)
  - `#531` retract feed default: 50.0 (inch) or 1270.0 (mm)
  - `#532` probe max stroke default: 0.050 (inch) or 1.27 (mm)
  - `#533` toolsetter max stroke default: 0.200 (inch) or 5.08 (mm)
  - `#534` max retries default: 3
- **SAFE_Z handling (inches-based):**
  - Do NOT overwrite `#526` or `#527`.
  - If `#526` (SAFE_Z_MACHINE_IN) is unset (`#0`), do NOT hard-fault in O9800.
  - Instead set `#585 = -526` and (if verbose) display `#3006` telling operator to run **O9803** to set SAFE_Z in inches.
- Status logging:
  - On success: set `#585 = 1`
  - On non-fatal missing SAFE_Z: `#585 = -526`
- Optional message:
  - If `#501 != 0`, may use `#3006` for “init complete” / “SAFE_Z not set” notices.

### 1.3 O9802 behavior specification (common error + safe retract)
**File:** `macros/core/O9802.nc`

Purpose:
- Centralized “fail safely” macro: log error context, retract if possible, then raise deterministic alarm.

Inputs (recommended):
- `A` = internal error code (e.g., 900-series)
- `B` = alarm code to raise via `#3000` (can match A)
- Optional: `C/D` = context (axis id, direction, etc.)

Rules:
- Log first:
  - `#511 = <internal error code>`
  - `#512 = <alarm code>`
  - `#585 = -<internal error code>` (negative)
- **Safe retract behavior (ONLY macro allowed to retract-then-alarm):**
  - If `#526 (SAFE_Z_MACHINE_IN) != 0`, retract using machine coordinates:
    - `G53 G0 Z#526`
  - If `#526 == 0`, do not move.
- O9802 must not rely on reading Skip0 state (no PMC-bit reads).
- Raise alarm using the repo standard:
  - `#3000 = <alarm code> (clear message with context)`
- Modal hygiene:
  - Document every modal changed inside O9802 and restore to a safe expected state on exit where appropriate.

### 1.4 O9803 behavior specification (Set SAFE_Z from inches — NO MOTION)
**File:** `macros/core/O9803.nc`

Purpose:
- Operator helper to set SAFE_Z in **inches** while also storing an internal **mm mirror** for future metric support.

Inputs:
- `A` = SAFE_Z_MACHINE_IN (safe Z in **inches**, machine coordinate)

Rules:
- No axis motion (no G0/G1/G31). No spindle/coolant M-codes.
- Validate input:
  - If `A` is missing/zero → alarm via `#3000` with a clear message.
  - Allow negative values (machine Z can be negative down).
- Store:
  - `#526 = A` (SAFE_Z_MACHINE_IN)
  - `#527 = A * 25.4` (SAFE_Z_MACHINE_MM mirror)
- Set status/log:
  - `#585 = 1` (OK)
- Optional message:
  - If `#501 != 0`, `#3006 = 1` confirming the stored values.

### Phase 1 Acceptance tests
- O9800:
  - Populates defaults in #500–#599 **only when unset**.
  - Performs **no axis motion** and uses **no M-codes**.
  - Leaves existing persistent values unchanged (except `#585` status).
  - If SAFE_Z unset (`#526==0`), does **not** hard-alarm; sets `#585 = -526` and (if verbose) issues a `#3006` reminder to run O9803.
- O9802:
  - Logs `#511/#512/#585` consistently.
  - If SAFE_Z is set (`#526!=0`) and current Z is below safe, performs `G53 G0 Z[#526]`.
  - If SAFE_Z is unset (`#526==0`), performs no motion.
  - Raises `#3000` with deterministic alarm code/message.
  - Never uses probe-enable M-codes (M111/M112) or attempts PMC-bit reads.
- O9803:
  - Stores `#526 = A` (inches) and `#527 = A * 25.4` (mm mirror).
  - Performs no axis motion and no M-codes.
  - Alarms with `#3000` if A is missing/zero.

---

## Phase 2 — Probing primitives (controlled motion)
**Goal:** implement one safe probing primitive (O9810) using G31 + #506x capture.

**Global constraints (Phase 2):**
- Any macro that executes `G31` must issue `M19` immediately before the first probing stroke (or immediately before any feed motion section).
- The per-macro explainer must list `M19` under “G/M code explainer.”

### 2.1 Documentation tasks
- [ ] Create `docs/macros/O9810.md` from template with:
  - Inputs/outputs, machine state, full G/M code list
  - Explanation that measured position comes from `#5061–#5063`
  - Explicit SAFE_Z rule: retract uses `G53 G0 Z[#526]`

### 2.2 O9810 behavior (first primitive)
**File:** `macros/probe/O9810.nc`

Call interface (Macro arguments):
- `A` = axis (1 = X, 2 = Y, 3 = Z) **required**
- `B` = stroke distance (**positive**, current units) **required**
- `C` = mode (1 = probe, 2 = toolsetter) **required**; selects max stroke source
- `D` = feed (0 = use `#530`, otherwise use `D`)

Minimum features:
- Pre-positioning policy: caller is responsible for being at a safe start point.
- Use bounded incremental G31 strokes (recommend `G91` strokes, then return `G90` on exit).
- Use `#532` (probe max stroke) or `#533` (toolsetter max stroke) depending on mode argument.
- After G31, capture hit position:
  - X hit = `#5061`, Y hit = `#5062`, Z hit = `#5063`
- Retract to safe Z:
  - If `#526 == 0` → call O9802 (alarm: safe Z not set)
  - Else retract with `G53 G0 Z#526`
- Error/alarm codes (via O9802):
  - SAFE_Z unset: `A=920`, `B=920`, message `SAFE_Z NOT SET`
  - No trigger within max stroke: `A=921`, `B=921`, message `NO TRIGGER`
  - Skip stuck (if implemented later): `A=922`, `B=922`, message `SKIP STUCK` (**not used in Phase 2**)
- Log results into `#580–#584` for commissioning:
  - `#580` LAST_RUN_ID / counter (increment each call)
  - `#581` LAST_INPUT_A (axis)
  - `#582` LAST_INPUT_B (stroke)
  - `#583` LAST_INPUT_C (mode)
  - `#584` LAST_RESULT_2 (hit position value from `#5061/#5062/#5063`)
- Modal state: entry any; exit `G90` and `G94`.

### Phase 2 Acceptance tests
- Air test:
  - No trigger within max stroke → macro faults via O9802 with alarm `A/B=921`.
- SAFE_Z unset:
  - If `#526==0`, macro faults via O9802 with alarm `A/B=920`.
- Trigger test:
  - Manual trigger during G31 stops early, stores `#506x` values, retracts to safe Z, exits cleanly.
- Modal hygiene:
  - Macro returns to `G90` and `G94` on exit if it uses `G91` or changes feed mode.

---

## Phase 2.5 — Signed-direction probing primitive (O9812)
**Goal:** add a signed-direction probing primitive to support negative strokes and center-finding without modifying O9810.

### 2.5.1 O9812 scope + constraints
- **Interface:**
  - `A` = axis (1=X, 2=Y, 3=Z)
  - `B` = stroke distance (**signed**; + for +X/+Y/+Z, - for -X/-Y/-Z)
  - `C` = mode (1 = probe uses `#532`, 2 = toolsetter uses `#533`)
  - `D` = feed override (0 uses `#530`)
- **Error codes (via O9802):**
  - SAFE_Z unset: `920`
  - AXIS invalid: `923`
  - MODE invalid: `924`
  - STROKE zero: `925`
  - NO TRIGGER: `921`
  - SKIP ACTIVE AT START / IMMEDIATE HIT: `926`
  - SKIP STUCK AFTER RETRACT: `927`
- **Probing primitive:** O9812 executes its own bounded G31 stroke with **signed** direction.
- **Safety + compatibility:**
  - `M19` immediately before first G31 in O9812 (or in a called macro; document which).
  - **No `IF...THEN`** (GOTO/label only), **no nested parentheses** in comments.
  - No bracketed axis-word expressions.

### Phase 2.5 Acceptance tests
- Positive and negative strokes complete with correct sign and bounded travel.
- NO TRIGGER raises O9802 `A/B=921`.
- SKIP active at start or immediate hit raises O9802 `A/B=926`.
- SKIP stuck after retract raises O9802 `A/B=927`.
- Modal hygiene: exits `G90` and `G94` (and cancels any temporary modals used).

---

## Phase 3 — Calibration (probe only)
**Goal:** implement probe calibration macro **O9820** only. Tool setter calibration (O9830) is **deferred**.

### 3.1 O9820 scope + constraints
- **Outputs stored:**
  - `#540` stylus radius (effective; units per `#510`)
  - `#541` stylus length / Z trigger offset (effective; units per `#510`)
- **Calibration artifacts:** master ring + test bar (both available).
- **Probing primitive:** **O9810 only** (no direct `G31` motion in O9820).
- **Safety + compatibility:**
  - `M19` immediately before each probing sequence (O9810 handles M19 before each G31).
  - Bounded strokes, safe retracts, and O9802 alarms on failure.
  - **No `IF...THEN`** (GOTO/label only), **no nested parentheses** in comments.
- **Coordinates:** use machine coordinates for all calibration math; **do not write WCS** in Phase 3.

### 3.2 Calibration method (summary)
- **Ring calibration (XY, stylus radius):**
  - If `C/D` provided, treat them as ring center X/Y **machine coordinates**.
  - If `C/D` are zero, find ring center by probing **X- / X+ / Y- / Y+** with **O9812** and averaging hit positions (`#5061/#5062`).
  - Compute measured diameters:
    - `Dx = Xplus - Xminus`, `Dy = Yplus - Yminus` (from `#5061/#5062` hits).
  - Effective stylus radius:
    - `Rx = (B - Dx) / 2`, `Ry = (B - Dy) / 2`, then `#540 = (Rx + Ry) / 2`.
- **Z calibration (stylus length / trigger offset):**
  - Use test bar length **L** and reference surface machine Z **Zref**.
  - Probe Z to the reference surface with O9810 to get `Zhit` (`#5063`).
  - Effective stylus length / trigger offset: `#541 = (Zref + L) - Zhit`.
- **Units:** operator inputs in inches; O9820 converts to current units when `#510 = 2`.

### Phase 3 Acceptance tests
- Ring: three repeated X+/X-/Y+/- cycles yield `#540` repeatability within **±0.0002 in** (±0.005 mm).
- Z: three repeated Z touches yield `#541` repeatability within **±0.0002 in** (±0.005 mm).
- Safety: all probing uses O9810, M19 precedes each G31, bounded strokes enforced, safe retracts occur.

---

## Phase 4 — WCS + tool offsets
- O9840: write G54.1 Pn (selectable Pn)
- O9850: write tool length geometry offset

Acceptance:
- Writes correct offsets without disturbing unrelated offsets.
- Documentation explicitly lists which offsets are touched.

---

## Definition of Done (per macro)
For every macro O####:
- [ ] `macros/**/O####.nc` exists
- [ ] `docs/macros/O####.md` exists (from template)
- [ ] Every G/M code explained in `.nc` comments
- [ ] Safety checks implemented (if macro uses G31)
- [ ] Inputs/outputs documented and match code
- [ ] Acceptance tests in this file are satisfied on-machine
