;;--------------------------
;; Implication Organ v2.0
;; Dave Seidel, August 2018
;;--------------------------

<CsoundSynthesizer>
<CsOptions>
 -d -m0 -+rtmidi=portmidi -+raw_controller_mode=1 -Ma --realtime ;--sched -j4
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 50
nchnls = 2
0dbfs = 1


; presets for Tarmo Johannes' scanned synthesis configurations
#include "inc/scanu_presets.orc"
; table ID
#define SCANX_ID              #4#
; default preset
#define SCANX_DEFAULT_PRESET  #9#


; Steven Yi's implementation of Julian Parker's ring modulator
; #include "inc/ringmod.udo"

;;-----------------------
;; controller definitions
;;-----------------------

#include "inc/controls.orc"

#define CTL_MAIN_LEVEL        #gk_ctl_1#
#define CTL_GENERATED_LEVEL   #gk_ctl_2#

#define CTL_COMBOS_LEVEL      #gk_ctl_3#
#define CTL_COMBOS_DIFF1      #gk_ctl_4#
#define CTL_COMBOS_DIFF2      #gk_ctl_5#
#define CTL_COMBOS_DIFF3      #gk_ctl_6#
#define CTL_COMBOS_SUM1       #gk_ctl_7#
#define CTL_COMBOS_SUM2       #gk_ctl_8#
#define CTL_COMBOS_PROD       #gk_ctl_9#

#define CTL_MEANS_LEVEL       #gk_ctl_10#
#define CTL_MEANS_ARI         #gk_ctl_11#
#define CTL_MEANS_GEO         #gk_ctl_12#
#define CTL_MEANS_HAR         #gk_ctl_13#
#define CTL_MEANS_PHI         #gk_ctl_14#

#define CTL_DETUNE            #gk_ctl_15#

;;-----------------
;; waveform tables
;;-----------------
#define TBLSIZ #2^18#

; sine wave
gi_sine = ftgen(1, 0, $TBLSIZ, 10, 1)

; Fibonacci wave
gi_fib = ftgen(2, 0, $TBLSIZ, 9, 1,1,0,
                              2,0.5,0,
                              3,0.3333,0,
                              5,0.2,0,
                              8,0.125,0,
                              13,0.0769,0,
                              21,0.0476,0)
                              ;34,0.0294,0)
                              ;55,0.0182,0,
                              ;89,0.0112,0,
                              ;144,0.0069,0)

; prime wave
gi_prime = ftgen(3, 0, $TBLSIZ, 9, 1,1,0,
                                2,0.5,0,
                                3,0.3333,0,
                                5,0.2,0,
                                7,0.143,0,
                                11,0.0909,0,
                                13,0.077,0,
                                17,.0588,0,
                                19,0.0526,0,
                                23,0.0435,0,
                                27,0.037,0)

; David First's asymptotic sawtooth wave
gi_asymp = ftgen(4, 0, $TBLSIZ, 9, 1,1,0,
                                   1.732050807568877, 0.5773502691896259,  0,
                                   2.449489742783178, 0.4082482904638631,  0,
                                   3.162277660168379, 0.3162277660168379,  0,
                                   3.872983346207417, 0.2581988897471611,  0,
                                   4.58257569495584,  0.2182178902359924,  0,
                                   5.291502622129182, 0.1889822365046136,  0,
                                   6,                 0.1666666666666667,  0,
                                   6.70820393249937,  0.1490711984999859,  0,
                                   7.416198487095663, 0.1348399724926484,  0,
                                   8.124038404635961, 0.1230914909793327,  0,
                                   9.539392014169456, 0.1048284836721918,  0,
                                   10.2469507659596,  0.0975900072948533,  0,
                                   10.95445115010332, 0.0912870929175277,  0,
                                   11.6619037896906,  0.08574929257125442, 0)

;;---------------
;; tuning tables
;;---------------
#define N #0#

; 1-3-5-7 hexany (odd keys) alternating with the same series transposed up by some
; semitone-type interval (even keys) -- these sub-scales have the same fingering as 12ET
; wholetone scales
giHex = ftgen(200, 0, 128, -51,
              12, 2, 240, 60,
              1, 16/15, 7/6, 56/45, 5/4, 4/3, 35/24, 14/9, 5/3, 16/9, 7/4, 28/15, 2)
            ; 1, 21/20, 7/6, 49/40, 5/4, 21/16, 35/24, 49/32, 5/3, 7/4, 7/4, 147/80, 2
            ; 1, 12/11, 7/6, 14/11, 5/4, 15/11, 35/24, 35/22, 5/3, 20/11, 7/4, 21/11, 2

