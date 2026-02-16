# Tool Setter Calibration (No PDF)

We do not have a vendor PDF for the tool setter. We will define calibration from on-machine measurement.

## Inputs required
- Exact-length test bar (known tool length)
- Operator-defined SAFE_Z_MACHINE
- Ability to jog to tool setter center and trigger plane safely

## Outputs (stored in persistent variables)
- TS_X_MACHINE 
- TS_Y_MACHINE 
- TS_Z_TRIP_MACHINE 

## Recommended operator method (high level)
1) Jog above tool setter safely (clearance).
2) Center over the tool setter and record machine X/Y.
3) Using the test bar, approach tool setter in Z carefully and record machine Z at trigger.
4) Store X/Y/Z values to the variables above.
