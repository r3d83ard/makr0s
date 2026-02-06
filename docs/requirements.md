# Requirements & Implementation Plan (Architect-Owned)

This file defines the build order and acceptance tests. Code mode should implement exactly what is specified here.

## Phase 0 — Repo + docs scaffolding
- [ ] AGENTS.md exists and is followed.
- [ ] machine_facts.md reflects confirmed facts.
- [ ] variable_map.md defines persistent blocks (#500–#999 only).
- [ ] safety.md defines invariants.

Acceptance:
- Kilo can answer questions by referencing these docs without re-asking.

## Phase 1 — Non-motion test macros (sanity)
Goal: validate Macro B, argument handling, persistence, messaging behavior.

- [ ] O9800.md written (spec only; no code yet)
- [ ] Implement one non-motion macro (if needed) that writes/reads persistent vars and uses #3006 behavior consistent with control.
- [ ] Ensure verbose flag (#501) gates optional messages.

Acceptance:
- Operator can run the test macro and see variables update in OFFSET->MACRO.

## Phase 2 — Core library utilities
Implement:
- O9800: init + safety gate (units defaults, verbose, common settings)
- O9802: common alarm handler + safe retract behavior

Acceptance:
- Calling O9800 initializes defaults without motion.
- Alarm handler produces deterministic alarm codes and logs LAST_STATUS variables.

## Phase 3 — Probing primitives (controlled motion)
Implement Z touch primitive (O9810) with:
- precheck skip inactive
- bounded G31 stroke
- retract + verify skip release
- logs + clear error codes

Acceptance:
- Air test passes (no trigger => alarms after max stroke).
- Manual trigger during G31 causes early stop and proper retract.

## Phase 4 — Calibration
- O9820: probe calibration using master ring + test bar (derive effective radius/center/length)
- O9830: tool setter position calibration (X/Y center + Z trip plane) using test bar

Acceptance:
- Outputs stored in #540+ (probe) and #550+ (tool setter).
- Operator docs for calibration are complete and repeatable.

## Phase 5 — WCS + tool offsets
- O9840: write G54.1 Pn (selectable)
- O9850: write tool length geometry offset

Acceptance:
- Writes correct offset without disturbing unrelated offsets.
- Includes explicit documentation of which offsets are touched.

## Definition of Done (per macro)
For every macro O####:
- [ ] `macros/**/O####.nc` exists
- [ ] `docs/macros/O####.md` exists (from template)
- [ ] Every G/M code explained in `.nc` comments
- [ ] Safety checks implemented (if macro uses G31)
- [ ] Inputs/outputs documented and match code