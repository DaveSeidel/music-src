;;----------------------------
;; Implication Organ v4.0
;; Dave Seidel, January 2020
;;----------------------------

;----------------------------------------------------------
; - Expects MIDI notes on channels 1 and 2
; - Responds to OSC on port 7777 for parameter control
; - Send OSC to port 8080
; - Defaults to dual mono output: 1 = main dyad, 2 = derived voices
; - Use --omacro:BINAURAL=1 for four-channel output, where 1 & 2 are
;     the main dyad in binaural stereo, and 3 & 4 are the derived
;     voices (duplicated)
;----------------------------------------------------------

<CsoundSynthesizer>
<CsOptions>
 -d -m0 -Ma --realtime --sample-accurate
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 20
nchnls = 2
0dbfs = 1


; presets for Tarmo Johannes' scanned synthesis configurations
#include "inc/scanu_presets.orc"
; table ID
#define SCANX_ID              #4#
; default preset
#define SCANX_DEFAULT_PRESET  #9#

; low-pass filter for main voice
#define FILTER_MIN_CUTOFF       #20#
#define FILTER_MAX_CUTOFF       #sr/4#
#define CALC_FILTER_CUTOFF(VAL) #scale($VAL, $FILTER_MIN_CUTOFF, $FILTER_MAX_CUTOFF)#


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

#define CTL_LPF_CUTOFF        #gk_ctl_16#
#define CTL_LPF_Q             #gk_ctl_17#

#define CTL_REV1_FB           #gk_ctl_18#
#define CTL_REV1_WET          #gk_ctl_19#
#define CTL_REV2_FB           #gk_ctl_20#
#define CTL_REV2_WET          #gk_ctl_21#

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
#ifndef BASE_FREQ
#define BASE_FREQ #240#
#endif
#ifndef FREQ_MULT
#define FREQ_MULT #2^3#
#endif

; 1-3-5-7 hexany (odd keys) alternating with the same series transposed up by some
; semitone-type interval (even keys) -- these sub-scales have the same fingering as 12ET
; wholetone scales
giHex = ftgen(200, 0, 128, -51,
              12, 2, $BASE_FREQ, 60,
              1, 16/15, 7/6, 56/45, 5/4, 4/3, 35/24, 14/9, 5/3, 16/9, 7/4, 28/15, 2)

; LMY WTP
giWTP = ftgen(201, 0, 128, -51,
              12, 2, 297.989, 63,
              1, 567/512, 9/8, 147/128, 21/16, 1323/1024, 189/128, 3/2, 49/32, 7/4, 441/256, 63/32, 2)

; Grady Centaur
giCent = ftgen(202, 0, 128, -51,
               12, 2, $BASE_FREQ, 60,
               1.0, 21/20, 9/8, 7/6, 5/4, 4/3, 7/5, 3/2, 14/9, 5/3, 7/4, 15/8, 2.0)

; Meta Slendro C (derived by me, also by Warren Burt)
giMeta = ftgen(203, 0, 128, -51,
               12, 2, $BASE_FREQ, 60,
               1.0, 65/64, 9/8, 37/32, 151/128, 5/4, 21/16, 43/32, 3/2, 49/32, 25/16, 7/4, 57/32, 2.0)

; bohlen_12.scl: 12-tone scale by Bohlen generated from the 4:7:10 triad, Acustica 39/2, 1978
giA12 = ftgen(204, 0, 128, -51,
              12, 3, $BASE_FREQ, 60,
              1.0, 11/10, 6/5, 30/23, 10/7, 11/7, 7/4, 21/11, 21/10, 23/10, 5/2, 11/4, 3.0)

; bohlen_h_ji.scl: Bohlen's harmonic scale, just version
; as used in Prism, Mirror, Lens
;  1/1 27/25 9/7 7/5 5/3 9/5 15/7 7/3 63/25 3/1
giBph = ftgen(205, 0, 128, -51,
              12, 3, $BASE_FREQ, 60,
              1.0, 27/25, 9/7, 7/5, $N, 5/3, 9/5, 15/7, 7/3, $N, $N, 63/25, 3.0)

