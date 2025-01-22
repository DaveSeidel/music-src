<CsoundSynthesizer>

<CsOptions>
-d -m128 -Ma -b64 -B256
; -d -m128 -odac -Ma
</CsOptions>

<CsInstruments>
sr=48000
ksmps=10
nchnls=8
0dbfs=1

; sine table
gi_sin = ftgen(0, 0, 2^18, 10, 1)

; LMY WTP tuniung table
gi_wtp = ftgen(201, 0, 128, -51,
               12, 2, 261.626, 60,
               1, 567/512, 9/8, 147/128, 21/16, 1323/1024, 189/128, 3/2, 49/32, 7/4, 441/256, 63/32, 2)

gk_tuning init gi_wtp

; we need to access the ratios directly also
gi_wtp_ratios[] = fillarray(1, 567/512, 9/8, 147/128, 21/16, 1323/1024, 189/128, 3/2, 49/32, 7/4, 441/256, 63/32)

#define BASEBFLAT #300.46#

#define REDUCE_MIN  #60#
#define REDUCE_MAX  #2000#

; note that is played
gk_ratio_level        init 0.5
initc14 1, 11, 43, 0.5

; derived chords
gk_inner_level        init 0
initc14 1, 12, 44, 0
gk_outer_level        init 0
initc14 1, 13, 45, 0
gk_inner_combos_level init 0
initc14 1, 14, 46, 0
gk_outer_combos_level init 0
initc14 1, 15, 47, 0

; drone
gk_drone_level        init 0
initc14 1, 20, 52, 0

; center
gk_center_level       init 0.5
initc14 1, 21, 53, 0.5

; distortion
gk_dist_mix           init 0.5
initc14 1, 22, 54, 0.5

gk_pan  init 0.5

; outputs
ga_drone_L  init 0
ga_drone_R  init 0
ga_tones_L  init 0
ga_tones_R  init 0
ga_main_L   init 0
ga_main_R   init 0

; #define Index(N)  #(($N - 3) + 12) % 12#
#define ISCALE(N'B'A'MAX'MIN) #(($B - $A) * ($N - $MIN)) / ($MAX - $MIN)#

opcode Distort,a,ai
    asig, iphs xin

    iamp = 1.1
    irate = 0.2
    klfo = oscili(iamp, irate, -1, iphs)
    asig_dist = distort1(asig, klfo + (iamp*2), 0.07, 0.0, 0.0, 1)

    xout (asig * gk_dist_mix) + (asig_dist * (1 - gk_dist_mix))
endop

opcode reduce,i,iiii
  isig, imin, imax, imult xin

  isig *= imult
  imin *= imult
  imax *= imult

  ; prints("<<<<<\nreduce: isig=%f imin=%f imax=%f\n", isig, imin, imax)

  ; if either setting is 0, return frequence as-is
  if (imin == 0 || imin == 0) then
    iout = isig
  else
    iout = abs(isig)
    ; prints("reduce: iout=%f\n", iout)
    if (iout != 0) then
      if (iout < imin) then
        ; prints("reduce: iout < imin\n")
        while iout < imin do
          iout *= 2
          ; prints("reduce: iout=%f\n", iout)
        od
      elseif (iout > imax) then
        ; prints("reduce: iout > imax\n")
        while iout > imax do
          iout *= 0.5
          ; prints("reduce: iout=%f\n", iout)
        od
      endif
    endif
  endif

  ; prints("reduce: final iout=%f\n>>>>>\n", iout)
  xout iout
endop

opcode CombinationEngine,a,iiiiiii
  itab, iamp, ifreq1, ifreq2, imin, imax, imult xin

  ; prints("CombinationEngine freq1=%f freq2=%f\n", ifreq1, ifreq2)

  idiff  = ifreq2 - ifreq1              ; difference tone
  idiff2 = (2 * ifreq2) - ifreq1        ; 2nd order difference tone
  idiff3 = (3 * ifreq2) - (2 * ifreq1)  ; 3rd order difference tone
  isum   = ifreq1 + ifreq2              ; summation tone
  isum2  = (2 * ifreq1) + ifreq2        ; 2nd order summation tone

  ; prints("combos          : diff=%f diff2=%f diff3=%f sum=%f sum2=%f\n",
  ;        idiff, idiff2, idiff3, isum, isum2)

  idiff  = reduce(idiff,  imin, imax, imult)
  idiff2 = reduce(idiff2, imin, imax, imult)
  idiff3 = reduce(idiff3, imin, imax, imult)
  isum   = reduce(isum,   imin, imax, imult)
  isum2  = reduce(isum2,  imin, imax, imult)

  ; prints("combos (reduced): diff=%f diff2=%f diff3=%f sum=%f sum2=%f\n",
  ;       idiff, idiff2, idiff3, isum, isum2)

  adiff  = poscil3(iamp, idiff,  itab)
  adiff2 = poscil3(iamp, idiff2, itab)
  adiff3 = poscil3(iamp, idiff3, itab)
  asum   = poscil3(iamp, isum,   itab)
  asum2  = poscil3(iamp, isum2,  itab)

  aout = adiff+adiff2+adiff3+asum+asum2
  xout aout
