;
; "Aurora (for Kraig Grady)"
; by Dave Seidel
;
; Copyright 2007 Dave Seidel, some rights reserved.  This work is licensed under a
; Creative Commons Attribution License (see http://creativecommons.org/licenses/by/3.0/).
; 
; For more information, go to http://mysterybear.net/article/24/aurora
; 
; Add the following lines after <CsoundSynthesizer> and before <CsInstruments> below,
; uncomment by removing the leading semicolons, then edit as desired.
; 
; *** START OF OPTIONS ***
; <CsOptions>
; ;; 96K/24-bit
; ;--sample-rate=96000 --control-rate=96000 --format=wav:24bit -o "Aurora-(96-24).wav"
; ;; 44.1K/16-bit
; --sample-rate=44100 --control-rate=44100 --format=wav:short -o "Aurora-(44-16).wav"
; </CsOptions>
; *** END OF OPTIONS ***
; 
;
; Generated by blue 0.117.0 (http://csounds.com/stevenyi/blue/index.html)
;

<CsoundSynthesizer>

<CsOptions>

;; 96K/24-bit
--sample-rate=96000 --control-rate=96000 --format=wav:24bit -o "Aurora-(96-24).wav"

;; 44.1K/16-bit
;--sample-rate=44100 --control-rate=44100 --format=wav:short -o "Aurora-(44-16).wav"

</CsOptions>

<CsInstruments>
sr=96000
ksmps=1
nchnls=2

giTblSz	init	1048576

; sine wave
giFn1	ftgen	1, 0, giTblSz, 10, 1

; "Fibonacci" wave (Mt. Meru A)
giFn2	ftgen	2, 0, giTblSz, 9,  1,1,0,   2,.5,0,   3,.3333,0,  5,.2,0,  8,.125,0,  13,.0769,0,  21,.0476,0,  34,.0294,0,  55,.0182,0,  89,.0112,0  144,.0069,0



ga_bluemix_4_0	init	0
ga_bluemix_4_1	init	0
ga_bluemix_5_0	init	0
ga_bluemix_5_1	init	0
ga_bluemix_8_0	init	0
ga_bluemix_8_1	init	0
ga_bluemix_9_0	init	0
ga_bluemix_9_1	init	0
ga_bluemix_10_0	init	0
ga_bluemix_10_1	init	0
ga_bluemix_11_0	init	0
ga_bluemix_11_1	init	0
ga_bluesub_SubChannel1_0	init	0
ga_bluesub_SubChannel1_1	init	0
ga_bluesub_Master_0	init	0
ga_bluesub_Master_1	init	0



gi_horn_seed = .5

gi_sine	ftgen 0, 0, 65537, 10, 1



	opcode yipan,aa,ia

iSpace,aout	xin
iSpace		=	iSpace * 3.14159265359 * .5
krtl		= 	sqrt(2) / 2 * (cos(iSpace) + sin(iSpace))
krtr		= 	sqrt(2) / 2 * (cos(iSpace) - sin(iSpace))
aLeft		=	aout * krtl
aRight		=	aout * krtr
		xout	aLeft, aRight


	endop
	opcode yiEnvelope,k,ioooooo

ienvType, iattack, idecay, isus, irel, iOldAmp, iNewAmp	xin

itie	tival
idur = p3

;prints "itie=%d  p3=%f\\n", itie, p3

iEndAmp = iNewAmp / iOldAmp


if (ienvType == 0) then
	kenv	adsr	iattack, idecay, isus, irel
elseif (ienvType == 1) then	
	kenv 	linseg	0, p3 * .5, 1, p3 * .5, 0
	kenv logcurve kenv, 1.5
elseif (ienvType == 2) then	
	kenv	linseg 	0, p3 - .1, 1, .1, 0	

elseif (ienvType == 3) then

    if (itie == 0 && p3 < 0) then
        ; this is an initial note within a group of tied notes
	prints	"start note\\n"
        kenv	linseg	0, .2, 1,  .2, 1
       
    elseif (p3 > 0 && itie == 1) then
        ; this is an end note out of a group of tied notes
	prints "end note\\n"
        kenv linseg	1, p3 - 1, 1, 1, 0
 
    elseif (p3 > 0 && itie == 0) then
        ; this is a stand alone note
	prints "standalone note\\n"
        kenv adsr iattack, idecay, isus, irel
    else
        ; this is a middle note within a group of tied notes (p3 < 0 && itie == 1)
	prints "middle note\\n"
        kenv line 1, abs(p3), iEndAmp
    endif  

endif

	xout 	kenv


	endop
	opcode getFrequency,i,i

ipch 	xin

iout	= (ipch < 15 ? cpspch(ipch) : ipch)
	
	xout	iout


	endop
	opcode panner,aa,ia

iSpace,aout	xin
iSpace		=	iSpace * 3.14159265359 * .5
krtl		= 	sqrt(2) / 2 * (cos(iSpace) + sin(iSpace))
krtr		= 	sqrt(2) / 2 * (cos(iSpace) - sin(iSpace))
aLeft		=	aout * krtl
aRight		=	aout * krtr
		xout	aLeft, aRight

	endop
	opcode blueEffect0,aa,aa

ain1,ain2	xin
aout1, aout2  reverbsc ain1, ain2, 0.8, 960.0

aout1 = (ain1 * 0.75) + (aout1 * (1 - 0.75))
aout2 = (ain2 * 0.75) + (aout2 * (1 - 0.75))


xout	aout1,aout2


	endop
	opcode blueEffect1,aa,aa

ain1,ain2	xin
korig    =      0.8
krev     =      1.0-korig
kfeed	=	0.1
ilp1	=	1/10
ilp2	=	1/23
ilp3	=	1/41
kroll	=	3000

ajunk    alpass  ain1,1.7,.1
aleft    alpass  ajunk,1.01,.07
ajunk    alpass  ain2,1.5,.2
aright   alpass  ajunk,1.33,.05
kdel1    randi   .01,1,.666
kdel1    =       kdel1 + .1
addl1    delayr  .3
afeed1   deltapi kdel1
afeed1   =       afeed1 + kfeed*aleft
         delayw  aleft

kdel2    randi   .01,.95,.777
kdel2    =       kdel2 + .1
addl2    delayr  .3
afeed2   deltapi kdel2
afeed2   =       afeed2 + kfeed*aright
         delayw  aright

aglobin = (afeed1+afeed2)*.05
atap1 comb aglobin,3.3,ilp1
atap2 comb aglobin,3.3,ilp2
atap3 comb aglobin,3.3,ilp3
aglobrev alpass atap1+atap2+atap3,2.6,.085
aglobrev tone aglobrev,kroll

kdel3 randi .003,1,.888
kdel3 = kdel3 + .05
addl3 delayr .2
agr1 deltapi kdel3
delayw aglobrev

kdel4 randi .003,1,.999
kdel4 = kdel4 + .05
addl4 delayr .2
agr2 deltapi kdel4
delayw aglobrev

arevl = agr1+afeed1
arevr = agr2+afeed2
aout1 = (ain1*korig)+(arevl*krev)
aout2 = (ain2*korig)+(arevr*krev)

xout	aout1,aout2


	endop
	opcode blueEffect2,aa,aa

ain1,ain2	xin
aout1	butterlp ain1, sr/2
aout2	butterlp ain2, sr/2

xout	aout1,aout2


	endop


	instr 4	;Mode 6 - Tibetan Bowl 140mm
;	print	p3
idur	init	p3*3
	xtratim	idur
;p3	= p3 * 3
;idur	= p3
;	print idur
ipch 	getFrequency p4
iamp	= ampdb(p5)
iSpace	= p7
iQ    = 2000.0
imaxdel = 1/ipch
;INSERT SOUND GENERATION CODE HERE
inummodes = 1 + 1 + 1 + 1 + 1 + 0
;--- old code
;aexc 	mpulse 	inummodes, 0
;--- new code
ifreq11	=	80
iQ11	=	8
ifreq12	=	180
iQ12	=	3
ashock	mpulse 	1, 0
aexc1	mode	ashock, ifreq11, iQ11
aexc1	=	aexc1*iamp
aexc2 	mode	ashock, ifreq12, iQ12
aexc2	=	aexc2*iamp
aexc	=	(aexc1+aexc2)/2
; "Contact" condition : when aexc reaches 0, the excitator loses 
; contact with the resonator, and stops "pushing it"
aexc	limit	aexc, 0, iamp/inummodes
;--- end of new code
aout = 0
if (1 == 1) then
	aout0 mode aexc * 1.0, ipch * 1.0, iQ * 1.0
	aout sum aout, aout0
endif
if (1 == 1) then
	aout1 mode aexc  * 1.0, ipch * 2.76515, iQ * 0.361644
	aout sum aout, aout1
endif
if (1 == 1) then
	aout2 mode aexc  * 1.0, ipch * 5.12121, iQ * 0.19526635
	aout sum aout, aout2
endif
if (1 == 1) then
	aout3 mode aexc  * 1.0, ipch * 7.80681, iQ * 0.12809329
	aout sum aout, aout3
endif
if (1 == 1) then
	aout4 mode aexc  * 1.0, ipch * 10.78409, iQ * 0.09272919
	aout sum aout, aout4
endif
if (0 == 1) then
	aout5 mode aexc  * 1.0, ipch * 1.0, iQ * 1.0
	aout sum aout, aout5
endif
;aout	=	aout * iamp
kenv	linen	iamp, 0, idur, 0.2
aout	=	aout * kenv
;END SOUND GENERATION CODE
aLeft, aRight	panner iSpace, aout
ga_bluemix_4_0 = ga_bluemix_4_0 +  aLeft
ga_bluemix_4_1 = ga_bluemix_4_1 +  aRight

	endin

	instr 5	;oscillator
idur	=	p3				; duration
iamp	=	ampdb(p4)			; amplitude
ifn	=	p5				; function table number
ifreq	=	p6
ipan	=	p7				; -1 to 1
irise	=	p8
ifall	=	p9
kenv	linen	iamp, irise, idur, ifall
asig	poscil3	kenv, ifreq, ifn
aout	dcblock	asig
aLeft, aRight	yipan	ipan, aout
ga_bluemix_5_0 = ga_bluemix_5_0 + 	aLeft
ga_bluemix_5_1 = ga_bluemix_5_1 +  aRight

	endin

	instr 8	;Mode 6 - Tibetan Bowl 180mm
p3	= p3 * 2
idur	= p3
ipch 	getFrequency p4
iamp	= ampdb(p5)
iSpace	= p7
iQ    = 2000.0
imaxdel = 1/ipch
;INSERT SOUND GENERATION CODE HERE
inummodes = 1 + 1 + 1 + 1 + 1 + 1 + 1
;--- old code
;aexc 	mpulse 	inummodes, 0
;--- new code
ifreq11	=	80
iQ11	=	8
ifreq12	=	180
iQ12	=	3
ashock	mpulse 	1, 0
aexc1	mode	ashock, ifreq11, iQ11
aexc1	=	aexc1*iamp
aexc2 	mode	ashock, ifreq12, iQ12
aexc2	=	aexc2*iamp
aexc	=	(aexc1+aexc2)/2
; "Contact" condition : when aexc reaches 0, the excitator loses 
; contact with the resonator, and stops "pushing it"
aexc	limit	aexc, 0, iamp/inummodes
;--- end of new code
aout = 0
if (1 == 1) then
	aout0 mode aexc * 1.0, ipch * 1.0, iQ * 1.0
	aout sum aout, aout0
endif
if (1 == 1) then
	aout1 mode aexc  * 1.0, ipch * 2.77828, iQ * 0.35993493
	aout sum aout, aout1
endif
if (1 == 1) then
	aout2 mode aexc  * 1.0, ipch * 5.18099, iQ * 0.19301331
	aout sum aout, aout2
endif
if (1 == 1) then
	aout3 mode aexc  * 1.0, ipch * 8.16289, iQ * 0.122505635
	aout sum aout, aout3
endif
if (1 == 1) then
	aout4 mode aexc  * 1.0, ipch * 11.66063, iQ * 0.085758656
	aout sum aout, aout4
endif
if (1 == 1) then
	aout5 mode aexc  * 1.0, ipch * 15.63801, iQ * 0.063946754
	aout sum aout, aout5
endif
if (1 == 1) then
	aout6 mode aexc  * 1.0, ipch * 19.99, iQ * 0.050025012
	aout sum aout, aout6
endif
;aout	=	aout * iamp
kenv	linen	iamp, 0, idur, 0.2
aout	=	aout * kenv
;END SOUND GENERATION CODE
aLeft, aRight	panner iSpace, aout
ga_bluemix_8_0 = ga_bluemix_8_0 +  aLeft
ga_bluemix_8_1 = ga_bluemix_8_1 +  aRight

	endin

	instr 9	;Mode 6 - Tibetan Bowl 152mm
p3	= p3 * 2
idur	= p3
ipch 	getFrequency p4
iamp	= ampdb(p5)
iSpace	= p7
iQ    = 2000.0
imaxdel = 1/ipch
;INSERT SOUND GENERATION CODE HERE
inummodes = 1 + 1 + 1 + 1 + 1 + 1 + 1
;--- old code
;aexc 	mpulse 	inummodes, 0
;--- new code
ifreq11	=	80
iQ11	=	8
ifreq12	=	180
iQ12	=	3
ashock	mpulse 	1, 0
aexc1	mode	ashock, ifreq11, iQ11
aexc1	=	aexc1*iamp
aexc2 	mode	ashock, ifreq12, iQ12
aexc2	=	aexc2*iamp
aexc	=	(aexc1+aexc2)/2
; "Contact" condition : when aexc reaches 0, the excitator loses 
; contact with the resonator, and stops "pushing it"
aexc	limit	aexc, 0, iamp/inummodes
;--- end of new code
aout = 0
if (1 == 1) then
	aout0 mode aexc * 1.0, ipch * 1.0, iQ * 1.0
	aout sum aout, aout0
endif
if (1 == 1) then
	aout1 mode aexc  * 1.0, ipch * 2.66242, iQ * 0.37559813
	aout sum aout, aout1
endif
if (1 == 1) then
	aout2 mode aexc  * 1.0, ipch * 4.83757, iQ * 0.20671536
	aout sum aout, aout2
endif
if (1 == 1) then
	aout3 mode aexc  * 1.0, ipch * 7.51592, iQ * 0.1330509
	aout sum aout, aout3
endif
if (1 == 1) then
	aout4 mode aexc  * 1.0, ipch * 10.64012, iQ * 0.0939839
	aout sum aout, aout4
endif
if (1 == 1) then
	aout5 mode aexc  * 1.0, ipch * 14.21019, iQ * 0.07037204
	aout sum aout, aout5
endif
if (1 == 1) then
	aout6 mode aexc  * 1.0, ipch * 18.14027, iQ * 0.05512597
	aout sum aout, aout6
endif
;aout	=	aout * iamp
kenv	linen	iamp, 0, idur, 0.2
aout	=	aout * kenv
;END SOUND GENERATION CODE
aLeft, aRight	panner iSpace, aout
ga_bluemix_9_0 = ga_bluemix_9_0 +  aLeft
ga_bluemix_9_1 = ga_bluemix_9_1 +  aRight

	endin

	instr 10	;French Horn (Horner and Ayers) - subinstrument version
ipch 	getFrequency p4
ipch2 	getFrequency p5

kpchline 	line ipch, p3, ipch2

iamp	= p6
iSpace	= p7
ienvType	= p8

kenv	yiEnvelope ienvType, .15, .1, .95, .2

; INSERT SOUND GENERATING CODE HERE 

ifcut	= 2560		; LP FILTER CUTOFF FREQUENCY


kenv2	=		kenv * kenv 			; WAVETABLE ENVELOPES
kenv3	=		kenv2 * kenv
kenv4	=		kenv3 * kenv

irange	tablei	ipch, 1104
iwt1	=	gi_sine					; WAVETABLE NUMBERS
iwt2	table	(irange*4), 1103
iwt3	table	(irange*4)+1, 1103
iwt4	table	(irange*4)+2, 1103
inorm	table	(irange*4)+3, 1103		; NORMALIZATION FACTOR

iiwt1 			=			iwt1
iiwt2 			=			iwt2 + 1100
iiwt3 			=			iwt3 + 1100
iiwt4 			=			iwt4 + 1100

iphase	= gi_horn_seed				; SAME PHASE FOR ALL TABLES
giseed	= frac(gi_horn_seed*105.947)

awt1	oscil	kenv, kpchline, iiwt1, iphase ; WAVETABLE LOOKUP
awt2	oscil	kenv2, kpchline, iiwt2, iphase
awt3	oscil	kenv3, kpchline, iiwt3, iphase
awt4	oscil	kenv4, kpchline, iiwt4, iphase
aout	=		(awt1+awt2+awt3+awt4)*iamp/inorm

afilt	tone	aout, ifcut			; LP FILTER...
asig	balance	afilt, aout			; ... TO CONTROL BRIGHTNESS

aport	oscil	1, p3/10, gi_sine
aport	=	(aport * 0.02) + 1
aout	=	asig * aport
	
outs	aout, aout

	endin

	instr 11	;combination tone horns 
idur	=       abs(p3)                 ; duration
iamp	=       ampdb(p4)             	; amplitude
ifn	=       p5                      ; function table number (waveform)
ipch1	=	p6			; primary pitch (as a frequency)
immm	=	p7			; numerator of dyad
innn	=	p8			; denominator of dyad
ipan	=	p9			; 1.0 = left <-> 0.0 = right
iflag	=	p10			; 1 => use periodicity pitch, 0 => don't use it
irise 	=	p11
ifall	=	p12
ienv	=	p13
ipch2	=	ipch1*(immm/innn)	; secondary pitch (primary * ratio)
idiff	=	ipch2-ipch1		; difference tone
idiff2	=	(2*ipch2)-ipch1		; 2nd order difference tone
idiff3	=	(3*ipch2)-(2*ipch1)	; 3rd order difference tone
iper	=	ipch1/innn		; periodicity pitch, shifted up one 8ve
isum	=	ipch1+ipch2		; summation tone
isum2	=	(2*ipch1)+ipch2		; 2nd order summation tone
	prints	"ipch1=%f ipch2=%f idiff=%f idiff2=%f idiff3=%f iper=%f isum=%f isum2=%f\\n", \
		ipch1, ipch2, idiff, idiff2, idiff3, iper, isum, isum2
ihorn	=		10
asig1	subinstr	ihorn, ipch1, ipch1, iamp, 0, ienv
asig2	subinstr	ihorn, ipch2, ipch2, iamp, 0, ienv
adiff	subinstr	ihorn, idiff, idiff, iamp, 0, ienv
adiff2	subinstr	ihorn, idiff2, idiff2, iamp, 0, ienv
adiff3	subinstr	ihorn, idiff3, idiff3, iamp, 0, ienv
aper	subinstr	ihorn, iper, iper, iamp, 0, ienv
asum	subinstr	ihorn, isum, isum, iamp, 0, ienv
asum2	subinstr	ihorn, isum2, isum2, iamp, 0, ienv
	if (iflag == 0) then
		goto NO_PERIODICITY_PITCH
	endif
asig	sum	asig1, asig2, adiff, adiff2, adiff3, asum, asum2, aper
	goto	OUT
NO_PERIODICITY_PITCH:
asig	sum	asig1, asig2, adiff, adiff2, adiff3, asum, asum2
OUT:
aout	dcblock	asig
al,ar	yipan	ipan, aout
ga_bluemix_11_0 = ga_bluemix_11_0 + 	al
ga_bluemix_11_1 = ga_bluemix_11_1 +  ar

	endin

	instr 12	;Blue Mixer Instrument
ga_bluesub_SubChannel1_0	sum	ga_bluesub_SubChannel1_0, ga_bluemix_4_0
ga_bluesub_SubChannel1_1	sum	ga_bluesub_SubChannel1_1, ga_bluemix_4_1
ga_bluesub_SubChannel1_0	sum	ga_bluesub_SubChannel1_0, ga_bluemix_9_0
ga_bluesub_SubChannel1_1	sum	ga_bluesub_SubChannel1_1, ga_bluemix_9_1
ga_bluesub_SubChannel1_0	sum	ga_bluesub_SubChannel1_0, ga_bluemix_11_0
ga_bluesub_SubChannel1_1	sum	ga_bluesub_SubChannel1_1, ga_bluemix_11_1
ga_bluemix_5_0 = ga_bluemix_5_0 * 0.5623413324
ga_bluemix_5_1 = ga_bluemix_5_1 * 0.5623413324
ga_bluemix_5_0, ga_bluemix_5_1	blueEffect0	ga_bluemix_5_0, ga_bluemix_5_1
ga_bluesub_Master_0	sum	ga_bluesub_Master_0, ga_bluemix_5_0
ga_bluesub_Master_1	sum	ga_bluesub_Master_1, ga_bluemix_5_1
ga_bluesub_Master_0	sum	ga_bluesub_Master_0, ga_bluemix_8_0
ga_bluesub_Master_1	sum	ga_bluesub_Master_1, ga_bluemix_8_1
ga_bluesub_Master_0	sum	ga_bluesub_Master_0, ga_bluemix_10_0
ga_bluesub_Master_1	sum	ga_bluesub_Master_1, ga_bluemix_10_1
ga_bluesub_SubChannel1_0 = ga_bluesub_SubChannel1_0 * 0.9549925923
ga_bluesub_SubChannel1_1 = ga_bluesub_SubChannel1_1 * 0.9549925923
ga_bluesub_SubChannel1_0, ga_bluesub_SubChannel1_1	blueEffect1	ga_bluesub_SubChannel1_0, ga_bluesub_SubChannel1_1
ga_bluesub_Master_0	sum	ga_bluesub_Master_0, ga_bluesub_SubChannel1_0
ga_bluesub_Master_1	sum	ga_bluesub_Master_1, ga_bluesub_SubChannel1_1
ga_bluesub_Master_0, ga_bluesub_Master_1	blueEffect2	ga_bluesub_Master_0, ga_bluesub_Master_1
ga_bluesub_Master_0 = ga_bluesub_Master_0 * 2.81838274
ga_bluesub_Master_1 = ga_bluesub_Master_1 * 2.81838274
outc ga_bluesub_Master_0, ga_bluesub_Master_1
ga_bluemix_4_0 = 0
ga_bluemix_4_1 = 0
ga_bluemix_5_0 = 0
ga_bluemix_5_1 = 0
ga_bluemix_8_0 = 0
ga_bluemix_8_1 = 0
ga_bluemix_9_0 = 0
ga_bluemix_9_1 = 0
ga_bluemix_10_0 = 0
ga_bluemix_10_1 = 0
ga_bluemix_11_0 = 0
ga_bluemix_11_1 = 0
ga_bluesub_SubChannel1_0 = 0
ga_bluesub_SubChannel1_1 = 0
ga_bluesub_Master_0 = 0
ga_bluesub_Master_1 = 0

	endin


</CsInstruments>

<CsScore>



t 0 45


;Horner and Ayers French Horn tables
f 1101 0   4097    -9  1 1.0 0
f 1102 0   16  -2  40 40 80 160 320 640 1280 2560 5120 10240 10240  ;LP Filter Cutoff Lookup table
f 1103 0   64  -2  11 12 13 52.476 14 15 16 18.006 17 18 19 11.274 20 21 22 6.955 23 24 25 2.260 26 27 10 1.171 28 29 10 1.106 30 10 10 1.019
f 1104 0   2048    -17 0 0 85 1 114 2 153 3 204 4 272 5 364 6 486 7
f 1110    0   5   -9  1 0.0 0
f 1111    0   4097    -9  2 6.236 0 3 12.827 0
f 1112    0   4097    -9  4 21.591 0 5 11.401 0 6 3.570 0 7 2.833 0
f 1113    0   4097    -9  8 3.070 0 9 1.053 0 10 0.773 0 11 1.349 0 12 0.819 0 13 0.369 0 14 0.362 0 15 0.165 0 16 0.124 0 18 0.026 0 19 0.042 0
f 1114    0   4097    -9  2 3.236 0 3 6.827 0
f 1115    0   4097    -9  4 5.591 0 5 2.401 0 6 1.870 0 7 0.733 0
f 1116    0   4097    -9  8 0.970 0 9 0.553 0 10 0.373 0 11 0.549 0 12 0.319 0 13 0.119 0 14 0.092 0 15 0.045 0 16 0.034 0
f 1117    0   4097    -9  2 5.019 0 3 4.281 0
f 1118    0   4097    -9  4 2.091 0 5 1.001 0 6 0.670 0 7 0.233 0
f 1119    0   4097    -9  8 0.200 0 9 0.103 0 10 0.073 0 11 0.089 0 12 0.059 0 13 0.029 0
f 1120    0   4097    -9  2 4.712 0 3 1.847 0
f 1121    0   4097    -9  4 0.591 0 5 0.401 0 6 0.270 0 7 0.113 0
f 1122    0   4097    -9  8 0.060 0 9 0.053 0 10 0.023 0
f 1123    0   4097    -9  2 1.512 0 3 0.247 0
f 1124    0   4097    -9  4 0.121 0 5 0.101 0 6 0.030 0 7 0.053 0
f 1125    0   4097    -9  8 0.030 0
f 1126    0   4097    -9  2 0.412 0 3 0.087 0
f 1127    0   4097    -9  4 0.071 0 5 0.021 0
f 1128    0   4097    -9  2 0.309 0 3 0.067 0
f 1129    0   4097    -9  4 0.031 0
f 1130    0   4097    -9  2 0.161 0 3 0.047 0




i5	0.0	10	62	2	120.0	-0.7	2	3
i5	0.0	10	62	2	121.875	0.7	2	3
i5	3.0	7	58	2	161.25	-0.8	2	3
i5	3.0	7	58	2	213.75	0.8	2	3
i5	10.0	10	62	2	120.0	-0.7	2	3
i5	10.0	10	62	2	121.875	0.7	2	3
i5	13.0	7	58	2	161.25	-0.8	2	3
i5	13.0	7	58	2	213.75	0.8	2	3
i5	20.0	10	62	2	120.0	-0.7	2	3
i5	20.0	10	62	2	121.875	0.7	2	3
i5	23.0	7	58	2	161.25	-0.8	2	3
i5	23.0	7	58	2	213.75	0.8	2	3
i5	30.0	10	62	2	120.0	-0.7	2	3
i5	30.0	10	62	2	121.875	0.7	2	3
i5	33.0	7	58	2	161.25	-0.8	2	3
i5	33.0	7	58	2	213.75	0.8	2	3
i5	40.0	10	62	2	120.0	-0.7	2	3
i5	40.0	10	62	2	121.875	0.7	2	3
i5	43.0	7	58	2	161.25	-0.8	2	3
i5	43.0	7	58	2	213.75	0.8	2	3
i5	50.0	10	62	2	120.0	-0.7	2	3
i5	50.0	10	62	2	121.875	0.7	2	3
i5	53.0	7	58	2	161.25	-0.8	2	3
i5	53.0	7	58	2	213.75	0.8	2	3
i5	60.0	10	62	2	120.0	-0.7	2	3
i5	60.0	10	62	2	121.875	0.7	2	3
i5	63.0	7	58	2	161.25	-0.8	2	3
i5	63.0	7	58	2	213.75	0.8	2	3
i5	70.0	10	62	2	120.0	-0.7	2	3
i5	70.0	10	62	2	121.875	0.7	2	3
i5	73.0	7	58	2	161.25	-0.8	2	3
i5	73.0	7	58	2	213.75	0.8	2	3
i5	80.0	10	62	2	120.0	-0.7	2	3
i5	80.0	10	62	2	121.875	0.7	2	3
i5	83.0	7	58	2	161.25	-0.8	2	3
i5	83.0	7	58	2	213.75	0.8	2	3
i5	90.0	10	62	2	120.0	-0.7	2	3
i5	90.0	10	62	2	121.875	0.7	2	3
i5	93.0	7	58	2	161.25	-0.8	2	3
i5	93.0	7	58	2	213.75	0.8	2	3
i5	100.0	10	62	2	120.0	-0.7	2	3
i5	100.0	10	62	2	121.875	0.7	2	3
i5	103.0	7	58	2	161.25	-0.8	2	3
i5	103.0	7	58	2	213.75	0.8	2	3
i5	110.0	10	62	2	120.0	-0.7	2	3
i5	110.0	10	62	2	121.875	0.7	2	3
i5	113.0	7	58	2	161.25	-0.8	2	3
i5	113.0	7	58	2	213.75	0.8	2	3
i5	120.0	10	62	2	120.0	-0.7	2	3
i5	120.0	10	62	2	121.875	0.7	2	3
i5	123.0	7	58	2	161.25	-0.8	2	3
i5	123.0	7	58	2	213.75	0.8	2	3
i11	5.0	10	58	1	240	1.324717957	1	0	1	3	3	1
i11	15.0	10	58	1	240	1.324717957	1	0	1	3	3	1
i11	25.0	10	58	1	240	1.324717957	1	0	1	3	3	1
i11	35.0	10	58	1	240	1.324717957	1	0	1	3	3	1
i11	45.0	10	58	1	240	1.324717957	1	0	1	3	3	1
i11	55.0	10	58	1	240	1.324717957	1	0	1	3	3	1
i11	65.0	10	58	1	240	1.324717957	1	0	1	3	3	1
i11	75.0	10	58	1	240	1.324717957	1	0	1	3	3	1
i11	85.0	10	58	1	240	1.324717957	1	0	1	3	3	1
i11	95.0	10	58	1	240	1.324717957	1	0	1	3	3	1
i11	105.0	10	58	1	240	1.324717957	1	0	1	3	3	1
i11	115.0	10	58	1	240	1.324717957	1	0	1	3	3	1
i11	125.0	10	58	1	240	1.324717957	1	0	1	3	3	1
i9	28.0	2.1578948498	240.0	29	0	0.5
i9	28.0	2.1578948498	270.0	29	0	0.5
i9	30.157894	2.1578948498	270.0	29	0	0.5
i9	30.157894	2.1578948498	283.125	29	0	0.5
i9	32.31579	2.1578948498	360.0	29	0	0.5
i9	32.31579	2.1578948498	283.125	29	0	0.5
i9	34.473686	2.1578948498	375.0	29	0	0.5
i9	34.473686	2.1578948498	360.0	29	0	0.5
i9	36.63158	2.1578948498	283.125	29	0	0.5
i9	36.63158	2.1578948498	375.0	29	0	0.5
i9	38.789474	2.1578948498	270.0	29	0	0.5
i9	38.789474	2.1578948498	360.0	29	0	0.5
i9	40.94737	2.1578948498	283.125	29	0	0.5
i9	43.105263	2.1578948498	240.0	29	0	0.5
i9	40.94737	2.1578948498	240.0	29	0	0.5
i9	43.105263	2.1578948498	360.0	29	0	0.5
i9	45.26316	2.1578948498	270.0	29	0	0.5
i9	45.26316	2.1578948498	375.0	29	0	0.5
i9	47.42105	2.1578948498	375.0	29	0	0.5
i9	47.42105	2.1578948498	240.0	29	0	0.5
i9	49.57895	2.1578948498	360.0	29	0	0.5
i9	49.57895	2.1578948498	240.0	29	0	0.5
i9	51.736843	2.1578948498	375.0	29	0	0.5
i9	51.736843	2.1578948498	270.0	29	0	0.5
i9	53.894737	2.1578948498	375.0	29	0	0.5
i9	53.894737	2.1578948498	283.125	29	0	0.5
i9	56.052635	2.1578948498	270.0	29	0	0.5
i9	56.052635	2.1578948498	360.0	29	0	0.5
i9	58.210526	2.1578948498	283.125	29	0	0.5
i9	58.210526	2.1578948498	240.0	29	0	0.5
i9	60.368423	2.1578948498	270.0	29	0	0.5
i9	60.368423	2.1578948498	240.0	29	0	0.5
i9	62.526318	2.1578948498	283.125	29	0	0.5
i9	62.526318	2.1578948498	270.0	29	0	0.5
i9	64.68421	2.1578948498	360.0	29	0	0.5
i9	64.68421	2.1578948498	283.125	29	0	0.5
i9	66.8421	2.1578948498	375.0	29	0	0.5
i9	66.8421	2.1578948498	360.0	29	0	0.5
i9	107.8421	2.1578948498	240.0	29	0	0.5
i9	107.8421	2.1578948498	270.0	29	0	0.5
i9	105.68421	2.1578948498	270.0	29	0	0.5
i9	105.68421	2.1578948498	283.125	29	0	0.5
i9	103.52632	2.1578948498	360.0	29	0	0.5
i9	103.52632	2.1578948498	283.125	29	0	0.5
i9	101.36842	2.1578948498	375.0	29	0	0.5
i9	101.36842	2.1578948498	360.0	29	0	0.5
i9	99.210526	2.1578948498	283.125	29	0	0.5
i9	99.210526	2.1578948498	375.0	29	0	0.5
i9	97.052635	2.1578948498	270.0	29	0	0.5
i9	97.052635	2.1578948498	360.0	29	0	0.5
i9	94.89474	2.1578948498	283.125	29	0	0.5
i9	94.89474	2.1578948498	240.0	29	0	0.5
i9	92.73685	2.1578948498	240.0	29	0	0.5
i9	92.73685	2.1578948498	360.0	29	0	0.5
i9	90.57895	2.1578948498	270.0	29	0	0.5
i9	90.57895	2.1578948498	375.0	29	0	0.5
i9	88.42105	2.1578948498	375.0	29	0	0.5
i9	88.42105	2.1578948498	240.0	29	0	0.5
i9	86.26316	2.1578948498	360.0	29	0	0.5
i9	86.26316	2.1578948498	240.0	29	0	0.5
i9	84.10526	2.1578948498	375.0	29	0	0.5
i9	84.10526	2.1578948498	270.0	29	0	0.5
i9	81.94737	2.1578948498	375.0	29	0	0.5
i9	81.94737	2.1578948498	283.125	29	0	0.5
i9	79.789474	2.1578948498	270.0	29	0	0.5
i9	79.789474	2.1578948498	360.0	29	0	0.5
i9	77.63158	2.1578948498	283.125	29	0	0.5
i9	77.63158	2.1578948498	240.0	29	0	0.5
i9	75.47369	2.1578948498	270.0	29	0	0.5
i9	75.47369	2.1578948498	240.0	29	0	0.5
i9	73.31579	2.1578948498	283.125	29	0	0.5
i9	73.31579	2.1578948498	270.0	29	0	0.5
i9	71.1579	2.1578948498	360.0	29	0	0.5
i9	71.1579	2.1578948498	283.125	29	0	0.5
i9	69.0	2.1578948498	375.0	29	0	0.5
i9	69.0	2.1578948498	360.0	29	0	0.5
i4	28.0	2	480.0	32	0	-0.5
i4	28.0	2	540.0	32	0	-0.5
i4	30.0	2	540.0	32	0	-0.5
i4	30.0	2	566.25	32	0	-0.5
i4	32.0	2	566.25	32	0	-0.5
i4	32.0	2	645.0	32	0	-0.5
i4	34.0	2	645.0	32	0	-0.5
i4	34.0	2	720.0	32	0	-0.5
i4	36.0	2	750.0	32	0	-0.5
i4	36.0	2	720.0	32	0	-0.5
i4	38.0	2	855.0	32	0	-0.5
i4	38.0	2	750.0	32	0	-0.5
i4	40.0	2	855.0	32	0	-0.5
i4	40.0	2	720.0	32	0	-0.5
i4	42.0	2	750.0	32	0	-0.5
i4	42.0	2	645.0	32	0	-0.5
i4	44.0	2	566.25	32	0	-0.5
i4	44.0	2	720.0	32	0	-0.5
i4	46.0	2	540.0	32	0	-0.5
i4	46.0	2	645.0	32	0	-0.5
i4	48.0	2	480.0	32	0	-0.5
i4	48.0	2	566.25	32	0	-0.5
i4	50.0	2	645.0	32	0	-0.5
i4	50.0	2	480.0	32	0	-0.5
i4	52.0	2	720.0	32	0	-0.5
i4	52.0	2	540.0	32	0	-0.5
i4	54.0	2	750.0	32	0	-0.5
i4	54.0	2	566.25	32	0	-0.5
i4	56.0	2	645.0	32	0	-0.5
i4	56.0	2	855.0	32	0	-0.5
i4	58.0	2	566.25	32	0	-0.5
i4	58.0	2	855.0	32	0	-0.5
i4	60.0	2	750.0	32	0	-0.5
i4	60.0	2	540.0	32	0	-0.5
i4	62.0	2	720.0	32	0	-0.5
i4	62.0	2	480.0	32	0	-0.5
i4	64.0	2	480.0	32	0	-0.5
i4	64.0	2	750.0	32	0	-0.5
i4	66.0	2	855.0	32	0	-0.5
i4	66.0	2	540.0	32	0	-0.5
i4	68.0	2	855.0	32	0	-0.5
i4	68.0	2	480.0	32	0	-0.5
i4	70.0	2	750.0	32	0	-0.5
i4	70.0	2	480.0	32	0	-0.5
i4	72.0	2	855.0	32	0	-0.5
i4	72.0	2	540.0	32	0	-0.5
i4	74.0	2	855.0	32	0	-0.5
i4	74.0	2	566.25	32	0	-0.5
i4	76.0	2	750.0	32	0	-0.5
i4	76.0	2	540.0	32	0	-0.5
i4	78.0	2	720.0	32	0	-0.5
i4	78.0	2	480.0	32	0	-0.5
i4	80.0	2	645.0	32	0	-0.5
i4	80.0	2	480.0	32	0	-0.5
i4	82.0	2	540.0	32	0	-0.5
i4	82.0	2	720.0	32	0	-0.5
i4	84.0	2	566.25	32	0	-0.5
i4	84.0	2	750.0	32	0	-0.5
i4	86.0	2	645.0	32	0	-0.5
i4	86.0	2	855.0	32	0	-0.5
i4	88.0	2	855.0	32	0	-0.5
i4	88.0	2	720.0	32	0	-0.5
i4	90.0	2	750.0	32	0	-0.5
i4	90.0	2	645.0	32	0	-0.5
i4	92.0	2	720.0	32	0	-0.5
i4	92.0	2	566.25	32	0	-0.5
i4	94.0	2	645.0	32	0	-0.5
i4	94.0	2	540.0	32	0	-0.5
i4	96.0	2	566.25	32	0	-0.5
i4	96.0	2	480.0	32	0	-0.5
i4	98.0	2	540.0	32	0	-0.5
i4	98.0	2	480.0	32	0	-0.5
i4	100.0	2	540.0	32	0	-0.5
i4	100.0	2	566.25	32	0	-0.5
i4	102.0	2	566.25	32	0	-0.5
i4	102.0	2	645.0	32	0	-0.5
i4	104.0	2	645.0	32	0	-0.5
i4	104.0	2	720.0	32	0	-0.5
i4	106.0	2	750.0	32	0	-0.5
i4	106.0	2	720.0	32	0	-0.5
i4	108.0	2	855.0	32	0	-0.5
i4	108.0	2	750.0	32	0	-0.5
i12	0	138	
e

</CsScore>

</CsoundSynthesizer>