; Harrison Revelation
giRev = ftgen(206, 0, 128, -51,
              12, 2, $BASE_FREQ, 60,
              1.0, 63/64, 9/8, 567/512, 81/64, 21/16, 729/512, 3/2, 189/128, 27/16, 7/4, 243/128, 2.0)

; associate tuning table numbers with 0-based indices
gi_tuning_map[] = fillarray(giCent,
                            giHex,
                            giA12,
                            giBph,
                            giMeta,
                            giWTP,
                            giRev)

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
ga_main_out_1 init 0
ga_main_out_2 init 0
ga_combos_out init 0
ga_means_out init 0

; wave tables assignments for secondary/derived instruments
gk_generated_wave init gi_sine

; for fixed reduction range
#define LOW_NOTE_LIMIT  #36#
#define HIGH_NOTE_LIMIT #84#

#define REDUCE_NONE   #1#
#define REDUCE_FIXED  #2#
#define REDUCE_LOWER  #3#
#define REDUCE_UPPER  #4#

gk_reduction init $REDUCE_NONE

; 1 == main voices same as generated voices
gk_blend init 0

; global envelope values
#define RISE  #2#
#define FALL  #2#

gi_osc_handle = OSCinit(7777)

gi_scanx_preset init $SCANX_DEFAULT_PRESET
gi_global_reset init 0

#ifndef GLOBAL_PRESET
#define GLOBAL_PRESET #0#
#endif

#ifdef FREQ_MULT
gk_freq_mult init $FREQ_MULT
#else
gk_freq_mult init 1
#endif

#ifndef BINAURAL
#define BINAURAL #1#
#endif
gi_binaural init $BINAURAL

#ifndef MIDI_NOTE_OFFSET
#define MIDI_NOTE_OFFSET #36#
#endif

#ifdef STRICT_DERIVED_TONES
  #define TIED_TONES_OP #||#
#else
  #define TIED_TONES_OP #&&#
#endif


;;--------
;; UDOs
;;--------

; transpose a frequency value by octave if it falls outside the defined range
opcode reduce, i, iiii
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
opcode get_minmax, ii,iii
  ifirst_note, isecond_note, ireduce xin

  ; prints("get_minmax: first=%d second=%d\n", ifirst_note, isecond_note)

  if (ifirst_note < isecond_note) then
    ilower_note = ifirst_note
    iupper_note = isecond_note
  else
    ilower_note = isecond_note
    iupper_note = ifirst_note
  endif
  ; prints("get_minmax: ilower_note=%d iupper_note=%d\n", ilower_note, iupper_note)

  imin_note = 0
  imax_note = 0

  ; prints("get_minmax: REDUCTION=%d\n", ireduce)
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

  ; prints("get_minmax: lower=%d, upper=%d, type: %d -> min: %d, max: %d\n",
  ;         ilower_note, iupper_note, i(gk_reduction), imin_note, imax_note)

  xout imin_note, imax_note
endop

