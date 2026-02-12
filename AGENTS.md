# Agent Instructions (Kilo / Codex)

These rules apply to ALL work in this repo, across Ask / Architect / Code / Debug modes.

## Non-negotiable coding rules
1) **Every G-code and M-code must be explained in comments** in the `.nc` macro file.
2) **One training/verification doc per macro**:
   - `macros/**/O####.nc` must have a matching `docs/macros/O####.md`
   - Use `docs/macros/_TEMPLATE.md` as the base.
3) Do not assume Renishaw/vendor probing macros exist or apply. We are building a new library from scratch.

## Machine facts source of truth
- Treat `docs/machine_facts.md` as canonical. If anything conflicts with it, update that doc first.

## Safety invariants (must be enforced in any probing macro that uses G31)
- Before any G31: verify Skip is NOT active (if it is, stop/alarm with a clear message).
- Every probing stroke must be **bounded** (max travel / timeout). Alarm if no trigger.
- After a trigger: retract to safe Z and verify Skip returns inactive. Alarm if stuck.
- Restore modal state and exit cleanly.

## Fanuc 0i Macro B Compatibility Rules (Hard Constraints)
- **Before any G31 (and any feed move if applicable), issue:** `M19` (SPINDLE ORIENT)
- **Do NOT** use `S` words (`S0`/`S###`) or `M5` to satisfy the spindle-command requirement.
- **Rationale:** EX1058 “AXES FEED START WITHOUT SPINDLE COMMAND” occurs unless `M19` is issued; verified on-machine.
- **No `IF...THEN` anywhere** (GOTO/label only).
- **No nested parentheses in comments** (single `(` and `)` only).
- **No bracketed axis words in any motion block (G0/G1/G31/G53).** Axis words must be plain `X#nn`, `Y#nn`, `Z#nn` or numeric literals. If computation is needed, compute into a temp variable first, then use `X#temp` / `Y#temp` / `Z#temp` (no brackets).
  - BAD: `G53 G0 Z[#526]`, `G31 X[#100] F#101`
  - GOOD: `#100 = #526` then `G53 G0 Z#100`; `#101 = #100` then `G31 X#101 F#102`

### Fanuc Macro B argument mapping (G65/G66)
A->#1
B->#2
C->#3
I->#4
J->#5
K->#6
D->#7
E->#8
F->#9

Hard rules:
- Do not assume alphabetical mapping.
- Do not use `#1–#9` as scratch variables in any macro that may be called with `G65` (they are reserved for args).
- Use scratch locals only from `#10–#33`.
- This control supports locals `#1–#33` only.

## Workflow expectations
- Ask mode: research and summarize, then write results into `docs/*.md`.
- Architect mode: write exact steps + acceptance tests in `docs/requirements.md` and per-macro docs.
- Code mode: implement one macro at a time + its doc, matching acceptance tests.
- Debug mode: diagnose failures and update docs/tests as needed.