; LMY WTP
giWTP = ftgen(201, 0, 128, -51,
              12, 2, 297.989, 63,
              1, 567/512, 9/8, 147/128, 21/16, 1323/1024, 189/128, 3/2, 49/32, 7/4, 441/256, 63/32, 2)

; Grady Centaur
giCent = ftgen(202, 0, 128, -51,
               12, 2, 240, 60,
               1.0, 21/20, 9/8, 7/6, 5/4, 4/3, 7/5, 3/2, 14/9, 5/3, 7/4, 15/8, 2.0)

; Meta Slendro C (derived by me, also by Warren Burt)
giMeta = ftgen(203, 0, 128, -51,
               12, 2, 240, 60,
               1.0, 65/64, 9/8, 37/32, 151/128, 5/4, 21/16, 43/32, 3/2, 49/32, 25/16, 7/4, 57/32, 2.0)

; bohlen_12.scl: 12-tone scale by Bohlen generated from the 4:7:10 triad, Acustica 39/2, 1978
giA12 = ftgen(204, 0, 128, -51,
              12, 3, 240, 60,
              1.0, 11/10, 6/5, 30/23, 10/7, 11/7, 7/4, 21/11, 21/10, 23/10, 5/2, 11/4, 3.0)

; bohlen_h_ji.scl: Bohlen's harmonic scale, just version
; as used in Prism, Mirror, Lens
;  1/1 27/25 9/7 7/5 5/3 9/5 15/7 7/3 63/25 3/1
giBph = ftgen(205, 0, 128, -51,
              12, 3, 240, 60,
              1.0, 27/25, 9/7, 7/5, $N, 5/3, 9/5, 15/7, 7/3, $N, $N, 63/25, 3.0)
          ; c    c+     d    d+       f    f+   g     g+           b      c

; Harrison Revelation
giRev = ftgen(206, 0, 128, -51,
              12, 2, 240, 60,
              1.0, 63/64, 9/8, 567/512, 81/64, 21/16, 729/512, 3/2, 189/128, 27/16, 7/4, 243/128, 2.0)

; associate tuning table numbers with OSC button indices
gi_tuning_map[] = fillarray(giCent, -1,
                            giHex,  -1,
                            giA12,  -1,
                            giBph,  -1,
                            giMeta, -1,
                            giWTP,  -1,
                            giRev,  -1,
                            -1,     -1)

;;---------------
;; other globals
;;---------------

; active tuning, set on commandline using "--omacro:TUNING=N"
; defaults to Centaur
#ifndef TUNING
#define TUNING #giCent#
#endif
gk_tuning init $TUNING

; global audio output busses
ga_main_out init 0
ga_combos_out init 0
ga_means_out init 0
ga_ringmod_out init 0

; wave tables assignments for secondary/derived instruments
gk_generated_wave init gi_sine

gk_left_on init 0

gk_left_freq init 0
gk_right_freq init 0

gk_left_note init 0
gk_right_note init 0

; for fixed reduction range
#define LOW_NOTE_LIMIT  #36#
#define HIGH_NOTE_LIMIT #84#

#define REDUCE_NONE   #0#
#define REDUCE_FIXED  #1#
#define REDUCE_LOWER  #2#
#define REDUCE_UPPER  #3#

gk_reduction init $REDUCE_NONE

; 1 == main voices same as generated voices
gk_blend init 0

; global envelope values
#define RISE  #2#
#define FALL  #0.2#

gi_osc_handle = OSCinit(7777)

;;--------
;; UDOs
;;--------