opcode combination_engine, a, kiiiiiii
  ktab, iamp, ifreq1, ifreq2, imin, imax, imult, iskip xin

  iamp /= 3

  idiff  = ifreq2 - ifreq1              ; difference tone
  idiff2 = (2 * ifreq2) - ifreq1        ; 2nd order difference tone
  idiff3 = (3 * ifreq2) - (2 * ifreq1)  ; 3rd order difference tone
  isum   = ifreq1 + ifreq2              ; summation tone
  isum2  = (2 * ifreq1) + ifreq2        ; 2nd order summation tone
  iprod  = ifreq1 * ifreq2              ; product

  ; prints("combos          : idiff=%f idiff2=%f idiff3=%f isum=%f isum2=%f iprod=%f\n",
  ;        idiff, idiff2, idiff3, isum, isum2, iprod)

  idiff  = reduce(idiff,  imin, imax, imult)
  idiff2 = reduce(idiff2, imin, imax, imult)
  idiff3 = reduce(idiff3, imin, imax, imult)
  isum   = reduce(isum,   imin, imax, imult)
  isum2  = reduce(isum2,  imin, imax, imult)
  iprod  = reduce(iprod,  imin, imax, imult)

  ; prints("combos (reduced): idiff=%f idiff2=%f idiff3=%f isum=%f isum2=%f iprod=%f\n",
  ;        idiff, idiff2, idiff3, isum, isum2, iprod)

  adiff  = oscilikt(iamp, idiff,  ktab, 0, iskip)
  adiff2 = oscilikt(iamp, idiff2, ktab, 0, iskip)
  adiff3 = oscilikt(iamp, idiff3, ktab, 0, iskip)
  asum   = oscilikt(iamp, isum,   ktab, 0, iskip)
  asum2  = oscilikt(iamp, isum2,  ktab, 0, iskip)
  aprod  = oscilikt(iamp, iprod,  ktab, 0, iskip)

  aout = (adiff  * $CTL_COMBOS_DIFF1) +
         (adiff2 * $CTL_COMBOS_DIFF2) +
         (adiff3 * $CTL_COMBOS_DIFF3) +
         (asum   * $CTL_COMBOS_SUM1)  +
         (asum2  * $CTL_COMBOS_SUM2)  +
         (aprod  * $CTL_COMBOS_PROD)
  xout aout
endop

opcode means_engine, a, kiiiii
  ktab, iamp, ifreq1, ifreq2, imult, iskip xin

  iamp /= 4

  iari = (ifreq1 + ifreq2) / 2                      ; arithmetic mean
  igeo = sqrt(ifreq1 * ifreq2)                      ; geometric mean
  ihar = (2 * ifreq1 * ifreq2) / (ifreq1 + ifreq2)  ; harmonic mean
  iphi = ifreq1 + ((ifreq2 - ifreq1) * 0.618)       ; golden mean

  ; prints("Means: ifreq1=%f ifreq2=%f iari=%f igeo=%f ihar=%f iphi=%f\n",
  ;        ifreq1, ifreq2, iari, igeo, ihar, iphi)

  aari = oscilikt(iamp, iari * imult, ktab, 0, iskip)
  ageo = oscilikt(iamp, igeo * imult, ktab, 0, iskip)
  ahar = oscilikt(iamp, ihar * imult, ktab, 0, iskip)
  aphi = oscilikt(iamp, iphi * imult, ktab, 0, iskip)

  aout = (aari * $CTL_MEANS_ARI) +
         (ageo * $CTL_MEANS_GEO) +
         (ahar * $CTL_MEANS_HAR) +
         (aphi * $CTL_MEANS_PHI)
  xout aout
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
  if (kosc_count == 0) kgoto END
  printks("kosc_count=%d\n", 1, kosc_count)

  NEXT:

  karg = _read_osc_control("/io/master/main", "f")
  if (karg != -1) then
    $CTL_MAIN_LEVEL = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/master/generated", "f")
  if (karg != -1) then
    $CTL_GENERATED_LEVEL = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/combos/sub", "f")
  if (karg != -1) then
    $CTL_COMBOS_LEVEL = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/combos/diff1", "f")
  if (karg != -1) then
    $CTL_COMBOS_DIFF1 = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/combos/diff2", "f")
  if (karg != -1) then
    $CTL_COMBOS_DIFF2 = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/combos/diff3", "f")
  if (karg != -1) then
    $CTL_COMBOS_DIFF3 = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/combos/sum1", "f")
  if (karg != -1) then
    $CTL_COMBOS_SUM1 = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/combos/sum2", "f")
  if (karg != -1) then
    $CTL_COMBOS_SUM2 = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/combos/prod", "f")
  if (karg != -1) then
    $CTL_COMBOS_PROD = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/means/sub", "f")
  if (karg != -1) then
    $CTL_MEANS_LEVEL = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/means/ari", "f")
  if (karg != -1) then
    $CTL_MEANS_ARI = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/means/geo", "f")
  if (karg != -1) then
    $CTL_MEANS_GEO = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/means/har", "f")
  if (karg != -1) then
    $CTL_MEANS_HAR = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/means/phi", "f")
  if (karg != -1) then
    $CTL_MEANS_PHI = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/detune", "f")
  if (karg != -1) then
    $CTL_DETUNE = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/blend", "f")
  if (karg != -1) then
    gk_blend = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/generated_waveform", "f")
  if (karg != -1) then
    gk_generated_wave = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/reduction_type", "f")
  if (karg != -1) then
    gk_reduction = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/preset", "f")
  if (karg != -1) then
    ; 0-based
    event("i", "scanx_init", 0, 0, karg-1, $SCANX_ID)
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/tuning", "f")
  if (karg != -1) then
    ; 0-based
    ktuning = gi_tuning_map[karg-1]
    if (ktuning != -1) then
      set_tuning(ktuning)
    else
      printks("invalid tuning: %d\n", 0, ktuning)
    endif
  endif

  karg = _read_osc_control("/io/filter/cutoff", "f")
  if (karg != -1) then
    $CTL_LPF_CUTOFF = $CALC_FILTER_CUTOFF(karg)
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/filter/q", "f")
  if (karg != -1) then
    $CTL_LPF_Q = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/reverb/1/fb", "f")
  if (karg != -1) then
    $CTL_REV1_FB = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/reverb/1/wet", "f")
  if (karg != -1) then
    $CTL_REV1_WET = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/reverb/2/fb", "f")
  if (karg != -1) then
    $CTL_REV2_FB = karg
    kgoto NEXT
  endif

  karg = _read_osc_control("/io/reverb/2/wet", "f")
  if (karg != -1) then
    $CTL_REV2_WET = karg
    kgoto NEXT
  endif

  END:
