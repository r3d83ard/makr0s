# O6022 - AUTO TOOL LENGTH OFF CENTRE

## Purpose
Brief: This macro supports **auto tool length off centre** on the Smart Machine Tool MINI using a Fanuc 0i-MF control.

## Machine Context
- Machine: Smart Machine Tool MINI
- Control: Fanuc 0i-MF
- Units/offset behavior depends on active Renishaw settings, current work offset, and active tool length values.

## Step-By-Step G-code Walkthrough
| Step | Source | Explanation |
| --- | --- | --- |
| 1 | `2: <AUTO-TOOL-LENGTH-OFF-CENTRE>(O6022)` | Shop-level wrapper declaration for this cycle. |
| 2 | `3: (SMART MACHINE TOOL MINI / FANUC 0I-MF)` | Comment/documentation line: SMART MACHINE TOOL MINI / FANUC 0I MF. |
| 3 | `4: (PURPOSE: AUTO TOOL LENGTH OFF CENTRE)` | Comment/documentation line: PURPOSE: AUTO TOOL LENGTH OFF CENTRE. |
| 4 | `5: (DETAILS: walkthroughs/tool-setting/AUTO-TOOL-LENGTH-OFF-CENTRE.md)` | Comment/documentation line: DETAILS: walkthroughs/tool setting/AUTO TOOL LENGTH OFF CENTRE.md. |
| 5 | `11: (ENTER-APPROX-TOOL-LENGTH-IN-TOOL-TABLE)` | Comment/documentation line: ENTER APPROX TOOL LENGTH IN TOOL TABLE. |
| 6 | `17: (CALL O9857 (REN TOOL AUTO SET))` | Executes macro-specific calculation or control logic. |
| 7 | `18: G65P9857B3.D6.T4` | Calls macro O9857 (REN TOOL AUTO SET) with the supplied arguments. |
| 8 | `21: (END PROGRAM)` | Comment/documentation line: END PROGRAM. |
| 9 | `22: M30` | End of program and rewind/reset. |
