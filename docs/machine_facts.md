# Machine Facts (Canonical)

This file is the source of truth for Kilo/Codex planning and implementation.

## 1) Machine travel limits / soft limits
Source screen: SYSTEM -> PARAMETERS -> STORED STROKE CHECK (Limit 1+ / Limit 1-)

> Note: limits appear displayed in **mm** even though we program in inches.

Limits shown (mm):
- X: -2.000 to 602.000 mm  (≈ 604 mm range)
- Y: -452.000 to 2.000 mm (≈ 454 mm range)
- Z: -502.000 to 2.000 mm (≈ 504 mm range)

Converted travel (inches):
- X travel: 604 / 25.4 = 23.78 in
- Y travel: 454 / 25.4 = 17.87 in
- Z travel: 504 / 25.4 = 19.84 in

## Safe Z clearance plane (policy)
We will define a machine-coordinate safe Z clearance plane for probing.
Operator sets it by jogging to a known safe Z and recording POS -> MACHINE Z.
Store in persistent variable: SAFE_Z_MACHINE (see variable map).

## 2) Units
- Primary units: inches
- Library must also support metric via an internal units flag + conversion layer.

## 3) Macro variable persistence (confirmed)
OFFSET -> MACRO shows:
- #1–#33 available (local variables)
- #100–#199 available but NOT persistent across power cycle (confirmed #100 and #150 clear)
- #500–#999 available and persistent across power cycle (confirmed #500 persists)

## 4) Probe/tool setter skip behavior (confirmed)
- Skip0 PMC address: F0122.0
- Skip position is read from system variables #5061–#5063 (captured skip point after G31).
- Captured skip point may differ slightly from the current position display due to servo/processing delay; macros must use #506x values for measurement.
- Spindle probe and tool setter share this same Skip0 signal.
- Triggering probe/tool setter during normal G1 motion does NOT interrupt motion.
- G31 skip moves respond correctly to both probe and tool setter triggers.

## 5) Probe enable constraint (current hardware reality)
- Probe enable line is wired to ground; probe is always enabled when machine is on.
- We do not have the I/O unit required to enable/disable probe with M111/M112.
- Macros must NOT rely on probe on/off M-codes.

## 6) Probing feed/overtravel defaults (initial, conservative)
- Default G31 seek feed (inch): 10 ipm (≈ 254 mm/min)
- Default retract/backoff feed (inch): 50 ipm (≈ 1270 mm/min)

Software overtravel placeholders (inch):
- Spindle probe max stroke: 0.050"
- Tool setter max Z stroke: 0.200"

(These are placeholders; refine during calibration.)

## 7) Probe/tool setter calibration resources
- GP-800 probe PDF will be stored at: docs/sources/GP-800_Probe.pdf
- We have: master ring and an exact-length test bar.
- No tool setter PDF; tool setter calibration will be derived from on-machine measurement using test bar.