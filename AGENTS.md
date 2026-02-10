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

## Workflow expectations
- Ask mode: research and summarize, then write results into `docs/*.md`.
- Architect mode: write exact steps + acceptance tests in `docs/requirements.md` and per-macro docs.
- Code mode: implement one macro at a time + its doc, matching acceptance tests.
- Debug mode: diagnose failures and update docs/tests as needed.