endop

opcode print_midi, 0, kkkk
  kstatus, kchan, kdata1, kdata2 xin

  if (kstatus == 144) then
    printks("\n----- status=%d ch=%d note=%d velocity=%d\tNote ON\n", 0, kstatus, kchan, kdata1, kdata2)
  elseif (kstatus == 128) then
    printks("\n----- status=%d ch=%d\tnote=%d velocity=%d\tNote OFF\n", 0, kstatus, kchan, kdata1, kdata2)
  elseif (kstatus == 160) then
    printks("\n----- status=%d ch=%d\tkdata1=%d kdata2=%d\tPolyphonic Aftertouch\n", 0, kstatus, kchan, kdata1, kdata2)
  elseif (kstatus == 176) then
    printks("\n----- status=%d ch=%d\t CC=%d value=%d\tControl Change\n", 0, kstatus, kchan, kdata1, kdata2)
  elseif (kstatus == 192) then
    printks("\n----- status=%d ch=%d\tkdata1=%d kdata2=%d\tProgram Change\n", 0, kstatus, kchan, kdata1, kdata2)
  elseif (kstatus == 208) then
    printks( "\n----- status=%d ch=%d\tkdata1=%d kdata2=%d\tChannel Aftertouch\n", 0, kstatus, kchan, kdata1, kdata2)
  elseif (kstatus == 224) then
    printks("\n----- status=%d ch=%d\t (data1, kdata2)=(%d, %d)\tPitch Bend\n", 0, kstatus, kchan, kdata1, kdata2)
  endif
endop


;-------------
;; instruments
;;-------------

#include "inc/global_presets.orc"

; MIDI setup: all channels, no instrument bindings
massign 0, 0