endop

opcode CenterInterval,iii,ii
    icenter, iratio xin

    iint = iratio - 1
    ihalf = iint / 2
    ival = icenter * ihalf
    ilo = icenter - ival
    ihi = icenter + ival
    ; prints("center=%f ratio=%f int=%f half=%f low=%f high=%f\n", icenter, iratio, iint, ihalf, ilo, ihi)

    xout ilo, ihi, ihalf
endop

; main instrument (MIDI)
massign 0, 1
maxalloc 1, 2
instr 1
    idur = p3

    iamp = ampdb(-9)

    ; tuning table
    itab = gi_wtp

    ; MIDI controls
    gk_ratio_level        midic14 11, 43, 0, 1
    gk_inner_level        midic14 12, 44, 0, 1
    gk_outer_level        midic14 13, 45, 0, 1
    gk_inner_combos_level midic14 14, 46, 0, 1
    gk_outer_combos_level midic14 15, 47, 0, 1

    ; printks("center_level=%f\n", 1, gk_center_level)

    ; get base pitch (1/1 current octave)
    ibase = tab_i(51, itab)

    ; derive pitch for incoming note
    inote notnum
    ipitch = tab_i(inote, itab)

    ; transposed index of note (0-11)
    iidx = (inote - 3) % 12

    ; use MIDI note to determine the center pitch (i.e., 1/1 in the octave of the incoming note)
    ipch pchmidi
    ioct = int(ipch)
    ; prints("note=%d freq=%f pch=%f oct=%f iidx=%f ibase=%f\n",
    ;        inote, ipitch, ipch, ioct, iidx, ibase)
    if (ioct == 6) then
        ibase = ibase / 2
    elseif (ioct == 7) then
        ibase = ibase
    elseif (ioct == 8) then
        ibase = ibase * 2
    elseif (ioct == 9) then
        ibase = ibase * 4
    elseif (ioct == 10) then
        ibase = ibase * 8
    endif
    prints("note=%f pch=%f oct=%f idx=%f base=%f\n", inote, ipch, ioct, iidx, ibase)

    ; get ratio of incoming note
    iratio = gi_wtp_ratios[iidx]
    ilo_inner, ihi_inner, ival CenterInterval ibase, iratio
    
    ihi_outer = ibase * iratio
    idiff = ihi_outer - ibase
    ilo_outer = ibase - idiff

    ilo_inner = reduce(ilo_inner, $REDUCE_MIN, $REDUCE_MAX, 1)
    ilo_outer = reduce(ilo_outer, $REDUCE_MIN, $REDUCE_MAX, 1)

    ; prints("iamp=%f (%f) idx=%f ratio=%f center=%f diff=%f inner_lo=%f inner_hi=%f outer_lo=%f outer_hi=%f\n",
    ;        iamp, dbamp(iamp), iidx, iratio, ibase, idiff, ilo_inner, ihi_inner, ilo_outer, ihi_outer)

    iinner_pan_l = $ISCALE(0.5-ival ' 0.5 ' 0 ' 0.5 ' -0.5)
    iinner_pan_r = $ISCALE(0.5+ival ' 1 ' 0.5 ' 1.5 '  0.5) + 0.5
    ; prints("INNER: val=%f inner_pan_l=%f inner_pan_r=%f -> (%f, %f)\n", ival, iinner_pan_l, iinner_pan_r, ilo_inner, ihi_inner)

    iratio = frac(iratio)
    itmpl = 0.5 - iratio
    itmpr = 0.5 + iratio
    iouter_pan_l = $ISCALE(itmpl ' 0.5 ' 0 ' 0.5 ' -0.5)
    iouter_pan_r = $ISCALE(itmpr ' 1 ' 0.5 ' 1.5 ' 0.5) + 0.5
    ; prints("OUTER: val=%f outer_pan_l=%f outer_pan_r=%f -> (%f, %f)\n", iratio, iouter_pan_l, iouter_pan_r, ilo_outer, ihi_outer)

    aenv_center = linenr(iamp, 2, 2, 0.01)
    aenv_inner  = linenr(iamp, 2, 2, 0.01)
    aenv_outer  = linenr(iamp, 2, 2, 0.01)
    aenv_combo  = linenr(iamp, 2, 2, 0.01)

    acent = poscil3(aenv_center * gk_center_level, ibase, gi_sin)
    aratio = poscil3(aenv_center * gk_ratio_level, ipitch, gi_sin)
    acent = Distort(acent, 0.6)
    aratio = Distort(aratio, 0.4)
    acentL, acentR pan2 acent+aratio, gk_pan

    ahi_inner = poscil3(aenv_inner * gk_inner_level, ihi_inner, gi_sin)
    ahi_inner = Distort(ahi_inner, 0.5)
    ahi_innerL, ahi_innerR pan2 ahi_inner, iinner_pan_r

    alo_inner = poscil3(aenv_inner * gk_inner_level, ilo_inner, gi_sin)
    alo_inner = Distort(alo_inner, 0.25)
    alo_innerL, alo_innerR pan2 alo_inner, iinner_pan_l

    ahi_outer = poscil3(aenv_outer * gk_outer_level, ihi_outer, gi_sin)
    ahi_outer = Distort(ahi_outer, 0.75)
    ahi_outerL, ahi_outerR pan2 ahi_outer, iouter_pan_r

    alo_outer = poscil3(aenv_outer * gk_outer_level, ilo_outer, gi_sin)
    alo_outer = Distort(alo_outer, 0.75)
    alo_outerL, alo_outerR pan2 alo_outer, iouter_pan_l

    acombos_inner = CombinationEngine(gi_sin, iamp, ilo_inner, ihi_inner, $REDUCE_MIN, $REDUCE_MAX, 1)
    acombos_innerL, acombos_innerR pan2 acombos_inner, gk_pan 

    acombos_outer = CombinationEngine(gi_sin, iamp, ilo_outer, ihi_outer, $REDUCE_MIN, $REDUCE_MAX, 1)
    acombos_outerL, acombos_outerR pan2 acombos_outer, gk_pan 

    aLeft = 0
    aRight = 0

    ; prints("--> center + ratio\n")
    aLeft  += acentL
    aRight += acentR

    ; prints("--> inner dyads\n")
    aRight += ahi_innerL+alo_innerL
    aLeft += ahi_innerR+alo_innerR

    ; prints("--> outer dyads\n")
    aLeft  += ahi_outerL+alo_outerL
    aRight += ahi_outerL+alo_outerR

    ; prints("--> inner combos\n")
    aLeft  += acombos_innerL * (aenv_combo * gk_inner_combos_level)
    aRight += acombos_innerR * (aenv_combo * gk_inner_combos_level)

    ; prints("--> outer combos \n")
    aLeft  += acombos_outerL * (aenv_combo * gk_outer_combos_level)
    aRight += acombos_outerR * (aenv_combo * gk_outer_combos_level)
    
    ; printks("aleft=%f aright=%f\n", 5, dbamp(rms(aLeft)), dbamp(rms(aRight)))
    ga_tones_L +=  aLeft
    ga_tones_R +=  aRight
