# Usage (Operator Overview)

This will be expanded as macros are implemented.

## Key ideas
- Probing uses Skip0 during G31 moves only.
- Probe is always enabled electrically; macros must be defensive (skip precheck, bounded stroke).

## Before running probing macros
- Verify SAFE_Z_MACHINE has been set.
- Verify calibration has been completed (probe + tool setter) if using offsets/tool-length writes.
- Set verbose mode (#501) as desired:
  - #501=1 messages on (commissioning)
  - #501=0 messages off (production)