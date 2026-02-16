# O6021 - MANUAL TOOL LENGTH

## Purpose
Brief: This macro supports **manual tool length** on the Smart Machine Tool MINI using a Fanuc 0i-MF control.

## Machine Context
- Machine: Smart Machine Tool MINI
- Control: Fanuc 0i-MF
- Units/offset behavior depends on active Renishaw settings, current work offset, and active tool length values.

## Step-By-Step G-code Walkthrough
| Step | Source | Explanation |
| --- | --- | --- |
| 1 | `2: <MANUAL-TOOL-LENGTH>(O6021)` | Shop-level wrapper declaration for this cycle. |
| 2 | `3: (SMART MACHINE TOOL MINI / FANUC 0I-MF)` | Comment/documentation line: SMART MACHINE TOOL MINI / FANUC 0I MF. |
| 3 | `4: (PURPOSE: MANUAL TOOL LENGTH)` | Comment/documentation line: PURPOSE: MANUAL TOOL LENGTH. |
| 4 | `5: (DETAILS: walkthroughs/tool-setting/MANUAL-TOOL-LENGTH.md)` | Comment/documentation line: DETAILS: walkthroughs/tool setting/MANUAL TOOL LENGTH.md. |
| 5 | `7: (POSITION-TOOL-MANUALLY-10MM-ABOVE-TOOL-SETTER)` | Comment/documentation line: POSITION TOOL MANUALLY 10MM ABOVE TOOL SETTER. |
| 6 | `10: (CALL O9856 (MANUAL TOOL SETTING))` | Executes macro-specific calculation or control logic. |
| 7 | `11: G65P9856D6.T4` | Calls macro O9856 (MANUAL TOOL SETTING) with the supplied arguments. |
| 8 | `13: (END PROGRAM)` | Comment/documentation line: END PROGRAM. |
| 9 | `14: M30` | End of program and rewind/reset. |
