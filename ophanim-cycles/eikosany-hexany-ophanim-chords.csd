<CsoundSynthesizer>

<CsOptions>
-d --sched --sample-accurate -b 256 -B 2048 -+rtaudio=alsa -odac:hw:2,0
; -+rtmidi=portmidi -Q1
</CsOptions>

<CsInstruments>

sr = 48000
ksmps = 1
nchnls = 2
0dbfs = 1.0

; presets for Tarmo Johannes' scanned synthesis configurations
#include "inc/scanu_presets.orc"
; table ID
#define SCANX_ID              #4#
; default preset
#define SCANX_DEFAULT_PRESET  #27#

#define TBLSIZ #2^18#

; sine wave
gi_sine = ftgen(999, 0, $TBLSIZ, 10, 1)

; tanh function
gi_tanh = ftgen(2, 0, 16385, "tanh", -10, 10, 0)

; global audio output busses
ga_main_out_1 init 0
ga_main_out_2 init 0

#define STARTING_NOTE #60#
#define NOTES_PER_8VE #6#

#define PERIOD      #11#    ; approx. length in seconds of each note
#define ROLLOVER    #18#    ; number of notes before switching tuning table

; all the hexanies in a 1-3-5-7-11-13 eikosany
; ordered such that there is at least one common
; tone from each one to the next in sequence
; (sorted by pitch, lowest first)

; [3, 5, 11, 13]*1
gi_tab_0 = ftgen(0, 0, 128, -51,
                 6, 2, 297.989, $STARTING_NOTE,
                 1/1, 13/12, 11/10, 143/120, 13/10, 11/6)

; [3, 5, 7, 13]*1
gi_tab_1 = ftgen(0, 0, 128, -51,
                 6, 2, 297.989, $STARTING_NOTE,
                 1/1, 13/12, 7/6, 13/10, 7/5, 91/60)

; [1, 3, 7, 13]*5
gi_tab_2 = ftgen(0, 0, 128, -51,
                 6, 2, 297.989, $STARTING_NOTE,
                 1/1, 13/12, 7/6, 13/8, 7/4, 91/48)

; [1, 3, 11, 13]*5
gi_tab_3 = ftgen(0, 0, 128, -51,
                 6, 2, 297.989, $STARTING_NOTE,
                 1/1, 13/12, 11/8, 143/96, 13/8, 11/6)

; [3, 5, 7, 11]*1
gi_tab_4 = ftgen(0, 0, 128, -51,
                 6, 2, 297.989, $STARTING_NOTE,
                 1/1, 11/10, 7/6, 77/60, 7/5, 11/6)

; [1, 5, 11, 13]*3
gi_tab_5 = ftgen(0, 0, 128, -51,
                 6, 2, 297.989, $STARTING_NOTE,
                 1/1, 11/10, 13/10, 11/8, 13/8, 143/80)

; [1, 5, 7, 11]*3
gi_tab_6 = ftgen(0, 0, 128, -51,
                 6, 2, 297.989, $STARTING_NOTE,
                 1/1, 11/10, 11/8, 7/5, 7/4, 77/40)

; [1, 5, 7, 13]*3
gi_tab_7 = ftgen(0, 0, 128, -51,
                 6, 2, 297.989, $STARTING_NOTE,
                 1/1, 91/80, 13/10, 7/5, 13/8, 7/4)

; [1, 3, 7, 11]*5
gi_tab_8 = ftgen(0, 0, 128, -51,
                 6, 2, 297.989, $STARTING_NOTE,
                 1/1, 7/6, 11/8, 77/48, 7/4, 11/6)

; [1, 5, 7, 11]*13
gi_tab_9 = ftgen(0, 0, 128, -51,
                 6, 2, 297.989, $STARTING_NOTE,
                 1001/960, 13/12, 143/120, 143/96, 91/60, 91/48)

; [1, 3, 7, 13]*11
gi_tab_10 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  1001/960, 11/10, 143/120, 77/60, 143/80, 77/40)

; [1, 3, 7, 11]*13
gi_tab_11 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  1001/960, 91/80, 143/120, 13/10, 91/60, 143/80)

; [1, 3, 11, 13]*7
gi_tab_12 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  1001/960, 91/80, 77/60, 7/5, 91/60, 77/40)

