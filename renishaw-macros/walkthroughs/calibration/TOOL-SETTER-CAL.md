# O6020 - TOOL SETTER CAL

## Purpose
Brief: This macro supports **tool setter cal** on the Smart Machine Tool MINI using a Fanuc 0i-MF control.

## Machine Context
- Machine: Smart Machine Tool MINI
- Control: Fanuc 0i-MF
- Units/offset behavior depends on active Renishaw settings, current work offset, and active tool length values.

## Step-By-Step G-code Walkthrough
| Step | Source | Explanation |
| --- | --- | --- |
| 1 | `2: <TOOL-SETTER-CAL>(O6020)` | Shop-level wrapper declaration for this cycle. |
| 2 | `3: (SMART MACHINE TOOL MINI / FANUC 0I-MF)` | Comment/documentation line: SMART MACHINE TOOL MINI / FANUC 0I MF. |
| 3 | `4: (PURPOSE: TOOL SETTER CAL)` | Comment/documentation line: PURPOSE: TOOL SETTER CAL. |
| 4 | `5: (DETAILS: walkthroughs/calibration/TOOL-SETTER-CAL.md)` | Comment/documentation line: DETAILS: walkthroughs/calibration/TOOL SETTER CAL.md. |
| 5 | `6: (POSITION-TOOL-MANUALLY-10MM-ABOVE-TOOL-SETTER)` | Comment/documentation line: POSITION TOOL MANUALLY 10MM ABOVE TOOL SETTER. |
| 6 | `7: (CALL O9855 (REN STLUS CALIBRATION))` | Executes macro-specific calculation or control logic. |
| 7 | `8: G65P9855D26R6.0T3` | Calls macro O9855 (REN STLUS CALIBRATION) with the supplied arguments. |
| 8 | `9: (END PROGRAM)` | Comment/documentation line: END PROGRAM. |
| 9 | `10: M30` | End of program and rewind/reset. |
