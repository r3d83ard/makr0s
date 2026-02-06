%
O9802 (CUSTOM - FIND RING CENTER, SHIFT G54 X/Y)

(Args: D=#7, Z=#26, Q=#17, R=#18, S=#19)

#100 = #7
IF[#100 EQ #0] THEN #3000=1 (O9802: D (RING ID) REQUIRED)

#101 = #26   (Z depth)
#102 = #17
IF[#102 EQ #0] THEN #102 = 5.0

#103 = #18
IF[#103 EQ #0] THEN #103 = [#100/4.0]

#104 = #19
IF[#104 EQ #0] THEN #104 = 0.050

G90 G17 G40 G49 G80
G54

#110 = #5021   (X start, work)
#111 = #5022   (Y start, work)

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

#130 = [#120 + #121] / 2.0   (X center in current work coords)

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

#131 = [#122 + #123] / 2.0   (Y center)

(Shift G54 so center becomes X0 Y0)
#140 = #5221   (G54 X offset)
#141 = #5222   (G54 Y offset)

G10 L2 P1 X[#140 + #130] Y[#141 + #131]

G54
G00 X0.0 Y0.0

(Store results)
#550 = #130
#551 = #131

M99
%
