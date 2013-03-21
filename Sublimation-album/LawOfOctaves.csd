;-------------------------------------------------------------------------
;
;	Law of Octaves (or Ligeti Drift, or Drift Dhikr revisited, again)
;	by Dave Seidel (dave at mysterybear dot com)
;
;   Copyright 2008, Dave Seidel. Some rights reserved.
;   This work is licensed under a Creative Commons "Attribution" License.
;   http://creativecommons.org/licenses/by/3.0/
;
;	Tested with Csound version 5.0.7 on Windows XP.
;
;-------------------------------------------------------------------------

<CsoundSynthesizer>
<CsOptions>

--expression-opt -g -f -W -o LawOfOctaves.wav

</CsOptions>
<CsInstruments>

sr     = 96000
ksmps  = 1
nchnls = 2

;-------------------------------------------------------------------------
; global send channels
;-------------------------------------------------------------------------

gaL		init	0
gaR		init	0

;-------------------------------------------------------------------------
; function tables for waveforms
;-------------------------------------------------------------------------

giTblSz	init	1048576

; sine wave
giFn1 	ftgen	1, 0, giTblSz, 10, 1

; "Fibonacci" wave (Mt. Meru A)
giFn2	ftgen	2, 0, giTblSz, 9,  1,1,0,   2,.5,0,   3,.3333,0,  5,.2,0,  8,.125,0,  13,.0769,0,  21,.0476,0,  ;34,.0294,0,  ;55,.0182,0,  ;89,.0112,0  ;144,.0069,0

;---------------------------------------------------------------------------
;	panning (from Steven Yi), modified to use k-rate input
;---------------------------------------------------------------------------

	opcode yipank,aa,ka
kpan,asig	xin
kpan		=			kpan * 3.14159265359 * 0.5
kpanl		=			sqrt(2) / 2 * (cos(kpan) + sin(kpan))
kpanr		=			sqrt(2) / 2 * (cos(kpan) - sin(kpan))
			xout		asig*kpanl, asig*kpanr
	endop

;---------------------------------------------------------------------------
;	antialiasing (and other filtering)
;---------------------------------------------------------------------------

	opcode antialias,aa,aa
ain1,ain2	xin
aout1		butterlp	ain1, sr/2					; left channel low-pass (antialias)
aout1		butterhp	aout1, 20					; left channel high-pass
aout2		butterlp	ain2, sr/2					; left channel low-pass (antialias)
aout2		butterhp	aout2, 20					; left channel high-pass
			xout		aout1, aout2
	endop

;---------------------------------------------------------------------------------------
;	compute frequencies of combination tones
;---------------------------------------------------------------------------------------

	opcode  kGetCombinations, kkkkk, kk
kpch1,kpch2 xin
kdiff       = 			abs(kpch2-kpch1)			; first order difference
kdiff2      = 			abs((2*kpch2) - kpch1)		; second order difference
kdiff3      = 			abs((3*kpch2) - (2*kpch1))	; third order difference
ksum        = 			kpch1 + kpch2				; first order summation
ksum2       = 			(2*kpch1) + kpch2			; second order summation
			xout		kdiff, kdiff2, kdiff3, ksum, ksum2
	endop

;---------------------------------------------------------------------------
;	global output instrument with reverb and other stuff
;---------------------------------------------------------------------------

	instr	1
ifblvl		=			p4							; feedback level
ifco		=			p5							; cut-off frequency [0..israte/2]
ipv			=			p6							; pitch variation [0..10]
ilvl		=			p7							; amount of reverb in output (1 == equal with dry)
aL, aR		reverbsc	gaL, gaR, ifblvl, ifco, sr/1.5, ipv, 0
a1, a2		antialias	aL, aR
			outs		(a1*ilvl)+gaL, (a2*ilvl)+gaR
gaL			=			0
gaR			=			0
	endin

;---------------------------------------------------------------------------------------
; combination tone chord organ (gliding)
;---------------------------------------------------------------------------------------

	instr   3

idur		=			p3							; duration
iamp		=			p4/7						; amplitude
ifn			=			p5							; function table number (waveform) for primary tone
ifn2		=			p6							; function table number (waveform) for derived tones
ipch1		=			p7							; primary pitch (as a frequency)
immm		=			p8							; numerator of intial dyad
innn		=			p9							; denominator of initial dyad
imm2		=			p10							; numerator of eventual dyad
inn2		=			p11							; denominator of eventual dyad
ipan1		=			p12							; pan starting point
ipan2		=			p13							; pan ending point
igrise		=			p14							; glide/pan envelope rise
igfall		=			p15							; glide/pan ebvelope fall

kpch1		=			ipch1						; primary pitch
ipch2a		=			ipch1*(immm/innn)			; secondary starting pitch (primary * ratio)
ipch2b		=			ipch1*(imm2/inn2)			; secondary ending pitch (primary * ratio)

			prints		"\\n%d:%d (%f) -> %d:%d (%f)\\n", immm, innn, ipch2a, imm2, inn2, ipch2b

; glide envelope
kpch2		linseg		ipch2a, igrise, ipch2a, idur-(igrise+igfall), ipch2b, igfall, ipch2b

; continuous derivation of combination tones (one fixed pitch, one gliding pitch)
kdiff,kdiff2,kdiff3,ksum,ksum2    kGetCombinations  kpch1, kpch2

; amplitude envelope
ke    		linen   	iamp, 5, idur, 0.3