; set stuff up
instr Init
  prints("\n-----------\n")
  prints("BASE_FREQ=%f\n", $BASE_FREQ)
  prints("FREQ_MULT=%f\n", i(gk_freq_mult))
  prints("BINAURAL = $BINAURAL\n")
  prints("TIED_TONES_OP = $TIED_TONES_OP\n")
  prints("Global preset: ")
  if ($GLOBAL_PRESET > 0) then
    if ($GLOBAL_PRESET == 666) then
      prints("Moon Metal (%d)\n", $GLOBAL_PRESET)
      $GLOBAL_PRESET_MOON_METAL
    elseif ($GLOBAL_PRESET == 1) then
      prints("Involution 1 (%d)\n", $GLOBAL_PRESET)
      $GLOBAL_PRESET_INVOLUTION_1
    elseif ($GLOBAL_PRESET == 2) then
      prints("Involution 2 (%d)\n", $GLOBAL_PRESET)
      $GLOBAL_PRESET_INVOLUTION_2
    elseif ($GLOBAL_PRESET == 3) then
      prints("Involution 3 (%d)\n", $GLOBAL_PRESET)
      $GLOBAL_PRESET_INVOLUTION_3
    else
      prints("Unknown global preset $GLOBAL_PRESET\n")
    endif
  else
    prints("Using global defaults\n")
    set_generated_waveform(gi_sine)
    set_reduction_type($REDUCE_NONE)
    set_tuning($TUNING)
  endif
  prints("-----------\n\n")

  plot_freq(0, 0, 0)
  plot_freq(1, 0, 0)
  set_derived_state(0)

  ; scanning synthesis initialization
  event_i("i", "scanx_init", 0, 1, gi_scanx_preset, $SCANX_ID)

  turnoff
endin

; start polling OSC controls
instr OSCHandler
  read_osc
endin

;
; these macros work only inside the MIDIHandler instrument
;

#define STOP_MAIN_VOICE(INST) #
  printks("<-- Stopping %f\n", 0, $INST)
  if ($INST == 0) kgoto _STOP_MAIN_VOICE_DONE
  turnoff2($INST, 4, 1)
  _STOP_MAIN_VOICE_DONE:
#

#define STOP_DERIVED_VOICES #
  if (kfreqs[0] == 0 $TIED_TONES_OP kfreqs[1] == 0) then
    printks("<-- Stopping Deriver\n", 0)
    turnoff2(ideriver, 1, 1)
    set_derived_state(0)
  endif
#

#define START_DERIVED_VOICES #
  if (kfreqs[0] != 0 && kfreqs[1] != 0) then
    event("i", ideriver, 0, -1, kamp*0.75, kfreqs[0], kfreqs[1], knotes[0], knotes[1], gk_tuning, gk_freq_mult, gk_reduction, gk_generated_wave)
    set_derived_state(1)
  endif
#

#define PRINT_STATE(AARY'NARY'FARY'INST1'INST2)  #
    printks("*** assignments:[%f, %f] notes:[%d, %d] freqs:(%f, %f) instrs:(%d, %d) ***\n", 0,
    $AARY[0], $AARY[1], $NARY[0], $NARY[1], $FARY[0], $FARY[1], active:k($INST1), active:k($INST2))
#

#define STORE_NOTE(IDX'CHAN'INST'NOTE'FREQ'AMP) #
    printks("-> MIDI init -- channel:%d note:%d instr:%f\n", 0, $CHAN, $NOTE, $INST)
    event("i", $INST, 0, -1, $FREQ, $AMP, gk_generated_wave, gk_blend)
    kassign[$IDX] = $INST
    kfreqs[$IDX] = $FREQ
    knotes[$IDX] = $NOTE
    $PRINT_STATE(kassign'knotes'kfreqs'ivoice'ideriver)
    plot_freq($IDX, $NOTE, $FREQ)
#

