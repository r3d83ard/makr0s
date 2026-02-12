# O9820 Calibration + Find Ring Center

## Purpose

This procedure validates that the probe calibration macro **O9820** can:

1. Find the ring center automatically using X−, X+, Y−, Y+ wall touches
2. Compute and store:
	- #540 = stylus effective radius
	- #541 = stylus effective length constant (Z reference)
3. Complete successfully with:
	- #585 = 1
	- #583/#584 logging the final calibration values

This is the **full “real” configuration test** after the safety and syntax tests have already passed.

---

### Why we do these steps

#### Why the ring is needed

The ring provides **known geometry** (a stable inside diameter). Touching opposite walls lets the macro compute:

- The **true center** (average of opposite hit positions)
- The **effective probe radius** by comparing measured vs nominal diameter

#### Why we must start near the center

Center-find uses **short, bounded strokes** (software “overtravel”). If we start too far from the ring wall or too far outside the ring, the stroke may not reach the surface and the macro will alarm **921 (NO TRIGGER)**.

#### Why we use Safe Z and Z limits

The macros use SAFE_Z_MACHINE (#526) and Z travel limits (#524/#525) to prevent dangerous motion:

- Moves to SAFE_Z_MACHINE before XY repositioning.
- Clamps any computed Z approach plane to the configured Z limits.
This prevents commanding Z to an unsafe value.

#### Why we need the test bar (or a real Z stack) for the Z reference portion

The Z-reference part of O9820 assumes there is a **real physical stack height** to touch:

- E = Z reference plane (machine coordinate)
- F = test bar length

The macro approaches Z_start ≈ E + F + margin and probes down to touch.
If there is no real contact surface at the expected height, the Z probing will alarm 921 or produce meaningless values.

#### Why M19 is required before G31

This machine requires spindle orientation (M19) before skip-probing moves (G31). Without it, you may see feed/spindle state errors or probing may not execute correctly.

---

### Safety prerequisites (must be true before running)
#### 1. Machine is in a safe state**

- No active tool in cut
- No coolant blasting the probe (unless your process requires it)
- Door closed / interlocks satisfied
- Feed override conservative (start at 25–50% for first validation)

#### 2. Macros initialized

- Run O9800 once after power-up to initialize defaults.
- Run O9803 once to set SAFE_Z_MACHINE.

#### 3. Persistent variables must be set correctly

Confirm these on OFFSET → MACRO:

- #526 = SAFE_Z_MACHINE (inches, machine coordinate)
- #524 = Z_MIN limit (mm)
- #525 = Z_MAX limit (mm)
- #530 = probe seek feed (inch/min)
- #532 = probe max stroke (inch)
- #585 last status (used for pass/fail)
- (Optional logs) #580–#584

If #526 is 0, probing macros will fault (SAFE Z not set).

If #524/#525 are 0 or inverted, O9820 will fault 946 (Z LIMITS INVALID).

---

### Required equipment
- Master ring (known inside diameter)
- Probe in a toolholder (spindle probe)
- Test bar tool (known length)
- If test bar length is not known, you can still run B4 to validate center-finding and general flow, but #541 may not be meaningful.

---

### Operator setup checklist

#### A. Mount the ring safely

1.	Clean the table / fixture.
2.	Place ring securely and clamp so it cannot move.
3.	Confirm ring is square and stable (no rocking).

#### B. Load the probe

1.	Put probe tool into spindle (manual load or ATC).
2.	Ensure probe is functioning (battery/connection OK).

#### C. Position the probe near the ring center

1.	Jog above the ring ID, roughly centered.
2.	Set Z to a safe height above ring (below SAFE_Z_MACHINE is OK; you should still have clearance).

Start as close to center as possible to reduce the chance of “NO TRIGGER” alarms during wall touches.

---

### Inputs to O9820 (what A/B/C/D/E/F mean)

You will run:

```json
G65 P9820 A1 B<ring_ID> C0 D0 E<Z_ref> F<testbar_len>
```

- A1 = inch mode
- B = ring inside diameter (inches)
- C = ring center X machine coordinate
	- use 0 to enable automatic center-find
- D = ring center Y machine coordinate
	- use 0 to enable automatic center-find
- E = Z reference plane (machine Z coordinate, inches)
- F = test bar length (inches)

--- 

### How to choose E and F (Z reference setup)

#### Test bar setup: 

1. Identify the test bar length F (inches).
	- Use its certified value if available.
2. Decide what your Z reference plane E represents.
	- Best: E + F corresponds to a real plane the probe can touch (table surface, fixture top, or a known calibration surface).

#### Practical way to set E

If you can measure a plane with the test bar and record machine Z at contact:

1. Load test bar tool.
2. Carefully touch a known plane (paper feeler / shim method).
3. Record the machine Z at that plane: call it Z_plane.	4. Set E = Z_plane - F.

This makes:
	•	E + F = Z_plane (a real physical plane)

---

### Run Procedure (step-by-step)

#### Step 1 — First run in SINGLE BLOCK (recommended)

1. Turn on Single Block.
2. Start from a safe position above the ring.
3. Run:

```
G65 P9820 A1 B<ring_ID> C0 D0 E<Z_ref> F<testbar_len>
```

4. Watch each stage:

- Goes to G53 G0 Z#526 (safe Z)
- Approaches X−, probes X−
- Approaches X+, probes X+
- Approaches Y−, probes Y−
- Approaches Y+, probes Y+
- Returns to center
- Moves to Z start (clamped)
- Performs Z probe touch

If anything looks wrong, hit Feed Hold or E-Stop.

#### Step 2 — Full run (after first safe pass)

1. Turn off Single Block.
2.  Run the same command again.

--- 

### Expected results (pass criteria)

#### After a successful run:

- #585 = 1
- #540 updated (stylus effective radius)
- #541 updated (stylus effective length constant)
- #583 = #540 (logged)
- #584 = #541 (logged)
 
#### Sanity checks
- #540 should be reasonable:
	- Close to the stylus ball radius (or slightly different “effective” value), not huge.
- #541 should be plausible:
	- Not thousands, not near zero unexpectedly.
	- Should be consistent across repeat runs if setup is repeatable.

---

### Common alarms and what they mean

#### Alarm 921 — NO TRIGGER

Meaning: The probing move did not hit anything within the allowed stroke.

Causes:

- Probe not positioned close enough to ring wall before a touch.
- Stroke (#532) too small for the current setup.
- Z reference stack not present where expected.

Actions:

1. Re-position closer to the ring wall (start nearer center).
2. Confirm ring ID input B is correct.
3. Confirm probe is functional.
4. For Z portion: verify your E and F correspond to a real plane.

#### Alarm 946 — Z LIMITS INVALID

Meaning: Z limits are not set (#524/#525 = 0) or are inconsistent (min/max inverted).

Actions:

1. Verify #524 and #525 are set correctly (mm values).
2. Confirm conversion logic expectations (library uses #510 to interpret unit mode).

#### SAFE Z not set

Meaning: #526 = 0

Actions:

1. Run: G65 P9803 A<safe_z_machine_in> to set safe Z.

--- 

### Post-run documentation (operator notes)

Record for each successful calibration run:
	•	Date/time
	•	Ring ID B used
	•	E and F used
	•	Result values:
	•	#540
	•	#541
	•	Any issues (alarms, repositioning required)

---