# Variable Map & Reservations

## Persistence rule on this machine
- Use #500–#999 for ALL persistent storage.
- Do not store persistent calibration/settings in #100–#199 (they clear on power cycle here).

## Library blocks (recommended reservation)
### Globals (persistent)
- #500  LIB_VERSION
- #501  LIB_VERBOSE (1=messages on, 0=off)
- #510  UNITS_MODE (1=inch, 2=mm)
- #511  LAST_ERROR_CODE (optional)
- #512  LAST_ALARM_CODE (optional)

### Machine envelope + safety (persistent)
- #520  X_MIN_MM
- #521  X_MAX_MM
- #522  Y_MIN_MM
- #523  Y_MAX_MM
- #524  Z_MIN_MM
- #525  Z_MAX_MM
- #526  SAFE_Z_MACHINE (store in MACHINE coords; store units as defined by UNITS_MODE or store explicit MM)

### Probing defaults (persistent)
- #530  PROBE_SEEK_FEED (in current units)
- #531  PROBE_RETRACT_FEED (in current units)
- #532  PROBE_MAX_STROKE (in current units)
- #533  TS_MAX_STROKE (in current units)
- #534  MAX_RETRIES

### Probe calibration outputs (persistent)
- #540  STYLUS_RADIUS (effective; units per UNITS_MODE)
- #541  STYLUS_LENGTH (effective; units per UNITS_MODE)
- #542  PROBE_XY_OFFSET_X (optional)
- #543  PROBE_XY_OFFSET_Y (optional)

### Tool setter calibration outputs (persistent)
- #550  TS_X_MACHINE
- #551  TS_Y_MACHINE
- #552  TS_Z_TRIP_MACHINE

### Last-run log (persistent)
- #580  LAST_RUN_ID / COUNTER (optional)
- #581  LAST_INPUT_A
- #582  LAST_INPUT_B
- #583  LAST_RESULT_1
- #584  LAST_RESULT_2
- #585  LAST_STATUS (1=OK, negative=error code)

## Notes
- Skip0 address (PMC): F0122.0 (shared probe + tool setter). Documented in docs/machine_facts.md.
- Macro B local argument convention: A->#1, B->#2, etc.