endin

instr Drone
    idur = p3
    iamp = ampdb(p4)

    icps = $BASEBFLAT / 8
    icps2 = icps * 2
    prints("drones: %f, %f\n", icps, icps2)

    aenv = linen(iamp, 3, idur, 3)

    aout1 = poscil3(aenv, icps, gi_sin)
    aout1 = Distort(aout1, 0)
    ; a1L, a1R pan2 aout1, 0.5

    ; aout2 = 0
    aout2 = poscil3(aenv, icps2, gi_sin)
    ; aout2 = Distort(aout2, 0)
    ; a2L, a2R pan2 aout2, 0.5

    ; aout = Distort(aout1, 0)
    aout = aout1 + aout2
    aL, aR pan2 aout, 0.5

    ; ga_drone_L +=  a1L + a2L
    ; ga_drone_R +=  a1R + a2R
    ga_drone_L +=  aL
    ga_drone_R +=  aR
endin

instr Listener
    ; prints("tuning=%d\n", i(gk_tuning))

    gk_drone_level  ctrl14 1, 20, 52, 0, 1
    gk_center_level ctrl14 1, 21, 53, 0, 1
    gk_dist_mix     ctrl14 1, 25, 57, 0, 1
endin

instr Mixer
    ga_drone_L *= gk_drone_level
    ga_drone_R *= gk_drone_level
    outch 1, ga_drone_L, 2, ga_drone_R

    outch 3, ga_tones_L, 4, ga_tones_R

    ga_drone_L = 0
    ga_drone_R = 0
    ga_tones_L = 0
    ga_tones_R = 0
endin

</CsInstruments>

<CsScore>

i "Mixer"	    0	36000
i "Listener"  0 36000
i "Drone"     0 36000 -8
e

</CsScore>

</CsoundSynthesizer>