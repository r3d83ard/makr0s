# O#### — <Macro Name>

## Purpose
Explain what this macro does in one paragraph.

## Preconditions (Required machine state)
- Spindle state:
- Coolant state:
- Modal requirements (G90/G94/G40/G80 etc.):
- SAFE_Z_MACHINE must be set: Yes/No

## Inputs (Macro arguments)
List each argument (A/B/C/…):
- A = ...
- B = ...
Include defaults, valid ranges, and units.
 - Argument locals used match Fanuc G65 mapping (A=#1, B=#2, C=#3, I=#4, J=#5, K=#6, D=#7, E=#8, F=#9).
 - Scratch locals use #10–#33 only.

## Outputs
- Variables written (local/common/persistent)
- Offsets written (WCS/tool offsets), if any
- Logs updated (#580–#599)

## Safety checks and failure modes
- Skip precheck behavior:
- Bounded stroke behavior:
- Retract behavior:
- Alarm codes/messages:

## Fanuc syntax constraints
- All axis addresses use X# / Y# / Z# without brackets. Computations must be done on separate lines.

## Motion blocks
- All axis addresses use X# / Y# / Z# without brackets. Computations must be done on separate lines.

## Step-by-step flow (operator/comprehension view)
1) ...
2) ...
3) ...

## G/M code explainer (every code used)
- G__ : ...
- M__ : ...
Also list any special system variables or macro functions used.

## Variable usage summary
- Local (#1–#33):
- Persistent (#500–#999):
