# O6000 - PROBECALIBRATION

## Purpose
Brief: This macro supports **probecalibration** on the Smart Machine Tool MINI using a Fanuc 0i-MF control.

## Machine Context
- Machine: Smart Machine Tool MINI
- Control: Fanuc 0i-MF
- Units/offset behavior depends on active Renishaw settings, current work offset, and active tool length values.

## Step-By-Step G-code Walkthrough
| Step | Source | Explanation |
| --- | --- | --- |
| 1 | `2: <PROBECALIBRATION>(O6000)` | Shop-level wrapper declaration for this cycle. |
| 2 | `3: (SMART MACHINE TOOL MINI / FANUC 0I-MF)` | Comment/documentation line: SMART MACHINE TOOL MINI / FANUC 0I MF. |
| 3 | `4: (PURPOSE: PROBECALIBRATION)` | Comment/documentation line: PURPOSE: PROBECALIBRATION. |
| 4 | `5: (DETAILS: walkthroughs/calibration/PROBECALIBRATION.md)` | Comment/documentation line: DETAILS: walkthroughs/calibration/PROBECALIBRATION.md. |
| 5 | `6: G91G28Z0.` | Sets incremental positioning mode. Returns axis/axes toward machine reference position. |
| 6 | `7: G40G90G80G94` | Cancels cutter radius compensation. Sets absolute positioning mode. Cancels canned cycle mode. Feed per minute mode. |
| 7 | `8: (PAUSE FOR OPERATOR ACTION)` | Comment/documentation line: PAUSE FOR OPERATOR ACTION. |
| 8 | `9: M00` | Program stop for operator action/check. |
| 9 | `10: T1(CHANGE TOOL NUMBER)` | Executes macro-specific calculation or control logic. |
| 10 | `11: G0G90G54X0.Y0.` | Rapid positioning move. Sets absolute positioning mode. |
| 11 | `12: G43Z200.H1` | Applies tool length compensation. |
| 12 | `13: G65P9832(PROBE ON)` | Calls macro O9832 (REN PROBE START) with the supplied arguments. |
| 13 | `14: G04X1.` | Executes macro-specific calculation or control logic. |
| 14 | `15: G5.1Q0` | Turns off AI contour control mode. |
| 15 | `16: (CALL O9810 (REN PROTECTED POSN))` | Executes macro-specific calculation or control logic. |
| 16 | `17: G65P9810Z100.F2500` | Calls macro O9810 (REN PROTECTED POSN) with the supplied arguments. |
| 17 | `18: (CALL O9810 (REN PROTECTED POSN))` | Executes macro-specific calculation or control logic. |
| 18 | `19: G65P9810Y-40.0` | Calls macro O9810 (REN PROTECTED POSN) with the supplied arguments. |
| 19 | `20: (CALL O9810 (REN PROTECTED POSN))` | Executes macro-specific calculation or control logic. |
| 20 | `21: G65P9810Z50.` | Calls macro O9810 (REN PROTECTED POSN) with the supplied arguments. |
| 21 | `22: (CALL O9810 (REN PROTECTED POSN))` | Executes macro-specific calculation or control logic. |
| 22 | `23: G65P9810Z20.` | Calls macro O9810 (REN PROTECTED POSN) with the supplied arguments. |
| 23 | `24: (CALL O9801 (REN ALL CALIB))` | Executes macro-specific calculation or control logic. |
| 24 | `25: G65P9801K1.B6.0T1Z0.` | Calls macro O9801 (REN ALL CALIB) with the supplied arguments. |
| 25 | `26: (CALL O9810 (REN PROTECTED POSN))` | Executes macro-specific calculation or control logic. |
| 26 | `27: G65P9810X0.Y0.` | Calls macro O9810 (REN PROTECTED POSN) with the supplied arguments. |
| 27 | `28: (CALL O9810 (REN PROTECTED POSN))` | Executes macro-specific calculation or control logic. |
| 28 | `29: G65P9810Z-10.` | Calls macro O9810 (REN PROTECTED POSN) with the supplied arguments. |
| 29 | `30: (CALL O9801 (REN ALL CALIB))` | Executes macro-specific calculation or control logic. |
| 30 | `31: G65P9801D62K4.B6.0` | Calls macro O9801 (REN ALL CALIB) with the supplied arguments. |
| 31 | `32: (CALL O9810 (REN PROTECTED POSN))` | Executes macro-specific calculation or control logic. |
| 32 | `33: G65P9810Z50.` | Calls macro O9810 (REN PROTECTED POSN) with the supplied arguments. |
| 33 | `34: G04X1.` | Executes macro-specific calculation or control logic. |
| 34 | `35: G91G28Z0.` | Sets incremental positioning mode. Returns axis/axes toward machine reference position. |
| 35 | `36: G65P9833(PROBE OFF)` | Calls macro O9833 (REN PROBE STOP) with the supplied arguments. |
| 36 | `38: (END PROGRAM)` | Comment/documentation line: END PROGRAM. |
| 37 | `39: M30` | End of program and rewind/reset. |
