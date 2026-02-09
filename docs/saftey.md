# Safety Rules for Probing Macros (Fanuc 0i-MF Plus)

This document defines **non-negotiable safety rules** for all probing macros in this repo.

---

## Always-on probe constraint
- Probe enable is **always-on** (wired to ground).
- Macros must be safe **without** probe arming/disarming logic.
- **Do not use** probe-enable M-codes (e.g., M111/M112) in this library.

---

## Skip behavior (confirmed on this machine)
- Skip input is shared between the spindle probe and tool setter (Skip0 / PMC F0122.0).
- Skip does **not** interrupt normal G0/G1 motion.
- Skip is only acted upon during **G31** skip moves (confirmed).

**Policy:**
- Never use **G31** in normal machining programs—only inside this probing library.

---

## SAFE_Z policy (operators in inches)
We want operators to work in inches while keeping the system ready for metric support later.

### Canonical SAFE_Z variables
- **`#526 SAFE_Z_MACHINE_IN`**  
  - Operator-facing **inches**
  - Used for all **G53 retract moves**
- **`#527 SAFE_Z_MACHINE_MM`**  
  - Internal mirror in **mm** (computed as `#526 * 25.4`)
  - Reserved for future metric mode support

### Setting SAFE_Z (operator workflow)
- Operators should set SAFE_Z using the helper macro (planned): **O9803**
  - Input: `A = safe Z in inches (machine coordinate)`
  - Stores:
    - `#526 = A`
    - `#527 = A * 25.4`

### Retract rule (mandatory)
- Any macro that retracts to safe Z must retract using:
  - `G53 G0 Z[#526]`
- If `#526 == 0` (unset): the macro must **hard-fault** (alarm/stop) rather than moving blindly.

---

## Using captured skip position (measurement truth)
For probing results, macros must use the captured skip-position system variables after G31:
- `#5061` = X skip position
- `#5062` = Y skip position
- `#5063` = Z skip position

**Note:** Captured skip position may differ slightly from the displayed axis position after the move stops due to servo/processing delay. Macros must treat `#506x` as the measurement truth.

---

## Required safety checks (mandatory for any macro that executes G31)

### 1) Skip must be inactive before probing (precheck)
- If skip is active before a probing stroke: **stop/alarm** (“skip already active”).

**Implementation note:**
- Macro B typically cannot read PMC bit `F0122.0` directly.
- If a macro-accessible skip-state method is available later, implement this check.
- If not available, enforce this safety by:
  - requiring the operator to ensure the probe/toolsetter is not already triggered before running probing cycles, and
  - relying on bounded G31 strokes + deterministic fault handling (below).

### 2) Bounded probing stroke (software overtravel cap)
- Every G31 probing move must have a maximum allowed travel distance (software overtravel).
- If no trigger occurs within that distance: **stop/alarm** (“no trigger detected”).
- Use configuration stroke caps:
  - `#532 PROBE_MAX_STROKE` for spindle probe strokes
  - `#533 TS_MAX_STROKE` for tool setter strokes

### 3) Post-trigger recovery (retract + sanity)
After a trigger:
- Retract immediately to safe Z:
  - `G53 G0 Z[#526]`
- If SAFE_Z is unset (`#526 == 0`): **hard-fault** (do not attempt motion).
- If skip state is readable in macro logic:
  - verify skip returns inactive; if not: **stop/alarm** (“skip stuck”).

### 4) Modal state hygiene (never leave the machine “weird”)
Each probing macro must either:
- restore modals to prior state, **or**
- explicitly set safe baseline modes before/after probing.

Minimum expectations:
- No canned cycle active (cancel if needed)
- No cutter compensation active
- Return to **G90** if the macro used **G91**
- Exit cleanly with `M99`

---

## Operator commissioning requirements
- First run all probing macros in a **safe area in air** during commissioning.
- Keep feed/rapid overrides conservative until validated.
- Always verify SAFE_Z is set (via O9803) before running any probing motion macros.