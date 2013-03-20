;-------------------------------------------------------------------------
;
; Sublimation
; by Dave Seidel
; http://mysterybear.net
; http://soundcloud.com/mysterybear
; http://mysterybear.bandcamp.com
;
; Copyright 2006,2013, Dave Seidel. Some rights reserved.
; This work is licensed under the Creative Commons Attribution-
; NonCommercial-ShareAlike 3.0 Unported License.
; http://creativecommons.org/licenses/by-nc-sa/3.0/
;
;-------------------------------------------------------------------------

<CsoundSynthesizer>
<CsOptions>

-3 -W -o Sublimation.wav

</CsOptions>
<CsInstruments>

;-------------------------------------------------------------------------
; globals
;-------------------------------------------------------------------------

sr      = 96000
ksmps   = 1
nchnls  = 2
0dbfs   = 1

;-------------------------------------------------------------------------
; global reverb sends
;-------------------------------------------------------------------------

gaL   init  0
gaR   init  0

;-------------------------------------------------------------------------
; function tables for waveforms
;-------------------------------------------------------------------------

; power of 2 + guard
giTblSz init  524288+1

; sine
giFn1   ftgen 1, 0, giTblSz, 10, 1


;---------------------------------------------------------------------------
; global reverb instrument
;---------------------------------------------------------------------------

instr 1

aL, aR  reverbsc  gaL, gaR, p4, p5, sr/1.5, p6, 0
  outs  gaL+aL, gaR+aR
gaL = 0
gaR = 0

endin

;---------------------------------------------------------------------------------------
; combination tone chord organ: given a note and a ratio, produces the chord formed
; by that interval plus the set of notes equivalent to the combination tones produced
; by that interval
;---------------------------------------------------------------------------------------

instr 2

idur    = p3                  ; duration
iamp    = ampdb(p4)/7         ; amplitude
ifn     = p5                  ; function table number (waveform)
ipch1   = p6                  ; primary pitch (as a frequency)
immm    = p7                  ; numerator of dyad
innn    = p8                  ; denominator of dyad
ilr     = p9                  ; 1.0 = left <-> 0.0 = right
iflag   = p10                 ; 1 => use periodicity pitch, 0 => don't use it

ipch2   = ipch1*(immm/innn)   ; secondary pitch (primary * ratio)
idiff   = ipch2-ipch1         ; difference tone
idiff2  = (2*ipch2)-ipch1     ; 2nd order difference tone
idiff3  = (3*ipch2)-(2*ipch1) ; 3rd order difference tone
iper    = ipch1/innn          ; periodicity pitch, shifted up one 8ve
isum    = ipch1+ipch2         ; summation tone
isum2   = (2*ipch1)+ipch2     ; 2nd order summation tone

  prints  "\\n%d:%d (%f) %f - %f %f %f - %f %f - %f[%d]\\n", \
          immm, innn, ipch1, ipch2, idiff, idiff2, idiff3, isum, isum2, iper, iflag

ae      linen iamp, 10, idur, 10    ; amplitude envelope

;asig1   poscil3  ke, ipch1, ifn
asig2   poscil3 ae, ipch2, ifn
adiff   poscil3 ae, idiff, ifn
adiff2  poscil3 ae, idiff2, ifn
adiff3  poscil3 ae, idiff3, ifn
aper    poscil3 ae, iper, ifn
asum    poscil3 ae, isum, ifn
asum2   poscil3 ae, isum2, ifn

  if (iflag == 0) then
    goto NO_PERIODICITY_PITCH
  endif

aout    = asig2+adiff+adiff2+adiff3+aper+asum+asum2
  goto  OUT

NO_PERIODICITY_PITCH:
aout    = asig2+adiff+adiff2+adiff3+asum+asum2

OUT:
gaL		=		gaL+(aout*ilr)
gaR		=		gaR+(aout*(1-ilr))

endin

</CsInstruments>
<CsScore>

