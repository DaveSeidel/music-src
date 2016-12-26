; Initial condition, sometimes said as the shape of "hammerhead" striking  against the string - MAJOR INFLUENCE TO SOUND
f 10 0 128 7 1 128 0.001 ; With gen7 cleaner beginning than gen5. Gen5 - more overtones
f 11 0 128 10 1 0.3 0.2 0.1 ; sine- quite interesting,  a lot of overtones, use irate something like 0.05 
f 12 0 128 20 4 5 7 ;blackman window, intresting also with other forms of gen20  
f 13 0 128 7 0 40 0.75 42 0.28 36 0.66 10 1 ; different zig-zagd  
f 14 0 128 7 0.99 35 0.02 27 0.99 20 0.03 46 1 
f 15 0 128 7 0.99 33 1 28 0.99 20 0.03 15 1 31 1 
f 16 0 128 7 0 52 0.3 44 0.65 28 0.01 4 1 
f 17 0 128 7 0 15 0.57 37 0.3 5 0.68 38 0.65 3 0.95 19 0.72 10 1 
f 18 0 128 7 0 6 0 6 0.51 6 0 40 0 8 0.99 5 0 22 0 10 0.58 6 0 18 0 
f 19 0 128 5 0.001 128 1 ; exponent up
 
; Masses 
f 20 0 128 -7 1 128 1 ; OK, if all equal. More interesting if first masses smaller. For example 0.3..0.8 
; If masses over 1, the sound is denser and more harmonics.; ; interesting also like 10..12 
f 21 0 128 -7 0.3 128 0.8 
f 22 0 128 -7 1 128 1.5 
f 23 0 128 -7 10 128 12 
f 24 0 128 -7 1 128 0.2
f 25 0 128 -7 10 128 1
 
; Spring matrices 
f 30 0 16384 -23 "circularstring-128" 
; original: "string-128.matrix" 
; grid - quite interesting; string and torus - not big difference 
; full - does not function well
; circular - more overtones, spectrum more even that with string 
; spiral - quite interesting, buzz-like, many samples out of range 
 
; Centering force 
f 40  0 128 -7 0.01 128 2 ;quite interesting when decreasing - 1..0 - a lot of harmoncis. 0..1 - cleaner sound; all 0 -  relatively; kui 0..0.1, more subtle, higher sounding    
; quite interesting very small: 0..0.25 
f 41 0 128 -7 1 128 0 
f 42 0 128 -7 0 128 0.1
f 43 0 128 -5 1 64 0.5  64 1 ; exponent curve down
f 44 0 128 -5 0.1 64 0.5 64 0.1 ; eksponent wave

 
; Damping 
f 50 0 128 -7 1 128 1 ;64 1 0 0 64 0     ;1 128 1      ; interesting, if some parts 0    ; does not incluence  much 1..1 OK 
 
; Initial velocity 
f 60 0 128 -7 0 128 0 ; 0 128 20 1     ;0 128 -7 0 64 0.5 64 0     ;128 0.8      ; dangerous - can explode. ; gen20 - interesting ;everything 0 - is OK, 
 
; Scanning trajectories ; the numbers may not exeed of the number of pints in matrix
f 70 0 128 -5 1 64 127 64 1 ; forst half back and forth
f 71 0 128 -7 1 128 127 ; mas by mass
f 72 0 128 -20 1 127 ; Hanning - interesting
f 73 0 128  -7 1 40 92 42 20 36 120 10 127 ; zigzag
f 74 0 128  -7 127 40 32 42 64 36 16 10 1 