; transpose a frequency value by octave if it falls outside the defined range
opcode reduce, i, iii
  isig, imin, imax xin

  prints("<<<<<\nreduce: isig=%f imin=%f imax=%f\n", isig, imin, imax)

  ; if either setting is 0, return frequence as-is
  if (imin == 0 || imin == 0) then
    iout = isig
  else
    iout = abs(isig)
    prints("reduce: iout=%f\n", iout)
    if (iout != 0) then
      if (iout < imin) then
        prints("reduce: iout < imin\n")
        while iout < imin do
          iout *= 2
          prints("reduce: iout=%f\n", iout)
        od
      elseif (iout > imax) then
        prints("reduce: iout > imax\n")
        while iout > imax do
          iout *= 0.5
          prints("reduce: iout=%f\n", iout)
        od
      endif
    endif
  endif

  prints("reduce: final iout=%f\n>>>>>\n", iout)
  xout iout
endop

; given a note number, calculate the C-based octave range to which the note
; belongs
opcode _calc_8ve_range, ii,i
  inote xin

  ipitchclass = pchmidinn(inote)
  imin_note = inote - (frac(ipitchclass) * 100)
  imax_note = imin_note + 12

  xout imin_note, imax_note
endop

; given two notes, determine the range into which
; any derived tones must be transposed, based on
; the reduction type
opcode get_minmax, ii,ii
  ileft_note, iright_note xin

  prints("get_minmax: left=%d right=%d\n", ileft_note, iright_note)

  if (ileft_note < iright_note) then
    ilower_note = ileft_note
    iupper_note = iright_note
  else
    ilower_note = iright_note
    iupper_note = ileft_note
  endif
  prints("get_minmax: ilower_note=%d iupper_note=%d\n", ilower_note, iupper_note)

  imin_note = 0
  imax_note = 0

  ireduce = i(gk_reduction)
  prints("get_minmax: REDUCTION=%d\n", ireduce)
  if (ireduce == $REDUCE_FIXED) then
    ; use a fixed (preset) range
    imin_note = $LOW_NOTE_LIMIT
    imax_note = $HIGH_NOTE_LIMIT
  elseif (ireduce == $REDUCE_LOWER) then
    ; use range defined by C-based octave that contains lower note
    imin_note, imax_note _calc_8ve_range ilower_note
  elseif (ireduce == $REDUCE_UPPER) then
    ; use range defined by C-based octave that contains upper note
    imin_note, imax_note _calc_8ve_range iupper_note
  endif

  prints("get_minmax: lower=%d, upper=%d, type: %d -> min: %d, max: %d\n",
          ilower_note, iupper_note, i(gk_reduction), imin_note, imax_note)

  xout imin_note, imax_note
endop

opcode combination_engine, a, kiiiii
  ktab, iamp, ifreq1, ifreq2, imin, imax xin

  iamp /= 5

  idiff  = ifreq2 - ifreq1              ; difference tone
  idiff2 = (2 * ifreq2) - ifreq1        ; 2nd order difference tone
  idiff3 = (3 * ifreq2) - (2 * ifreq1)  ; 3rd order difference tone
  isum   = ifreq1 + ifreq2              ; summation tone
  isum2  = (2 * ifreq1) + ifreq2        ; 2nd order summation tone
  iprod  = ifreq1 * ifreq2              ; product

  prints("combos          : idiff=%f idiff2=%f idiff3=%f isum=%f isum2=%f iprod=%f\n",
         idiff, idiff2, idiff3, isum, isum2, iprod)

  idiff  = reduce(idiff,  imin, imax)
  idiff2 = reduce(idiff2, imin, imax)
  idiff3 = reduce(idiff3, imin, imax)
  isum   = reduce(isum,   imin, imax)
  isum2  = reduce(isum2,  imin, imax)
  iprod  = reduce(iprod,  imin, imax)

  prints("combos (reduced): idiff=%f idiff2=%f idiff3=%f isum=%f isum2=%f iprod=%f\n",
         idiff, idiff2, idiff3, isum, isum2, iprod)

  adiff  = oscilikt(iamp, idiff,  ktab)
  adiff2 = oscilikt(iamp, idiff2, ktab)
  adiff3 = oscilikt(iamp, idiff3, ktab)
  asum   = oscilikt(iamp, isum,   ktab)
  asum2  = oscilikt(iamp, isum2,  ktab)
  aprod  = oscilikt(iamp, iprod,  ktab)

  aout = (adiff  * $CTL_COMBOS_DIFF1) +
         (adiff2 * $CTL_COMBOS_DIFF2) +
         (adiff3 * $CTL_COMBOS_DIFF3) +
         (asum   * $CTL_COMBOS_SUM1)  +
         (asum2  * $CTL_COMBOS_SUM2)  +
         (aprod  * $CTL_COMBOS_PROD)
  xout aout