; generate the tones...
asig1   	poscil3 	ke, kpch1, ifn
asig2		poscil3		ke, kpch2, ifn2
adiff		poscil3 	ke, kdiff, ifn2
adiff2		poscil3		ke, kdiff2, ifn2
adiff3		poscil3 	ke, kdiff3, ifn2
asum		poscil3		ke, ksum, ifn2
asum2		poscil3		ke, ksum2, ifn2

; ...and combine them
aout		sum			asig1, asig2, adiff, adiff2, adiff3, asum, asum2

; pan envelope
kpan		linseg		ipan1, igrise, ipan1, idur-(igrise+igfall), ipan2, igfall, ipan2
;			printks		"[%1.5f - %1.5f - %1.5f]\\n", 1, k(ipan1), kpan, k(ipan2)

; output
aLeft, aRight	yipank	kpan, aout
gaL			=			gaL+aLeft
gaR			=			gaR+aRight
        
	endin

;---------------------------------------------------------------------------------------
; combination tone chord organ (gliding on both pitches)
;---------------------------------------------------------------------------------------

	instr   31

idur		=			p3                      	; duration
iamp		=			p4/7                    	; amplitude
ifn			=			p5                      	; function table number (waveform) for primary tone
ifn2		=			p6							; function table number (waveform) for derived tones
ipch1		=			p7							; primary pitch (as a frequency)
immm		=			p8							; numerator of initial dyad
innn		=			p9							; denominator of initial dyad
imm2		=			p10							; numerator of first eventual dyad
inn2		=			p11							; denominator of first eventual dyad
imm3		=			p12							; numerator of second eventual dyad
inn3		=			p13							; denominator of second eventual dyad
ipan1		=			p14							; pan starting point
ipan2		=			p15							; pan ending point
igrise		=			p16							; glide/pan envelope rise
igfall		=			p17							; glide/pan ebvelope fall

ipch2a		=			ipch1*(immm/innn)			; first starting pitch (primary * ratio)
ipch2b		=			ipch1*(imm2/inn2)			; first ending pitch (primary * ratio)

ipch3a		=			ipch2a						; second starting pitch (primary * ratio) - same as first starting pitch
ipch3b		=			ipch1*(imm3/inn3)			; second ending pitch (primary * ratio)

			prints		"\\n%d:%d <- %d:%d -> %d:%d\\n", imm3, inn3, immm, innn, imm2, inn2

; glide envelopes
kpch1		linseg		ipch2a, igrise, ipch2a, idur-(igrise+igfall), ipch2b, igfall, ipch2b
kpch2		linseg		ipch3a, igrise, ipch3a, idur-(igrise+igfall), ipch3b, igfall, ipch3b

; continuous derivation of combination tones (two gliding pitches
kdiff,kdiff2,kdiff3,ksum,ksum2    kGetCombinations  kpch1, kpch2

; amplitude envelope
ke    		linen   	iamp, 5, idur, 0.3

; generate the tones...
asig1   	poscil3 	ke, kpch1, ifn
asig2		poscil3		ke, kpch2, ifn2
adiff		poscil3 	ke, kdiff, ifn2
adiff2		poscil3		ke, kdiff2, ifn2
adiff3		poscil3		ke, kdiff3, ifn2
asum		poscil3		ke, ksum, ifn2
asum2		poscil3		ke, ksum2, ifn2

; ...and combine them
aout		sum			asig1, asig2, adiff, adiff2, adiff3, asum, asum2

; pan envelope
kpan		linseg		ipan1, igrise, ipan1, idur-(igrise+igfall), ipan2, igfall, ipan2
;			printks		"[%1.5f - %1.5f - %1.5f]\\n", 1, k(ipan1), kpan, k(ipan2)

; output
aLeft, aRight	yipank	kpan, aout
gaL			=			gaL+aLeft
gaR			=			gaR+aRight
        
	endin

</CsInstruments>
<CsScore>

;---------------------------------------------------------------------------
; macros
;---------------------------------------------------------------------------

; 60Hz base pitch
#define BASE		#60#
; second base pitch, perfect fourth above base pitch
#define BASE2		#$BASE.*(4/3)#

; base pitch in specified octave
#define O(N)		#[$BASE.*(2^$N.)]#
; same for second base pitch
#define O2(N)		#[$BASE2.*(2^$N.)]#

; duration of piece (seconds)
#define DUR			#540#

;---------------------------------------------------------------------------
; events
;---------------------------------------------------------------------------

; output & post-processing (reverb, filtering)
i1 0 [$DUR.+3] 0.84 15360 0.2 0.65

; gliders based on 1/1 in higher octave, panning from center to right
i3  0 $DUR.  7400 2 1 $O.(1)  3 2 2 1      0  1.0 7 4
i3  . .      .    . . $O.(1)  3 2 1 1      0  1.0 7 4
i31 0 $DUR.  7400 2 2 $O.(1)  3 2 1 1 2 1  0  1.0 7 4

; gliders based on 4/3, panning from center to left
i3  0 $DUR.  7400 2 1 $O2.(0) 3 2 2 1      0 -1.0 7 4
i3  . .      .    . . $O2.(0) 3 2 1 1      0 -1.0 7 4
i31 0 $DUR.  7400 2 2 $O2.(0) 3 2 1 1 2 1  0 -1.0 7 4

e

</CsScore>
</CsoundSynthesizer>
