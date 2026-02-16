# Renishaw Macros Organization

Macros are grouped by use case for the Smart Machine Tool MINI (Fanuc 0i-MF).
Each macro has a mirrored walkthrough markdown file under `walkthroughs/` using the same category and filename.

## Categories
- `calibration/`: Probe and tool-setter calibration cycles.
- `measurement-cycles/`: Feature inspection and geometric measurement cycles.
- `tool-setting/`: Manual/automatic tool length, broken tool, and related tool-setter cycles.
- `inspection-engine/`: Core Renishaw logic, settings, motion helpers, offset/report processing, and probe start/stop.
- `machine-interface/`: Machine/control integration macros (M-code wrappers, tool change interface, setup hooks).
- `legacy-custom/`: Shop-specific legacy or custom support macros.

## Mirrored Walkthroughs
For a macro at `CATEGORY/MACRO_NAME`, the walkthrough is at `walkthroughs/CATEGORY/MACRO_NAME.md`.
