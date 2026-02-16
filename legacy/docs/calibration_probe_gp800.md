# Probe Calibration (GP-800)

This procedure will be derived from the GP-800 PDF plus our available artifacts:
- Master ring
- Exact-length test bar

## Inputs required
- GP-800 datasheet values (ball size, travel limits, etc.) from docs/sources/GP-800_Probe.pdf
- Operator-defined SAFE_Z_MACHINE
- A known stable mounting method for the master ring

## Outputs (stored in persistent variables)
- Effective stylus radius (#540)
- Effective stylus length (#541)
- Optional XY offsets if required (#542/#543)

## Implementation note for Kilo
- Use the PDF to extract nominal stylus/ball size and any travel constraints.
- Provide an operator step-by-step that uses the master ring and test bar to compute effective values.