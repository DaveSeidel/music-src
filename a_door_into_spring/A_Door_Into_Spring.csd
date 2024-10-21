;-------------------------------------------------------------------------
;
;	A Door Into Spring
;	by Dave Seidel (dave at mysterybear dot com)
;
;   Copyright 2009, Dave Seidel. Some rights reserved.
;   This work is licensed under a Creative Commons "Attribution" License.
;   http://creativecommons.org/licenses/by/3.0/
;
;	Tested with Csound version 5.10 on Windows XP.
;
;-------------------------------------------------------------------------

<CsoundSynthesizer>
<CsOptions>

--expression-opt -g -f -W -o A_Door_Into_Spring.wav

</CsOptions>
<CsInstruments>

sr		=	96000
ksmps	=	1
nchnls	=	2

;-------------------------------------------------------------------------
; input sample
;-------------------------------------------------------------------------

giSamples	ftgen	1, 0, 0, 1, "sample5-mono.wav", 0, 0, 0

;-------------------------------------------------------------------------
; global duration
;-------------------------------------------------------------------------

#define	TIME_FACTOR	#0.015#

; multiply the actual length of the sample by the inverse of the time factor
; to figure out how long it will be when warped
gidur	init	(nsamp(giSamples)/ftsr(giSamples)) * (1/$TIME_FACTOR)

;-------------------------------------------------------------------------
; global reverb sends
;-------------------------------------------------------------------------

gaL		init	0
gaR		init	0

;-------------------------------------------------------------------------
; panner (from Steven Yi)
;-------------------------------------------------------------------------

	opcode	yipan,aa,ia

iSpace,aout	xin

iSpace	=	iSpace * $M_PI * .5
icos	=	cos(iSpace)
isin	=	sin(iSpace)
krtl	= 	$M_SQRT2 / 2 * (icos + isin)
krtr	= 	$M_SQRT2 / 2 * (icos - isin)
aLeft	=	aout * krtl
aRight	=	aout * krtr

		xout	aLeft, aRight

	endop

;---------------------------------------------------------------------------
;	global reverb instrument
;---------------------------------------------------------------------------

	instr	1

p3	=	p3 + gidur		; set the true duration
aL, aR	reverbsc	gaL, gaR, p4, p5, sr/1.5, p6, 0
		outs		gaL+aL, gaR+aR
gaL	=	0
gaR	=	0

	endin

;---------------------------------------------------------------------------
;	time/pitch warper
;---------------------------------------------------------------------------

	instr	2

; set the true duration
p3		=	gidur
idur	=	p3

; parameters
iamp	=	ampdb(p4)	; amplitude (dB)
isrc	=	p5			; source audio table
ienv	=	p6			; grain envelope table
ipitch	=	p7			; pitch adjustment
ipan	=	p8			; pan factor

; syncgrain params
iolaps	=	2
igrsize	=	0.04
ifreq	=	iolaps/igrsize
ips		=	1/iolaps

; amplitude envelope
kenv	linseg		0,  0.1, iamp, idur-4.1, iamp, 3, 0, 1,  0 

; the beast itself
a1		syncgrain	kenv, ifreq, ipitch, igrsize, ips*$TIME_FACTOR, isrc, ienv, iolaps

; DC blocking filter
afilt1	dcblock2	a1

; roll off some highs
afilt2	butterlp	afilt1, 2000

; Compress the audio signal.
icomp1	=	0.5
icomp2	=	0.763
irtime	=	0.1
iftime	=	0.1
adam	dam	afilt2, kenv, icomp1, icomp2, irtime, iftime

; make it stereo
aL, aR	yipan	ipan, adam

; route it to the output
gaL		=	gaL+aL
gaR		=	gaR+aR

	endin

</CsInstruments>
<CsScore>

; half sine grain envelope
f 10 0 65537 9 0.5 1 0

; global reverb
i1 0 120 .98 4000 .4

; time-and-pitch warped samples, staggered low-to-high in pitch
i2   0 1 70 1 10 [(1/1)/2]  0.5
i2  30 1 .  . .  [(4/3)/2] -0.25
i2  60 1 .  . .  [(3/2)/2] -0.5
i2  90 1 .  . .  [(7/4)/2]  0.25
i2 120 1 .  . .  1          0

e

</CsScore>
</CsoundSynthesizer>