endop

opcode means_engine, a, kiii
  ktab, iamp, ifreq1, ifreq2 xin

  iamp /= 4

  iari = (ifreq1 + ifreq2) / 2                      ; arithmetic mean
  igeo = sqrt(ifreq1 * ifreq2)                      ; geometric mean
  ihar = (2 * ifreq1 * ifreq2) / (ifreq1 + ifreq2)  ; harmonic mean
  iphi = ifreq1 + ((ifreq2 - ifreq1) * 0.618)       ; golden mean

  ; prints("Means: ifreq1=%f ifreq2=%f iari=%f igeo=%f ihar=%f iphi=%f\n",
  ;        ifreq1, ifreq2, iari, igeo, ihar, iphi)

  aari = oscilikt(iamp, iari, ktab)
  ageo = oscilikt(iamp, igeo, ktab)
  ahar = oscilikt(iamp, ihar, ktab)
  aphi = oscilikt(iamp, iphi, ktab)

  aout = (aari * $CTL_MEANS_ARI) +
         (ageo * $CTL_MEANS_GEO) +
         (ahar * $CTL_MEANS_HAR) +
         (aphi * $CTL_MEANS_PHI)
  xout aout
endop

; start a named instrument if not already started
opcode start_if_off, 0, Sikkkk
  Sinst, iamp, kfreq1, kfreq2, knote1, knote2 xin

  iinst = nstrnum(Sinst)
  kcount = active(Sinst)
  if (kcount == 0) then
    kstarted = 1
    event("i", Sinst, 0, -1, iamp, kfreq1, kfreq2, knote1, knote2)
  endif
endop

; stop a named instrument if it's running
opcode stop_if_on, 0,S
  Sinst xin

  icount = active(Sinst)
  inum = nstrnum(Sinst)

  ; ensure negative inst number so it will stop
  if (inum > 0) then
    inum = 0 - inum
  endif

  if (icount > 0) then
    event_i("i", inum, 0, 1)
  endif
endop

; set wave table to be used for generated tones
opcode set_generated_waveform, 0,i
  itab xin
  gk_generated_wave = itab
endop

; set how generated chords are reduced (or not)
opcode set_reduction_type, 0,i
  itype xin
  gk_reduction = itype
endop

; set tuning table
opcode set_tuning, 0,k
  kscale xin
  gk_tuning = kscale
endop

; read an OSC control with a single value
opcode _read_osc_control, k,SS
  Spath, Stype xin
  karg init 0
  kout init -1

  kk = OSClisten(gi_osc_handle, Spath, Stype, karg)
  if (kk == 1) then
    kout = karg
  else
    kout = -1
  endif

  xout kout
endop