#define CLEAR_NOTE(IDX'INST'KILL) #
    printks("<- MIDI release%s -- instr:%f\n", 0, $KILL == 1 ? " (KILL)" : "", $INST)
    $STOP_MAIN_VOICE($INST)
    $STOP_DERIVED_VOICES
    if (kassign[$IDX] == $INST) then
      kassign[$IDX] = 0
    endif
    kfreqs[$IDX] = 0
    knotes[$IDX] = 0
    $PRINT_STATE(kassign'knotes'kfreqs'ivoice'ideriver)
    plot_freq($IDX, 0, 0)
#

; process MIDI notes, by channel
instr MIDIHandler
  ; used in macros & elsewhere
  ideriver = nstrnum("Deriver")
  ivoice = nstrnum("Voice")

  ; tracking MIDI voice assignments, notes, frequencies per channel
  kassign[] fillarray 0, 0
  knotes[]  fillarray 0, 0
  kfreqs[]  fillarray 0, 0

  READ_LOOP:
  kstatus, kchan, kdata1, kdata2 midiin
  print_midi(kstatus, kchan, kdata1, kdata2)

  ; check for end of MIDI queue
  if kstatus == 0 kgoto DONE

  ; only channels 1 & 2
  if kchan > 2 kgoto READ_LOOP

  ; only care about NOTE-ON and NOTE-OFF
  if kstatus != 144 && kstatus != 128 kgoto READ_LOOP

  $PRINT_STATE(kassign'knotes'kfreqs'ivoice'ideriver)

  ; note numder and velocity
  knote = kdata1 + $MIDI_NOTE_OFFSET
  kveloc = kdata2

  ; fractional instrument number embeds the channel and note numbers (e.g., "23.10056")
  kinstnum = ivoice + (kchan * 0.1) + (knote * 0.0001)

  ; convert note number to frequency based on the current tuning
  kfreq = tablekt(knote, gk_tuning)

  kfirst = (kchan == 1) ? 1 : 0
  kchanidx = kchan - 1
  kamp = ampdb(-3)

  ; 0 velocity indicates Note Off, regardless of what kstatus says
  if kstatus == 128 || kveloc == 0 kgoto RELEASE

  ; clear out zombie notes first
  kprevious = kassign[kchanidx]
  if (kprevious != 0 && kprevious != kinstnum) then
    $CLEAR_NOTE(kchanidx'kprevious'1)
  endif

  ; if there's no active instrument for this channel/note, start one
  if (kassign[kchanidx] == 0) then
    $STORE_NOTE(kchanidx'kchan'kinstnum'knote'kfreq'kamp)
  endif

  ; if we have two frequencies to work with, build the derived tones/chords
  $START_DERIVED_VOICES

  kgoto READ_LOOP

  RELEASE:
  $CLEAR_NOTE(kchanidx'kinstnum'0)
  kgoto READ_LOOP

  DONE:
endin

; main voice (scanned synth)
instr +Voice
  kcps = p4
  kamp = p5
  kwave = p6
  kblend = p7

  ; xtratim 2
  aenv = linsegr(0,
                 $RISE, 1,
                 $FALL, 0)

  ; determine amount of detuning based on binaural beating or percentage of frequency
  kdiff = (gi_binaural == 0) ? kcps*(scale($CTL_DETUNE, 0.001, 0.0001) / 2) : $CTL_DETUNE
  if (kblend == 1) then
    a1 = oscilikt(kamp * 0.5, kcps - kdiff, kwave)
    a2 = oscilikt(kamp * 0.5, kcps + kdiff, kwave)
  else
    a1 = scanx(kamp, kcps - kdiff, $SCANX_ID)
    a2 = scanx(kamp, kcps + kdiff, $SCANX_ID+1)
  endif

  if (gi_binaural == 1) then
      aout = 0
      afilt1 = moogladder2(a1*0.5*aenv, $CTL_LPF_CUTOFF, $CTL_LPF_Q)
      afilt2 = moogladder2(a2*0.5*aenv, $CTL_LPF_CUTOFF, $CTL_LPF_Q)
      aout1, aout2 reverbsc afilt1, afilt2, $CTL_REV1_FB, sr/4, sr, 0.1, 0
      ga_main_out_1 = ga_main_out_1 + ((afilt1 * (1 - $CTL_REV1_WET)) + (aout1 * $CTL_REV1_WET))
      ga_main_out_2 = ga_main_out_2 + ((afilt2 * (1 - $CTL_REV1_WET)) + (aout2 * $CTL_REV1_WET))
  else
      aout = ntrpol(a1*0.6, a2*0.6, 0.5)*aenv
      afilt1 = moogladder2(aout*aenv, $CTL_LPF_CUTOFF, $CTL_LPF_Q)
      afilt2 = afilt1
      ga_main_out_1 = ga_main_out_1 + afilt1
      ga_main_out_2 = ga_main_out_2 + afilt2
  endif
endin

; derived tones: Combination Engine / Pythagorean & Golden Means
maxalloc "Deriver", 2
instr +Deriver
  iamp = p4
  ifreq1 = p5
  ifreq2 = p6
  inote1 = p7
  inote2 = p8
  ituning = p9
  ifreq_mult = p10
  ireduce = p11
  kwave = p12

  iskip tival
  prints("Deriver: 1:(%d, %f) 2:(%d, %f) tuning:%d mult:%f tied:%s\n",
         inote1, ifreq1, inote2, ifreq2, ituning, ifreq_mult, iskip == 1 ? "YES" : "NO")

  ; xtratim 2
  tigoto SKIP_INIT
  aenv = linsegr(0,
                 $RISE, 1,
                 1, 0)
  SKIP_INIT:

  imin_note, imax_note get_minmax inote1, inote2, ireduce
  imin = imin_note > 0 ? tab_i(imin_note, ituning) : 0
  imax = imax_note > 0 ? tab_i(imax_note, ituning) : 0

  ; prints("Deriver: imin_note=%d imax_note=%d imin=%f imax=%f\n",
  ;        imin_note,imax_note, imin, imax)

  a1 = combination_engine(kwave, iamp, ifreq1, ifreq2, imin, imax, ifreq_mult, iskip)
  aout1 = a1 * aenv * $CTL_COMBOS_LEVEL
  ga_combos_out = ga_combos_out + aout1

  a2 = means_engine(kwave, iamp, ifreq1, ifreq2, ifreq_mult, iskip)
  aout2 = a2 * aenv * $CTL_MEANS_LEVEL
  ga_means_out = ga_means_out + aout2
endin

; audio output
instr Output
  a1 = ga_main_out_1 * $CTL_MAIN_LEVEL
  a2 = ga_main_out_2 * $CTL_MAIN_LEVEL

  asub1 = ga_combos_out + ga_means_out
  if (gi_binaural = 1) then
    a3, a4 reverbsc asub1, asub1, $CTL_REV2_FB, sr/4, sr, 0.1, 0
    a3 = ((asub1 * (1 - $CTL_REV2_WET)) + (a3 * $CTL_REV2_WET)) * $CTL_GENERATED_LEVEL
    a4 = ((asub1 * (1 - $CTL_REV2_WET)) + (a4 * $CTL_REV2_WET)) * $CTL_GENERATED_LEVEL
  else
    a3 = asub1 * $CTL_GENERATED_LEVEL
    a4 = a3
  endif

  if (gi_binaural == 1) then
    out(a1, a2, a3, a4)
  else
    out(a1, a3)
  endif

  ga_main_out_1 = 0
  ga_main_out_2 = 0
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

i "Init"        $PLAY_FOR $A_SHORT_TIME
i "OSCHandler"  $PLAY_FOR $A_LONG_TIME
i "Output"      $PLAY_FOR $A_LONG_TIME
i "MIDIHandler" [$PLAY_FOR+0.5] $A_LONG_TIME
e

</CsScore>
</CsoundSynthesizer>
