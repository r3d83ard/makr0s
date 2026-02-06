%
O9804 (CUSTOM - BALL RADIUS FROM RING ID, STORES #552)

(Args: D=#7, Z=#26, Q=#17, R=#18, S=#19)

#100 = #7
IF[#100 EQ #0] THEN #3000=1 (O9804: D (RING ID) REQUIRED)

#101 = #26
#102 = #17
IF[#102 EQ #0] THEN #102 = 5.0

#103 = #18
IF[#103 EQ #0] THEN #103 = [#100/4.0]

#104 = #19
IF[#104 EQ #0] THEN #104 = 0.050

G90 G17 G40 G49 G80
G54

#110 = #5021
#111 = #5022

IF[#101 NE #0] THEN G00 Z#101

(Probe X+)
G91
G31 X#103 F#102
#120 = #5061
G00 X-#104
G90 G00 X#110 Y#111

(Probe X-)
G91
G31 X-#103 F#102
#121 = #5061
G00 X#104
G90 G00 X#110 Y#111

#200 = [#120 - #121]          (measured inside span in X = D - 2R)
#210 = [#100 - #200] / 2.0    (R from X)

(Probe Y+)
G91
G31 Y#103 F#102
#122 = #5062
G00 Y-#104
G90 G00 X#110 Y#111

(Probe Y-)
G91
G31 Y-#103 F#102
#123 = #5062
G00 Y#104
G90 G00 X#110 Y#111

#201 = [#122 - #123]          (span in Y)
#211 = [#100 - #201] / 2.0    (R from Y)

#552 = [#210 + #211] / 2.0    (final ball radius)

M99
%
