# Macro Index (Planned O-number Map)

> This is the planned map for the new library. Adjust as the library stabilizes.

## Core / safety
- O9800: Library init + safety gate (mode checks, skip checks, safe-Z handling)
- O9801: Units/limits utilities (inch↔mm, travel caps) (optional)
- O9802: Common error/alarm handler + retract/escape

## Spindle probe (GP-800)
- O9810: Basic single-surface touch primitives (Z-, Z+, X±, Y±)
- O9811: Two-point surface find (midpoint / width)
- O9820: Spindle-probe calibration (ring + test bar)

## Tool setter
- O9830: Tool setter position calibration (X/Y/Z trip in machine coords)
- O9831: Tool length measure (single tool)
- O9832: Tool length update batch (optional later)

## Work offsets (WCS)
- O9840: Update WCS G54.1 Pn (selectable Pn)
- O9841: Update WCS G54/G55… (optional later)

## Tool offsets
- O9850: Write tool length geometry offset
- O9851: Write tool length wear offset (optional later)

## Utilities/logging
- O9860: Persistent config read/write
- O9861: Last-run log snapshot