<CsoundSynthesizer>

;; An Ocean of Air (Imaginary Harmony 2)
;; Dave Seidel, May 2018

<CsOptions>
-d -m1 --sample-accurate
</CsOptions>

<CsInstruments>

sr = 48000
ksmps = 1
nchnls = 2
0dbfs = 1.0

; sine table
giSin = ftgen(1, 0, 2^18, 10, 1)

; Meru C
; 0    1      2    3      4        5    6      7      8    9      10   11     12
; 1.0, 65/64, 9/8, 37/32, 151/128, 5/4, 21/16, 43/32, 3/2, 49/32, 7/4, 57/32, 2.0
; 1.0, -----, ---, 37/32, -------, 5/4, -----, -----, 3/2, -----, 7/4, -----, 2.0
; 1.0, -----, 9/8, -----, 151/128, ---, -----, 43/32, ---, 49/32, ---, -----, 2.0

; 1 4 7 9 11 (0 - 4)
; 0 2 3 5 6 8 10 12 (5 - 12)
gitun[] fillarray 65/64, 151/128, 43/32, 49/32, 57/32, \
                  1.0, 9/8, 37/32, 5/4, 21/16, 3/2, 7/4, 2.0


; array of transposition values
gktrans[] fillarray 1, 1, 1

; array of frequencies
#define BASE_FREQ  #240#
gkfreq[] fillarray $BASE_FREQ., $BASE_FREQ., $BASE_FREQ.

; array of envelopes
gkenv[] init 3

; global audio output busses
ga_play_out_left init 0
ga_play_out_right init 0
ga_chords_out_left init 0
ga_chords_out_right init 0

gi_glide init 50

;; opcodes

#define LOW_FREQ    #30#
#define HIGH_FREQ   #1800#

; transpose a frequency value by octave if it falls outside the defined range
opcode fix_range, k, k
  ksig xin

  kout = abs(ksig)
  if (kout != 0) then
    while kout < $LOW_FREQ do
      kout *= 2
    od
    while kout > $HIGH_FREQ do
      kout *= 0.5
    od
  endif

  xout kout
endop

opcode implication_engine, a, iiii
  itab,ifirst,isecond,iidx xin

  ksmooth = linseg(0, 0.001, 1)
  kpch1 = portk(gkfreq[ifirst], gi_glide * ksmooth)
  kpch2 = portk(gkfreq[isecond], gi_glide * ksmooth)
  kenv = gkenv[iidx] ;* 0.8

  ; difference tone
  kdiff = fix_range(kpch2 - kpch1)
  ; 2nd order difference tone
  kdiff2 = fix_range((2 * kpch2) - kpch1)
  ; 3rd order difference tone
  kdiff3 = fix_range((3 * kpch2) - (2 * kpch1))

  ; summation tone
  ksum   = fix_range(kpch1 + kpch2)
  ; 2nd order summation tone
  ksum2  = fix_range((2 * kpch1) + kpch2)

  ; arithmetic mean
  kari = fix_range((kpch1+kpch2) / 2)

  ; product
  kprod = fix_range(kpch1 * kpch2)

  adiff   = poscil3(kenv,  kdiff,  itab)
  adiff2  = poscil3(kenv,  kdiff2, itab)
  adiff3  = poscil3(kenv,  kdiff3, itab)
  asum    = poscil3(kenv,  ksum,   itab)
  asum2   = poscil3(kenv,  ksum2,  itab)
  aari    = poscil3(kenv,  kari,   itab)
  ; aprod   = poscil3(kenv,  kprod,  itab)

  aout = adiff+adiff2+adiff3+asum+asum2+aari ;+aprod
  xout aout
endop

;; instruments

instr Output
  aL1 = ga_play_out_left +
        ga_chords_out_left

  aR1 = ga_play_out_right +
        ga_chords_out_right

  ; low shelf to boost bass
  aL2 = pareq(aL1, 1, 500, 15, 0.1)
  aR2 = pareq(aR1, 1, 500, 15, 0.1)

  aL, aR reverbsc aL2, aR2, 0.8, 8000, sr, 0.1, 0
  outs((aL*0.75) + aL2,
       (aR*0.75) + aR2)
  ; outs(aL2, aR2)

  ga_play_out_left = 0
  ga_play_out_right = 0
  ga_chords_out_left = 0
  ga_chords_out_right = 0
endin

; generates a series of integers within a specified range, setting the transposition
; value of the specified index in the gktrans array
instr Transposer
  iidx = p4           ; transposition index
  iinit = p5
  irate = p6          ; rate of change (cps)
  ilo = p7            ; lower limit of transposition range (0-based index into tuning table)
  ihi = p8            ; upper limit of transposition range (0-based index into tuning table)

  seed(0)

  krate = iinit
  ktime timeinsts
  kflag = 0
  if (kflag == 0 && ktime >= iinit) then
    krate = irate
    kflag = 1
  endif

  ktrans = int(trandom(metro(krate), ilo, ihi))
  gktrans[iidx] = gitun[ktrans]
  ; printks("Transposer %d (%f) : %f -> %f\n", 1, iidx, p5, ktrans, gktrans[iidx])
endin

instr Player
  idur = p3           ; duration
  iamp = ampdb(p4)    ; amplitude
  ifn  = p5           ; function table number
  ifreq = p6          ; base frequency
  ipan = p7           ; pan (0 to 1)
  irise = p8          ; env rise
  ifall = p9          ; env fall
  iidx = p10          ; transposition index
  iadj = p11          ; pitch adjustment factor

  kenv = linen(iamp, irise, idur, ifall)
  gkenv[iidx] = kenv

  kfreq = ifreq * gktrans[iidx]
  gkfreq[iidx] = kfreq
  ksmooth = linseg(0, 0.001, 1)
  aout = poscil3(kenv, portk(kfreq, gi_glide * ksmooth) * iadj, ifn)
  aLeft, aRight pan2 aout, ipan

  ga_play_out_left  = ga_play_out_left + aLeft
  ga_play_out_right = ga_play_out_right + aRight
endin

instr ChordMachine
  itab = p4           ; function table number
  ipan = p5           ; pan (0 to 1)
  ifirst = p6         ; first pitch
  isecond = p7        ; second pitch
  iidx = p8           ; index

  aout = implication_engine(itab, ifirst, isecond, iidx)
  aLeft, aRight pan2 aout, ipan

  ga_chords_out_left  = ga_chords_out_left + aLeft
  ga_chords_out_right = ga_chords_out_right + aRight
endin

</CsInstruments>
<CsScore>

; #define DUR       #[3600*4]#
#define DUR       #[60*42]#
#define START     #0#
#define BASE_FREQ #240#

i "Output" 0 [$DUR.+3]

;                              idx init rate   low  hi
i "Transposer"   $START. $DUR. 1   1    0.005   0   4.9
i "Transposer"   $START. $DUR. 2   1    0.007   5   12.9

;                                   tbl             pan  rise fall idx  adj
i "Player"       $START. $DUR. -28  1   $BASE_FREQ. 0.5  8    10    0    1
i "Player"       $START. $DUR. -28  1   $BASE_FREQ. 0.6  8    10    1    1
i "Player"       $START. $DUR. -28  1   $BASE_FREQ. 0.4  8    10    2    1

;                              tbl pan  1st 2nd idx
i "ChordMachine" $START. $DUR. 1   0.5  0   1   0
i "ChordMachine" $START. $DUR. 1   0.6  0   2   1
i "ChordMachine" $START. $DUR. 1   0.4  1   2   2

e

</CsScore>
</CsoundSynthesizer>
