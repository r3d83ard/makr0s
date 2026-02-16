# O6023 - AUTO TOOL LENGTH ON CENTRE

## Purpose
Brief: This macro supports **auto tool length on centre** on the Smart Machine Tool MINI using a Fanuc 0i-MF control.

## Machine Context
- Machine: Smart Machine Tool MINI
- Control: Fanuc 0i-MF
- Units/offset behavior depends on active Renishaw settings, current work offset, and active tool length values.

## Step-By-Step G-code Walkthrough
| Step | Source | Explanation |
| --- | --- | --- |
| 1 | `2: <AUTO-TOOL-LENGTH-ON-CENTRE>(O6023)` | Shop-level wrapper declaration for this cycle. |
| 2 | `3: (SMART MACHINE TOOL MINI / FANUC 0I-MF)` | Comment/documentation line: SMART MACHINE TOOL MINI / FANUC 0I MF. |
| 3 | `4: (PURPOSE: AUTO TOOL LENGTH ON CENTRE)` | Comment/documentation line: PURPOSE: AUTO TOOL LENGTH ON CENTRE. |
| 4 | `5: (DETAILS: walkthroughs/tool-setting/AUTO-TOOL-LENGTH-ON-CENTRE.md)` | Comment/documentation line: DETAILS: walkthroughs/tool setting/AUTO TOOL LENGTH ON CENTRE.md. |
| 5 | `7: (CALL O9857 (REN TOOL AUTO SET))` | Executes macro-specific calculation or control logic. |
| 6 | `8: G65P9857B3D6T5` | Calls macro O9857 (REN TOOL AUTO SET) with the supplied arguments. |
| 7 | `9: (END PROGRAM)` | Comment/documentation line: END PROGRAM. |
| 8 | `10: M30` | End of program and rewind/reset. |
