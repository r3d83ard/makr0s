# Requirements & Implementation Plan (Architect-Owned)

This file defines the build order and acceptance tests. **Code mode should implement exactly what is specified here.**

## Repo conventions (must follow)
- Every macro program `macros/**/O####.nc` MUST have a matching explainer `docs/macros/O####.md`.
- Every G-code and M-code used inside a macro MUST be explained in comments in the `.nc` file.
- Canonical machine facts live in `docs/machine_facts.md`. If anything conflicts, update that doc first.
- **Rename any misspelled `docs/saftey.md` to `docs/safety.md` immediately** and update references.

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

## Persistent variable map (must match `docs/variable_map.md`)
**Persistence rule:** use `#500–#999` only for persistent storage on this machine.

### Key variables used in Phases 1–2
- `#500` LIB_VERSION
- `#501` LIB_VERBOSE (1=messages on, 0=off)
- `#510` UNITS_MODE (1=inch, 2=mm)
- `#511` LAST_ERROR_CODE
- `#512` LAST_ALARM_CODE
- `#520–#525` X/Y/Z min/max in mm (envelope)
- `#526` SAFE_Z_MACHINE (machine coordinate safe Z; do not overwrite once set)
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

## Phase 1 — Core library utilities (implement O9800 and O9802 first)
**Goal:** define and implement initialization + alarm/retract utilities before any probing motion.

### 1.1 Documentation tasks (Architect mode)
1) Update `docs/variable_map.md` (if needed) so O9800/O9802 variable usage is explicit and consistent:
   - LIB_VERSION, UNITS_MODE, VERBOSE
   - SAFE_Z_MACHINE
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
- **SAFE_Z_MACHINE handling:**
  - Do NOT overwrite `#526`.
  - If `#526` is unset (`#0`), do NOT hard-fault in O9800.
  - Instead set `#585 = -526` and (if verbose) display `#3006` telling operator to set SAFE_Z_MACHINE.
- Status logging:
  - On success: set `#585 = 1`
  - On non-fatal missing SAFE_Z_MACHINE: `#585 = -526`
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
- **Safe retract behavior:**
  - If `#526 (SAFE_Z_MACHINE) != 0`, retract using machine coordinates:
    - `G53 G0 Z[#526]`
  - If `#526 == 0`, do not move.
- O9802 must not rely on reading Skip0 state (no PMC-bit reads in Phase 1).
- Raise alarm using the repo standard:
  - `#3000 = <alarm code> (clear message with context)`
- Modal hygiene:
  - Document every modal changed inside O9802 and restore to a safe expected state on exit where appropriate.

### Phase 1 Acceptance tests
- O9800:
  - Populates defaults in #500–#599 **only when unset**.
  - Performs **no axis motion** and uses **no M-codes**.
  - Leaves existing persistent values unchanged (except `#585` status).
  - If SAFE_Z_MACHINE unset, does **not** hard-alarm; sets `#585 = -526` and (if verbose) issues a `#3006` reminder.
- O9802:
  - Logs `#511/#512/#585` consistently.
  - If SAFE_Z_MACHINE is set and current Z is below safe, performs `G53 G0 Z[#526]`.
  - If SAFE_Z_MACHINE is unset, performs no motion.
  - Raises `#3000` with deterministic alarm code/message.
  - Never uses probe-enable M-codes (M111/M112) or attempts PMC-bit reads.

---

## Phase 2 — Probing primitives (controlled motion)
**Goal:** implement one safe probing primitive (O9810) using G31 + #506x capture.

### 2.1 Documentation tasks
- [ ] Create `docs/macros/O9810.md` from template with:
  - Inputs/outputs, machine state, full G/M code list
  - Explanation that measured position comes from `#5061–#5063`

### 2.2 O9810 behavior (first primitive)
**File:** `macros/probe/O9810.nc`

Minimum features:
- Pre-positioning policy: caller is responsible for being at a safe start point.
- Use bounded incremental G31 strokes (recommend `G91` strokes, then return `G90` on exit).
- Use `#532` (probe max stroke) or `#533` (toolsetter max stroke) depending on mode argument.
- After G31, capture hit position:
  - X hit = `#5061`, Y hit = `#5062`, Z hit = `#5063`
- Retract to safe Z:
  - If `#526 == 0` → call O9802 (alarm: safe Z not set)
  - Else retract with `G53 G0 Z[#526]`
- Log results into `#580–#584` as appropriate for debugging.

### Phase 2 Acceptance tests
- Air test:
  - No trigger within max stroke → macro faults via O9802 with deterministic alarm code.
- Trigger test:
  - Manual trigger during G31 stops early, stores `#506x` values, retracts to safe Z, exits cleanly.
- Modal hygiene:
  - Macro returns to `G90` on exit if it uses `G91`.

---

## Phase 3 — Calibration
- O9820: probe calibration using master ring + test bar (derive effective radius/center/length; store #540+)
- O9830: tool setter position calibration (store #550+)

Acceptance:
- Outputs stored in #540+ (probe) and #550+ (tool setter).
- Operator docs for calibration are complete and repeatable.

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