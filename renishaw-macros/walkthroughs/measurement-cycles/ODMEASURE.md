# O6007 - ODMEASURE

## Purpose
Brief: This macro supports **odmeasure** on the Smart Machine Tool MINI using a Fanuc 0i-MF control.

## Machine Context
- Machine: Smart Machine Tool MINI
- Control: Fanuc 0i-MF
- Units/offset behavior depends on active Renishaw settings, current work offset, and active tool length values.

## Step-By-Step G-code Walkthrough
| Step | Source | Explanation |
| --- | --- | --- |
| 1 | `2: <ODMEASURE>(O6007)` | Shop-level wrapper declaration for this cycle. |
| 2 | `3: (SMART MACHINE TOOL MINI / FANUC 0I-MF)` | Comment/documentation line: SMART MACHINE TOOL MINI / FANUC 0I MF. |
| 3 | `4: (PURPOSE: ODMEASURE)` | Comment/documentation line: PURPOSE: ODMEASURE. |
| 4 | `5: (DETAILS: walkthroughs/measurement-cycles/ODMEASURE.md)` | Comment/documentation line: DETAILS: walkthroughs/measurement cycles/ODMEASURE.md. |
| 5 | `6: (SAFE START: RETURN Z, CANCEL MODES, THEN PAUSE)` | Comment/documentation line: SAFE START: RETURN Z, CANCEL MODES, THEN PAUSE. |
| 6 | `7: G91G28Z0.` | Sets incremental positioning mode. Returns axis/axes toward machine reference position. |
| 7 | `8: G40G90G80G94` | Cancels cutter radius compensation. Sets absolute positioning mode. Cancels canned cycle mode. Feed per minute mode. |
| 8 | `9: M00` | Program stop for operator action/check. |
| 9 | `11: (LOAD PROBE TOOL AND MOVE TO START POSITION)` | Comment/documentation line: LOAD PROBE TOOL AND MOVE TO START POSITION. |
| 10 | `12: T1` | Executes macro-specific calculation or control logic. |
| 11 | `13: G0G90G54X0.Y0.` | Rapid positioning move. Sets absolute positioning mode. |
| 12 | `14: G43Z200.H1` | Applies tool length compensation. |
| 13 | `16: (START PROBE, THEN POSITION ABOVE FEATURE)` | Comment/documentation line: START PROBE, THEN POSITION ABOVE FEATURE. |
| 14 | `17: G65P9832(PROBE ON)` | Calls macro O9832 (REN PROBE START) with the supplied arguments. |
| 15 | `18: G04X1.` | Executes macro-specific calculation or control logic. |
| 16 | `19: G5.1Q0` | Turns off AI contour control mode. |
| 17 | `20: G65P9810Z100.F2500` | Calls macro O9810 (REN PROTECTED POSN) with the supplied arguments. |
| 18 | `21: G65P9810Z20.` | Calls macro O9810 (REN PROTECTED POSN) with the supplied arguments. |
| 19 | `23: (MEASURE O.D. FEATURE AND STORE RESULT)` | Comment/documentation line: MEASURE O.D. FEATURE AND STORE RESULT. |
| 20 | `24: G65P9814D130.0S2Z-15.` | Calls macro O9814 (REN BORE/BOSS) with the supplied arguments. |
| 21 | `25: #580=#138` | Updates macro variable values used later in the cycle logic. |
| 22 | `27: (RETRACT, STOP PROBE, AND FINISH)` | Comment/documentation line: RETRACT, STOP PROBE, AND FINISH. |
| 23 | `28: G65P9810Z50.` | Calls macro O9810 (REN PROTECTED POSN) with the supplied arguments. |
| 24 | `29: G65P9810Z100.` | Calls macro O9810 (REN PROTECTED POSN) with the supplied arguments. |
| 25 | `30: G65P9833(PROBE OFF)` | Calls macro O9833 (REN PROBE STOP) with the supplied arguments. |
| 26 | `31: G04X1.` | Executes macro-specific calculation or control logic. |
| 27 | `32: G91G28Z0.` | Sets incremental positioning mode. Returns axis/axes toward machine reference position. |
| 28 | `33: M30` | End of program and rewind/reset. |