opcode read_osc, 0,0
  prints("Reading OSC...\n")
  karg init 0

  kosc_count OSCcount
  if (kosc_count == 0) kgoto end
  printks("kosc_count=%d\n", 1, kosc_count)

  next:

  karg = _read_osc_control("/implication_organ/master/main", "f")
  if (karg != -1) then
    $CTL_MAIN_LEVEL = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/master/generated", "f")
  if (karg != -1) then
    $CTL_GENERATED_LEVEL = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/combos/sub", "f")
  if (karg != -1) then
    $CTL_COMBOS_LEVEL = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/combos/diff1", "f")
  if (karg != -1) then
    $CTL_COMBOS_DIFF1 = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/combos/diff2", "f")
  if (karg != -1) then
    $CTL_COMBOS_DIFF2 = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/combos/diff3", "f")
  if (karg != -1) then
    $CTL_COMBOS_DIFF3 = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/combos/sum1", "f")
  if (karg != -1) then
    $CTL_COMBOS_SUM1 = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/combos/sum2", "f")
  if (karg != -1) then
    $CTL_COMBOS_SUM2 = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/combos/prod", "f")
  if (karg != -1) then
    $CTL_COMBOS_PROD = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/means/sub", "f")
  if (karg != -1) then
    $CTL_MEANS_LEVEL = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/means/ari", "f")
  if (karg != -1) then
    $CTL_MEANS_ARI = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/means/geo", "f")
  if (karg != -1) then
    $CTL_MEANS_GEO = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/means/har", "f")
  if (karg != -1) then
    $CTL_MEANS_HAR = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/means/phi", "f")
  if (karg != -1) then
    $CTL_MEANS_PHI = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/detune", "f")
  if (karg != -1) then
    $CTL_DETUNE = karg
    kgoto next
  endif

  karg = _read_osc_control("/implication_organ/blend", "f")
  if (karg != -1) then
    gk_blend = karg
    kgoto next
  endif

  kwaveform_data[] init 4
  kwaveform_msg, kwaveform_data OSClisten gi_osc_handle, "/implication_organ/generated_waveform", "ffff"
  if (kwaveform_msg == 1) then
    k_, kwaveform maxarray kwaveform_data
    kwaveform += 1
    printks("new waveform: %d\n", 0, kwaveform)
    gk_generated_wave = kwaveform
    kgoto next
  endif

  kreduction_data[] init 4
  kreduction_msg, kreduction_data OSClisten gi_osc_handle, "/implication_organ/reduction_type", "ffff"
  if (kreduction_msg == 1) then
    k_, kreduction maxarray kreduction_data
    printks("new reduction: %d\n", 0, kreduction)
    gk_reduction = kreduction
    kgoto next
  endif

  kpreset_data[] init 30
  kpreset_msg, kpreset_data OSClisten gi_osc_handle, "/implication_organ/preset", "ffffffffffffffffffffffffffffff"
  if (kpreset_msg == 1) then
    k_, kpreset maxarray kpreset_data
    printks("new preset: %d\n", 0, kpreset)
    event("i", "scanx_init", 0, 0, kpreset, $SCANX_ID)
    kgoto next
  endif

  ktuning_data[] init 16
  ktuning_msg, ktuning_data OSClisten gi_osc_handle, "/implication_organ/tuning", "ffffffffffffffff"
  if (ktuning_msg == 1) then
    k_, ktuning maxarray ktuning_data
    ktuning = gi_tuning_map[ktuning]
    if (ktuning != -1) then
      printks("new tuning: %d\n", 0, ktuning)
      set_tuning(ktuning)
    else
      printks("invalid tuning: %d\n", 0, ktuning)
    endif
    kgoto next
  endif

  end:
endop


;-------------
;; instruments
;;-------------

; MIDI setup for keyboard input...
massign 1, "Starter"
maxalloc "Starter", 2

; set stuff up
instr Init
  ; scanning synthesis initialization
  event_i("i", "scanx_init", 0, 1, $SCANX_DEFAULT_PRESET, $SCANX_ID)

  set_generated_waveform(gi_sine)
  set_reduction_type($REDUCE_NONE)
  set_tuning($TUNING)

  turnoff
endin

; start polling OSC controls
instr Listener
  read_osc
endin

; process MIDI notes
; only two instances allowed
instr Starter
  kstarted init 0
  krel init 0

  if (kstarted == 1) kgoto test_release
  kstarted = 1

  ; get MIDI info
  inote_num notnum
  iamp = ampmidi(0dbfs * 0.5)

  ; fractional instrument number embeds the note number
  iinstnum = 23 + (inote_num * 0.001)

  ; kfreq = gk_pitchmap[inote_num]
  kfreq = tab_i(inote_num, i(gk_tuning))
  ; if (kfreq == 0) then
  ;   printks("Skipping note 0 (%d)\n", 0, inote_num)
  ;   goto testrel
  ; endif

  ; determine which "side" this is
  kleft = gk_left_on == 0 ? 1 : 0
  if (kleft == 1) then
    gk_left_freq = kfreq
    gk_left_note = inote_num
    gk_left_on = 1
  else
    gk_right_freq = kfreq
    gk_right_note = inote_num
  endif

  printks("Starter: gk_left_freq=%f (%d) gk_right_freq=%f (%d)\n",
          0, gk_left_freq, gk_left_note, gk_right_freq, gk_right_note)
  printks("Starting %d:%f (left:%d) %f Hz\n",0, inote_num, iinstnum, kleft, kfreq)
  event("i", iinstnum, 0, -1, kfreq, iamp)

  ; if we have two frequencies to work with, build the derived tones/chords
  printks("gk_left_freq=%f gk_right_freq=%f\n", 0, gk_left_freq, gk_right_freq)
  printks("gk_left_note=%f gk_right_note=%f\n", 0, gk_left_note, gk_right_note)
  if (gk_left_freq != 0 && gk_right_freq != 0) then
    start_if_off("Deriver", iamp, gk_left_freq, gk_right_freq, gk_left_note, gk_right_note)
  endif

  test_release:
  krel = release()
  if (krel == 1) then
    printks("Goodbye %d:%f\n", 0, inote_num, kfreq)
    event("i", "Stopper", 0, 0.1, iinstnum, kleft)
  endif
