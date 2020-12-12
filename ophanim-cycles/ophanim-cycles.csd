;===============================================================================
; The Ophanim Cycles
; Dave Seidel
; December 2020
;
; This is only the Csound part of the piece. It produces all of the sound, but
; the output is subsequentlyt heavily processed by combination of modular synth
; and pedals.
;===============================================================================


<CsoundSynthesizer>

<CsOptions>
; Expert Sleepers ES-8
-d --sched --sample-accurate -+rtaudio=alsa --format=long -odac:hw:1,0 -b 256 -B 2048
</CsOptions>

<CsInstruments>

sr = 96000
ksmps = 32
nchnls =  16
; nchnls_i = 8
0dbfs = 1.0

#include "cvtools.orc"

; presets for Tarmo Johannes' scanned synthesis configurations
#include "inc/scanu_presets.orc"
; table ID
#define SCANX_ID              #4#
; default preset
#define SCANX_DEFAULT_PRESET  #26#

; global audio output busses
ga_main_out_1 init 0
; ga_main_out_2 init 0

#define STARTING_NOTE #60#
#define NOTES_PER_8VE #6#


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


; approx. length in seconds of each note
#ifdef PERIOD
gi_period = $PERIOD
#else
gi_period = 17
#endif

; number of notes before switching tuning table
#ifdef ROLLOVER
gi_rollover = $ROLLOVER
#else
gi_rollover = 23
#endif

; index of first tuning table in run
#ifdef TAB_START
gk_tab init $TAB_START
#else
gk_tab init 0
#endif

; index of last tuning table in run
#ifdef TAB_COUNT
gi_tab_count = $TAB_COUNT
#else
gi_tab_count = lenarray(gi_tuning_tbl)
#endif

gk_cnt init 0               ; master "clock"
gk_done init 0              ; signals completion

gk_coverage[] init 6
gk_blanks[] init 6

instr Init
  prints("\n=====\n")
  prints("Starting table: %d\nNumber of tables: %d\nPeriod: %d\nRollover: %d\n", i(gk_tab), gi_tab_count, gi_period, gi_rollover)
  prints("=====\n\n")

  gi_tab_count += i(gk_tab)
  event_i("i", "scanx_init", 0, 1, $SCANX_DEFAULT_PRESET, $SCANX_ID)
  turnoff()
endin

opcode lfsr_note, k,kiii
  ktrig, i1, i2, i3 xin

  if (ktrig > 0) then
    ; constrain notes to some range (6 tones/octave)
    knote = int(scale(lfsr(i1, i2, i3), $STARTING_NOTE + ($NOTES_PER_8VE * 2.5), $STARTING_NOTE, 32768, 0))
  else
    knote = 0
  endif

  xout knote
endop

instr Player
    idur = p3
    iamp = p4

    if gk_done == 1 then
      turnoff2(nstrnum("Output"), 0, 1)
      event("i", "Ender", 0, 1)
    endif

    kdur = gi_period + jitter(1.1, gi_period / 2, gi_period - 1.5)
    ; printks("kdur = %f\n", 7, kdur)

    ktrig = metro(kdur)
    ; printk(0, ktrig, 0, 1)

    knote = lfsr_note(ktrig, 15, 128, 170)

    ; knote = round(urandom:k($STARTING_NOTE, $STARTING_NOTE + ($NOTES_PER_8VE * 2.5)))

    schedkwhen(ktrig, 0,    1, "Tone",    0, -1, iamp, knote, kdur)
    schedkwhen(ktrig, kdur, 1, "Stopper", 0,  1, nstrnum("Tone"))
endin

instr Stopper
    turnoff2(p4, 8, 1)
    turnoff()
endin

instr Ender
    prints("Goodbye\n")
    exitnow(0)
endin

opcode reduce, k, k
  kn xin
  xout (kn - $STARTING_NOTE) % $NOTES_PER_8VE
endop

; CV output channels on the ES-8
#define ENV_CV_CHN  #5#
#define RAMP_CV_CHN #6#

instr Tone
    iamp = ampdb(p4)
    knote = p5
    idur = p6

    ktab = gi_tuning_tbl[gk_tab]
    kcps = tablekt(knote, ktab) * 0.25

    kenv = linenr(iamp, 2, 2, 0.1)

    ; "clock" logic
    ; clock advances +1 per note instance
    kinit init 0
    if (kinit == 0) then
        kinit = 1

        ; informational -- see how well each cycle covers the scale
        knote2 = reduce(knote)
        gk_coverage[knote2] = 1
        printks("clock=%2d, dur=%f, tuning=%d, n=%d (%d), f=%f\n", 0,
                 gk_cnt, idur, ktab, knote, knote2, kcps)

        ; send envelope
        cvt_ar_env_eq($ENV_CV_CHN, idur-1, 0, 0.5, 0)

        ; send ramp to control efx
        if (gk_cnt == 0) then
          cvt_ramp(k($RAMP_CV_CHN), k((idur) * (gi_rollover - 2)), k(0.5), k(0))
        endif

        ; switch to next tuning table when we hit the gi_rollover value
        gk_cnt += 1
        if (gk_cnt == gi_rollover) then
            printarray(gk_coverage, 1, "%d", "\nscale coverage")
            gk_coverage = setrow(gk_blanks, 0)

            ; reset clock
            gk_cnt = 0

            ; advance to next tuning table
            gk_tab += 1
            if (gk_tab >= gi_tab_count) then
                ; at the end, loop back to first table 
                gk_tab = 0
                gk_done = 1
            endif
            printks("table switch -> %d\n\n", 0, gk_tab)
        endif
    endif


    ; primary voice
    a1 = scanx(kenv, kcps, $SCANX_ID)

    ; chorus-like detuning
    ; twin prime ratios
    ; 349/347 = 9.9496 cents
    ; 421/419 = 8.244 cents
    klfo = lfo(421/419, 0.005, 0)
    a2 = scanx(kenv, kcps + klfo, $SCANX_ID+1)

    aout = dcblock2(a1) + dcblock2(a2 * 0.5)

    ga_main_out_1 = aout
    ; ga_main_out_2 = aout
endin

instr Output
  a1 = ga_main_out_1
  ; a2 = ga_main_out_2

  outch(1, a1)

  ga_main_out_1 = 0
  ; ga_main_out_2 = 0
endin

</CsInstruments>

<CsScore>
#define PLAY_FOR      #0#
#define A_SHORT_TIME  #1#
#define A_LONG_TIME   #[3600*24]#

; Tarmo's tables for scanned synthesis
#include "inc/scanu_tables.sco"

i "Init"    $PLAY_FOR $A_SHORT_TIME
i "Output"  $PLAY_FOR $A_LONG_TIME
i "Player"  $PLAY_FOR $A_LONG_TIME -2

e
</CsScore>

</CsoundSynthesizer>