; [3, 5, 7, 11]*13
gi_tab_13 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  1001/960, 91/80, 143/96, 13/8, 143/80, 91/48)

; [3, 5, 11, 13]*7
gi_tab_14 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  1001/960, 91/80, 77/48, 7/4, 91/48, 77/40)

; [1, 5, 11, 13]*7
gi_tab_15 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  1001/960, 7/6, 77/60, 91/60, 77/48, 91/48)

; [1, 5, 7, 13]*11
gi_tab_16 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  1001/960, 143/120, 77/60, 143/96, 77/48, 11/6)

; [3, 5, 7, 13]*11
gi_tab_17 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  1001/960, 11/8, 143/96, 77/48, 143/80, 77/40)

; [1, 3, 5, 7]*13
gi_tab_18 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  13/12, 91/80, 13/10, 91/60, 13/8, 91/48)

; [5, 7, 11, 13]*1
gi_tab_19 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  13/12, 7/6, 143/120, 77/60, 91/60, 11/6)

; [1, 7, 11, 13]*5
gi_tab_20 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  13/12, 7/6, 143/96, 77/48, 11/6, 91/48)

; [1, 3, 5, 11]*13
gi_tab_21 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  13/12, 143/120, 13/10, 143/96, 13/8, 143/80)

; [1, 7, 11, 13]*3
gi_tab_22 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  11/10, 91/80, 13/10, 7/5, 143/80, 77/40)

; [3, 7, 11, 13]*1
gi_tab_23 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  11/10, 143/120, 77/60, 13/10, 7/5, 91/60)

; [1, 3, 5, 13]*11
gi_tab_24 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  11/10, 143/120, 11/8, 143/96, 143/80, 11/6)

; [1, 3, 5, 7]*11
gi_tab_25 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  11/10, 77/60, 11/8, 77/48, 11/6, 77/40)

; [1, 3, 5, 13]*7
gi_tab_26 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  91/80, 7/6, 7/5, 91/60, 7/4, 91/48)

; [5, 7, 11, 13]*3
gi_tab_27 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  91/80, 11/8, 13/8, 7/4, 143/80, 77/40)

; [1, 3, 5, 11]*7
gi_tab_28 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  7/6, 77/60, 7/5, 77/48, 7/4, 77/40)

; [3, 7, 11, 13]*5
gi_tab_29 = ftgen(0, 0, 128, -51,
                  6, 2, 297.989, $STARTING_NOTE,
                  11/8, 143/96, 77/48, 13/8, 7/4, 91/48)


gi_tuning_tbl[] = fillarray(gi_tab_0,
                            gi_tab_1,
                            gi_tab_2,
                            gi_tab_3,
                            gi_tab_4,
                            gi_tab_5,
                            gi_tab_6,
                            gi_tab_7,
                            gi_tab_8,
                            gi_tab_9,
                            gi_tab_10,
                            gi_tab_11,
                            gi_tab_12,
                            gi_tab_13,
                            gi_tab_14,
                            gi_tab_15,
                            gi_tab_16,
                            gi_tab_17,
                            gi_tab_18,
                            gi_tab_19,
                            gi_tab_20,
                            gi_tab_21,
                            gi_tab_22,
                            gi_tab_23,
                            gi_tab_24,
                            gi_tab_25,
                            gi_tab_28,
                            gi_tab_26,
                            gi_tab_27,
                            gi_tab_29)


gk_cnt init 0               ; master "clock"
gk_tab init 0               ; current tuning table
gk_done init 0              ; signals completion

gk_coverage[] init 6
gk_blanks[] init 6

; #define N(i1'i2) #table($i1 + $STARTING_NOTE, gi_tuning_tbl[$i2])#

instr Init
  ; event_i("i", "scanx_init", 0, 1, $SCANX_DEFAULT_PRESET, $SCANX_ID)

  ; itbl = 0
  ; loop:
  ; prints("%f\t%f\t%f\t%f\t%f\t%f\n", $N(0'itbl), $N(1'itbl), $N(2'itbl), $N(3'itbl), $N(4'itbl), $N(5'itbl))
  ; loop_lt itbl, 1, lenarray(gi_tuning_tbl), loop

  turnoff()
endin