endin

; turn off a note and all derived tones
instr Stopper
  instnum = p4
  kleft = p5

  prints("Stopping %f (%d)\n", instnum, kleft)
  turnoff2(instnum, 4, 1)

  stop_if_on("Deriver")
  ; stop_if_on(26)

  if (kleft == 1) then
    gk_left_freq = 0
    gk_left_note = 0
    gk_left_on = 0
  else
    gk_right_freq = 0
    gk_right_note = 0
  endif

  turnoff
endin

; scanned synth (main voice)
instr 23
  kcps = p4
  kamp = p5

  aenv = linsegr(0,
                 $RISE, 1,
                 $FALL, 0)

  if (gk_blend == 1) then
    a1 = oscilikt(kamp * 0.5, kcps, gk_generated_wave)
    aout = a1 * aenv
  else
    ; determine amount of detuning based on percentage of frequency
    kdiff = kcps * (scale($CTL_DETUNE, 0.001, 0.0001) / 2)
    a1 = scanx(kamp, kcps + kdiff, $SCANX_ID)
    a2 = scanx(kamp, kcps - kdiff, $SCANX_ID+1)
    aout = ntrpol(a1*0.6, a2*0.6, 0.5) * aenv
  endif

  ga_main_out = ga_main_out + aout
endin

; derived tones: Combination Engine / Pythagorean & Golden Means
instr +Deriver
  iamp = p4
  ifreq1 = p5
  ifreq2 = p6
  inote1 = p7
  inote2 = p8

  prints("Deriver: ifreq1=%f ifreq2=%f inote1=%f inote2=%f\n",
         ifreq1, ifreq2, inote1, inote2)

  aenv = linsegr(0,
                 $RISE, 1,
                 $FALL, 0)

  imin_note, imax_note get_minmax inote1, inote2

  ; imin = imin_note > 0 ? i(gk_pitchmap[imin_note]) : 0
  ; imax = imax_note > 0 ? i(gk_pitchmap[imax_note]) : 0
  imin = imin_note > 0 ? tab_i(imin_note, i(gk_tuning)) : 0
  imax = imax_note > 0 ? tab_i(imax_note, i(gk_tuning)) : 0

  prints("Deriver: imin_note=%d imax_note=%d imin=%f imax=%f\n",
         imin_note,imax_note, imin, imax)

  a1 = combination_engine(gk_generated_wave, iamp, ifreq1, ifreq2, imin, imax)
  aout1 = a1 * aenv * $CTL_COMBOS_LEVEL
  ga_combos_out = ga_combos_out + aout1

  a2 = means_engine(gk_generated_wave, iamp, ifreq1, ifreq2)
  aout2 = a2 * aenv * $CTL_MEANS_LEVEL
  ga_means_out = ga_means_out + aout2
endin

; audio output
instr Output
  asub1 = ga_ringmod_out + ga_combos_out + ga_means_out

  a1 = ga_main_out * $CTL_MAIN_LEVEL
  a2 = asub1 * $CTL_GENERATED_LEVEL

  out(a1, a2)

  ga_main_out = 0
  ga_ringmod_out = 0
  ga_combos_out = 0
  ga_means_out = 0
endin

</CsInstruments>
<CsScore>

#define PLAY_FOR      #0#
#define A_SHORT_TIME  #1#
#define A_LONG_TIME   #[3600*24]#

; Tarmo's tables for scanned synthesis
#include "inc/scanu_tables.sco"

i "Init"      $PLAY_FOR $A_SHORT_TIME
i "Listener"  $PLAY_FOR $A_LONG_TIME
i "Output"    $PLAY_FOR $A_LONG_TIME
e

</CsScore>
</CsoundSynthesizer>
