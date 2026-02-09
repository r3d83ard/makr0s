# makr0s
## Fanuc 0i-MF Plus Probing Macro Library (Smart Machine Tool MINI)

This repo contains a custom Macro B probing library built from scratch for:
- Machine: Smart Machine Tool MINI
- Controller: Fanuc 0i-MF Plus
- Probe: GP-800 (see `docs/sources/GP-800_Probe.pdf`)
- Tool setter: (no PDF available; calibrated using test bar)

## Start Here
1) Read: `docs/machine_facts.md`
2) Read: `docs/safety.md`
3) Review variable reservations: `docs/variable_map.md`
4) Follow operator setup/calibration:
   - `docs/calibration_probe_gp800.md`
   - `docs/calibration_toolsetter.md`

## Macro Documentation Rule
Every macro program has a matching explainer doc in `docs/macros/`:
- Example: `macros/probe/O9810.nc` -> `docs/macros/O9810.md`

## Macro Index
See `docs/macro_index.md` for the planned O-number map and purpose.

> Development note: Existing test macros O6000/O6001 were used during initial validation on-machine.
> This repo’s production library is intended to live in the O98xx range.