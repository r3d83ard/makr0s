%
O9801 (CUSTOM - PROBE LENGTH TO Z REF PLANE)

(Args: Z=#26, H=#11, Q=#17, R=#18, S=#19, A=#1)

#100 = #26    (ZREF) 
IF[#100 EQ #0] THEN #100 = 0.0   (allow Z0 if caller passes 0 explicitly)

#101 = #11    (H number, optional)
#102 = #17    (feed)
IF[#102 EQ #0] THEN #102 = 5.0

#103 = #18    (search past plane)
IF[#103 EQ #0] THEN #103 = 0.200

#104 = #19    (retract)
IF[#104 EQ #0] THEN #104 = 0.050

#105 = #1     (clearance above plane)
IF[#105 EQ #0] THEN #105 = 0.200

G90 G17 G40 G49 G80

(Go to safe clearance above reference plane)
#130 = #100 + #105
G00 Z#130

(Probe down past plane)
#131 = #100 - #103
G31 Z#131 F#102

#110 = #5063   (Z hit position in current work coordinates)
#111 = [#110 - #100]  (Z error: + means hit ABOVE plane)

(Retract)
#132 = #110 + #104
G00 Z#132
#133 = #100 + #105
G00 Z#133

(Optionally update tool length geometry offset)
(Assumes Fanuc allows writing #2000+H and you are using G43 Hnn for the probe)
IF[#101 GT 0] THEN #120 = #[2000 + FIX[#101]]  (current H geometry)
IF[#101 GT 0] THEN #121 = [#120 - #111]        (new H = old H - error)
IF[#101 GT 0] THEN #[2000 + FIX[#101]] = #121

(Store results for logging)
#553 = #111    (Z error)
#554 = #110    (Z hit)
#555 = #121    (new H if written, else 0)

M99
%