instr Chord
    idur = p3
    iamp = ampdb(p4) ; / 6
    itab = gi_tuning_tbl[p5]

    imul = 1

    icps1 = tab_i(60, itab) * imul
    icps2 = tab_i(61, itab) * imul * 0.5
    icps3 = tab_i(62, itab) * imul
    icps4 = tab_i(63, itab) * imul * 0.5
    icps5 = tab_i(64, itab) * imul
    icps6 = tab_i(65, itab) * imul * 0.5

    prints("table %d\t%f\t%f\t%f\t%f\t%f\t%f\n",
           itab, icps1, icps2, icps3, icps4, icps5, icps6)

    kenv = linen(iamp, 3, idur, 3)

    a1 = poscil3(kenv, icps1, 999)
    a2 = poscil3(kenv, icps2, 999)
    a3 = poscil3(kenv, icps3, 999)
    a4 = poscil3(kenv, icps4, 999)
    a5 = poscil3(kenv, icps5, 999)
    a6 = poscil3(kenv, icps6, 999)

    kdst = linen(0.4, 4, idur, 4)
    ad1 = distort(a1, kdst, gi_tanh)
    ad2 = distort(a2, kdst, gi_tanh)
    ad3 = distort(a3, kdst, gi_tanh)
    ad4 = distort(a4, kdst, gi_tanh)
    ad5 = distort(a5, kdst, gi_tanh)
    ad6 = distort(a6, kdst, gi_tanh)

    aout1 = (ad1+ad2+ad3) * 0.2
    aout2 = (ad4+ad5+ad6) * 0.2

    kenv2 = icps4 * 8 * kenv
    aout1 = butterlp(aout1, kenv2)
    aout1 = butterlp(aout1, kenv2)
    aout2 = butterlp(aout2, kenv2)
    aout2 = butterlp(aout2, kenv2)

    ; a1 = scanx(kenv, k(icps1), $SCANX_ID)
    ; a2 = scanx(kenv, k(icps2), $SCANX_ID + 1)
    ; a3 = scanx(kenv, k(icps3), $SCANX_ID + 2)
    ; a4 = scanx(kenv, k(icps4), $SCANX_ID + 3)
    ; a5 = scanx(kenv, k(icps5), $SCANX_ID + 4)
    ; a6 = scanx(kenv, k(icps6), $SCANX_ID + 5)

    ; aout = dcblock2(a1+a2+a3+a4+a5+a6)
    ; kenv2 = icps4 * 8 * kenv
    ; aout = butterlp(aout, kenv2)
    ; aout = butterlp(aout, kenv2)

    ga_main_out_1 = aout1
    ga_main_out_2 = aout2
endin

instr Output
  a1 = ga_main_out_1
  a2 = ga_main_out_2

  aL, aR reverbsc a1, a2, 0.7, sr/4, sr, 0.1, 0
  out(aL, aR)

  ; out(a1, a2)

  ga_main_out_1 = 0
  ga_main_out_2 = 0
endin

</CsInstruments>

<CsScore>
#define PLAY_FOR      #0#
#define A_SHORT_TIME  #1#
#define A_LONG_TIME   #[3600*24]#

; ; Tarmo's tables for scanned synthesis
; #include "inc/scanu_tables.sco"

#define DUR #10#

i "Init"    0 1
i "Output"  0 [($DUR * 30) + 3]

i "Chord"   1 $DUR -6 0
i "Chord"   + .    .  1
i "Chord"   + .    .  2
i "Chord"   + .    .  3
i "Chord"   + .    .  4
i "Chord"   + .    .  5
i "Chord"   + .    .  6
i "Chord"   + .    .  7
i "Chord"   + .    .  8
i "Chord"   + .    .  9
i "Chord"   + .    .  10
i "Chord"   + .    .  11
i "Chord"   + .    .  12
i "Chord"   + .    .  13
i "Chord"   + .    .  14
i "Chord"   + .    .  15
i "Chord"   + .    .  16
i "Chord"   + .    .  17
i "Chord"   + .    .  18
i "Chord"   + .    .  19
i "Chord"   + .    .  20
i "Chord"   + .    .  21
i "Chord"   + .    .  22
i "Chord"   + .    .  23
i "Chord"   + .    .  24
i "Chord"   + .    .  25
i "Chord"   + .    .  26
i "Chord"   + .    .  27
i "Chord"   + .    .  28
i "Chord"   + .    .  29

e
</CsScore>

</CsoundSynthesizer>
