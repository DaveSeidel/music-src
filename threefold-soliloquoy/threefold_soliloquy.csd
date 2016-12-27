<CsoundSynthesizer>

;; Threefold Soliloquy
;; Dave Seidel, 2015
;; Copyright 2015 Dave Seidel, some rights reserved.
;; Licensed under CC BY-NC-SA 3.0 (http://creativecommons.org/licenses/by-nc-sa/3.0/).

<CsOptions>
-o dac
</CsOptions>

<CsInstruments>

sr = 48000
ksmps = 16
nchnls = 2
0dbfs = 1.0

; sine
giSin = ftgen(1, 0, 2^19, 10, 1)

; array of transposition values
gktrans[] init 3

instr Player
	idur = p3					; duration
	iamp = ampdb(p4)		; amplitude
	ifn  = p5					; function table number
	kfreq = p6					; frequency
	ipan = p7					; pan (0 to 1)
	irise = p8					; env rise
	ifall = p9					; env fall
	irange = p10				; range (+/-)
	irate = p11				; rate
	iidx = p12					; transposition index

	seed(0)
	kenv = linen(iamp, irise, idur, ifall)
	krnd = trandom(metro:k(rnd(irate)), 0-irange, irange)
	aout = poscil3(kenv, (kfreq * gktrans[iidx]) + krnd, ifn)
	aLeft, aRight pan2 aout, ipan
	outs(aLeft, aRight)
endin

instr Transposer
	iidx = p4					; transposition index
	krate = p5					; rate
	ilo = p6						; lower limit of transposition range
	ihi = p7						; upper limit of transposition range
	
	seed(0)
	kfreq = trandom(metro(krate), ilo, ihi)
	gktrans[iidx] = kfreq
endin

</CsInstruments>

<CsScore>

t 0 30

#define DUR    # [60*60] #

#define MIDDLE # 240 #
#define HIGH   # [$MIDDLE.*(27/14)] #
#define LOW    # [$MIDDLE.*(14/27)] #

; middle pitch
;                                          pan  rise fall rng  rate  idx
i "Player"     0  $DUR.  -17  1  $MIDDLE.  0.5  5    8    0.7  0.15  0
i "Player"     0  .      .    .  .         .    .    .    .    .     .
i "Player"     0  .      .    .  .         .    .    .    .    .     .

; high pitch
i "Player"     0  .      -22  1  $HIGH.    0.3  .    .    1.5  0.2   1
i "Player"     0  .      .    .  .         .    .    .    .    .     .
i "Player"     0  .      .    .  .         .    .    .    .    .     .

; low pitch
i "Player"     0  .      -15  1  $LOW.     0.7  .    .    0.3  0.1   2
i "Player"     0  .      .    .  .         .    .    .    .    .     .
i "Player"     0  .      .    .  .         .    .    .    .    .     .

; middle
i "Transposer" 0  $DUR   0  0.05  [41/43]  [43/41]

; high
i "Transposer" 0  .      1  0.07  [17/19]  [19/17]

; low
i "Transposer" 0  .      2  0.03  [29/31]  [31/19]

e

</CsScore>

</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
