# Safety Rules for Probing Macros

## Always-on probe constraint
Probe enable is always-on (wired). Macros must be safe without probe arming/disarming.

## Skip behavior
Skip input is shared between spindle probe and tool setter; used during G31 only (confirmed).
Never use G31 in normal machining programs—only inside probing library macros.

## Required macro safety checks (mandatory in any macro that executes G31)
1) **Skip must be inactive before probing**
   - If skip is active before a probing stroke: stop/alarm ("skip already active").
2) **Bounded probing stroke**
   - Every G31 move must have a maximum allowed travel distance (software overtravel).
   - If no trigger occurs in that distance: stop/alarm ("no trigger detected").
3) **Post-trigger recovery**
   - Retract to SAFE_Z_MACHINE (or a safe clearance plane).
   - Verify skip returns inactive; if not: stop/alarm ("skip stuck").
4) **Modal state hygiene**
   - Restore or explicitly set required modes (no canned cycles, no cutter comp, etc.).
   - Exit cleanly with M99.

## Operator requirements
- Run probing macros in a safe area first (air cuts) during commissioning.
- Keep feed/rapid overrides conservative until the library is validated.