;---------------------------------------------------------------------------
; score macros
;---------------------------------------------------------------------------

; base pitch * ratio
#define PCH(B'M'N)  #[$B.*($M./$N.)]#

; duration of piece
#define DURATION    #[60*6]#

; amplitude
#define AMP         #-25#

;---------------------------------------------------------------------------
; score
;---------------------------------------------------------------------------

t 0 30

; global reverb
i 1 0 [$DURATION.+1] .95 15360 .2


; WTP Opening Chord
; combos, successively
i 2 0   [(60*4)-30] $AMP 1 $PCH.(30'4'1)  3  2  .9     1
i 2 .   .           .    . $PCH.(30'6'1)  7  6  .7     1
i 2 .   .           .    . $PCH.(30'7'1)  8  7  .5     1
i 2 .   .           .    . $PCH.(30'8'1)  9  8  .3     1
i 2 .   .           .    . $PCH.(30'9'1)  4  3  .1     1

; WTP Opening Chord
; combos against the base
i 2 30  [60*3]      .    1 30             4  1  .96    1
i 2 .   .           .    . .              6  .  .8     1
i 2 .   .           .    . .              7  .  .64    1
i 2 .   .           .    . .              8  .  .48    1
i 2 .   .           .    . .              9  .  .32    1
i 2 .   .           .    . .             12  .  .16    1

; WTP Magic Chord
; combos against the base
i 2 60  [(60*3)-30] .    1 1.875         81  1  1    0
i 2 .   .           .    . .             84  .  .875   0
i 2 .   .           .    . .            108  .  .75    0
i 2 .   .           .    . .            112  .  .625   0
i 2 .   .           .    . .            144  .  .5     0
i 2 .   .           .    . .            162  .  .375   0
i 2 .   .           .    . .            192  .  .25    0
i 2 .   .           .    . .            216  .  .125   0

; WTP Magic Opening Chord
; combos against the base
i 2 120 [60*3]      .    1 0.46875      512  1  .990   0
i 2 .   .           .    . .            567  .  .9186  0
i 2 .   .           .    . .            588  .  .8472  0
i 2 .   .           .    . .            756  .  .7758  0
i 2 .   .           .    . .            768  .  .7044  0
i 2 .   .           .    . .            784  .  .633   0
i 2 .   .           .    . .            896  .  .5616  0
i 2 .   .           .    . .           1008  .  .4902  0
i 2 .   .           .    . .           1024  .  .4188  0
i 2 .   .           .    . .           1134  .  .3474  0
i 2 .   .           .    . .           1152  .  .276   0
i 2 .   .           .    . .           1344  .  .2046  0
i 2 .   .           .    . .           1512  .  .1332  0
i 2 .   .           .    . .           1546  .  .0618  0

; WTP Magic Chord
; combos, successively
i 2 210 [(60*2)+15] .    1 $PCH.(1.875'81'1)  28 27  .8571 0
i 2 .   .           .    . $PCH.(1.875'84'1)   9  7  .7142 0
i 2 .   .           .    . $PCH.(1.875'108'1) 28 27  .5713 0
i 2 .   .           .    . $PCH.(1.875'112'1)  9  7  .4284 0
i 2 .   .           .    . $PCH.(1.875'144'1)  9  8  .2855 0
i 2 .   .           .    . $PCH.(1.875'162'1) 32 27  .1426 0
i 2 .   .           .    . $PCH.(1.875'192'1)  9  8  0     0

; WTP Opening Chord
; combos against the base
i 2 270 90          .    1 30             4  1  1      1
i 2 .   .           .    . .              6  .  .8     1
i 2 .   .           .    . .              7  .  .6     1
i 2 .   .           .    . .              8  .  .4     1
i 2 .   .           .    . .              9  .  .2     1
i 2 .   .           .    . .             12  .  0      1

e

</CsScore>
</CsoundSynthesizer>
