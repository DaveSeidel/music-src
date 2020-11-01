<CsoundSynthesizer>

<CsOptions>
-d --sample-accurate
</CsOptions>

<CsInstruments>

sr = 96000
ksmps = 1
nchnls = 2
0dbfs = 1.0

#define TBLSIZ #2^18#

; sine wave
gi_sine = ftgen(999, 0, $TBLSIZ, 10, 1)

; tanh function
gi_tanh = ftgen(2, 0, 16385, "tanh", -157, 157, 0)

; global audio output busses
ga_main_out_1 init 0
ga_main_out_2 init 0

#define BAL(A1'V1'A2'V2) #($A1 * $V1) + ($A2 * $V2)# 

instr Tone0
    idur = p3
    iamp = ampdb(p4)
    ipan = p5
    ibase = p6

    kenv = linenr(iamp, 2, 2, 0.1)
    a1 = poscil3(kenv, ibase, 999)

    kdst = linenr(iamp * 0.07, 2, 2, 0.1)
    ad1 = dcblock2(distort(a1, kdst, gi_tanh))

    a1L, a1R pan2 (a1 * 0.5) + (ad1 * 0.03), ipan

    aoutL = a1L
    aoutR = a1R

    ga_main_out_1 = ga_main_out_1 + aoutL
    ga_main_out_2 = ga_main_out_2 + aoutR
endin

instr Tone
    idur = p3
    iamp = ampdb(p4)
    ipan = p5
    ibase = p6
    imul = p7

    ; prints("iamp=%f imul=%f\n", iamp, imul)
    if (imul == 0) then
        imul = 1
    elseif (imul < 0) then
        imul -= 1
    else
        imul += 1
    endif

    iamp *= 1 / abs(imul)
    prints("\niamp=%f imul=%f dur=%f\n", iamp, imul, idur)

    if (imul < 0) then
        imul = 1 / abs(imul)
    endif
    icps = ibase * imul
    if (icps < 48) then
        icps *= 2
    endif
    
    prints("base=%f mult=%f cps=%f amp=%f\n", ibase, imul, icps, iamp)

    kenv = linen(iamp, 2, idur, 2)
    a1 = poscil3(kenv, icps, 999)

    kdst = linen(iamp * 0.07, 4, idur, 4)
    ad1 = dcblock2(distort(a1, kdst, gi_tanh))

    a1L, a1R pan2 (a1 * 0.5) + (ad1 * 0.03), ipan

    aoutL = a1L
    aoutR = a1R

    ga_main_out_1 = ga_main_out_1 + aoutL
    ga_main_out_2 = ga_main_out_2 + aoutR
endin

instr Ender
    prints("\nGoodbye\n")
    turnoff2(nstrnum("Tone0"), 8, 1)
    turnoff2(nstrnum("Output"), 8, 1)
endin

instr Output
  xtratim(3)
  a1 = ga_main_out_1
  a2 = ga_main_out_2

  iv1 = 0.4 ; efx level
  iv2 = 0.6 ; clean level
  aL, aR reverbsc a1, a2, 0.7, sr/4, sr, 0.1, 0
  out($BAL(aL'iv1'a1'iv2), $BAL(aR'iv1'a2'iv2))

  ; out(a1, a2)

  ga_main_out_1 = 0
  ga_main_out_2 = 0
endin

</CsInstruments>

<CsScore>
#define DUR     #8#
#define LVL     #-18#
#define BASE    #240#

t 0 60

i "Output"  0 -1
i "Tone0"   0 -1 $LVL 0.5 $BASE

#include "infser.orc"

i "Ender"  ^+10 1

e
</CsScore>

</CsoundSynthesizer>
