;;------------------------
;; Implication Organ v1.0
;; Dave Seidel, July 2018
;;------------------------

<CsoundSynthesizer>
<CsOptions>
 -d -m0 -+rtmidi=portmidi -+raw_controller_mode=1 -Ma -b 256 -B 4096 --realtime --sched -j4
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 20
nchnls = 2
0dbfs = 1


; presets for Tarmo Johannes' scanned synthesis configurations
#include "inc/scanu_presets.orc"

; Steven Yi's implementation of Julian Parker's ring modulator
#include "inc/ringmod.udo"

;;------------------
;; MIDI controllers
;;------------------

;; Launch Control XL
#include "inc/lcxl.orc"
#include "inc/lc-common.orc"

; upper row of knobs
#define CTL_COMBOS_DIFF       #$KNOB_U1#
#define CTL_COMBOS_DIFF2      #$KNOB_U2#
#define CTL_COMBOS_DIFF3      #$KNOB_U3#
#define CTL_COMBOS_SUM        #$KNOB_U4#
#define CTL_COMBOS_SUM2       #$KNOB_U5#
#define CTL_COMBOS_PROD       #$KNOB_U6#

; middle row of knobs
#define CTL_MEANS_ARI         #$KNOB_M1#
#define CTL_MEANS_GEO         #$KNOB_M2#
#define CTL_MEANS_HAR         #$KNOB_M3#
#define CTL_MEANS_PHI         #$KNOB_M4#

; lower row of knobs
#define CTL_MAIN_DETUNE       #$KNOB_L1#

; sliders
#define CTL_MAIN_LEVEL        #$SLIDER_1#
#define CTL_GENERATED_LEVEL   #$SLIDER_2#
#define CTL_RINGMOD_LEVEL     #$SLIDER_3#
#define CTL_COMBOS_LEVEL      #$SLIDER_4#
#define CTL_MEANS_LEVEL       #$SLIDER_5#

; upper row of buttons
#define BUTT_GENERATED_SIN    #$BUTT_1U#
#define BUTT_GENERATED_FIB    #$BUTT_2U#
#define BUTT_GENERATED_PRI    #$BUTT_3U#
#define BUTT_GENERATED_ASY    #$BUTT_4U#

#define BUTT_REDUCE_UPPER     #$BUTT_5U#
#define BUTT_REDUCE_LOWER     #$BUTT_6U#
#define BUTT_REDUCE_FIXED     #$BUTT_7U#
#define BUTT_REDUCE_NONE      #$BUTT_8U#

; lower row of buttons
#define BUTT_TUNE_CENTAUR     #$BUTT_1L#
#define BUTT_TUNE_HEXANY      #$BUTT_2L#
#define BUTT_TUNE_BOHLEN_A12  #$BUTT_3L#
#define BUTT_TUNE_BOHLEN_HARM #$BUTT_4L#
#define BUTT_TUNE_METASLENDRO #$BUTT_5L#
#define BUTT_TUNE_WTP         #$BUTT_6L#
#define BUTT_TUNE_7           #$BUTT_7L#
#define BUTT_TUNE_8           #$BUTT_8L#

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
giHex  ftgen 100, 0, 128, -51, \
            12, 2, 240, 60, \
            1, 16/15, 7/6, 56/45, 5/4, 4/3, 35/24, 14/9, 5/3, 16/9, 7/4, 28/15, 2
            ; 1, 21/20, 7/6, 49/40, 5/4, 21/16, 35/24, 49/32, 5/3, 7/4, 7/4, 147/80, 2
            ; 1, 12/11, 7/6, 14/11, 5/4, 15/11, 35/24, 35/22, 5/3, 20/11, 7/4, 21/11, 2

; LMY WTP
giWTP  ftgen 101, 0, 128, -51, \
             12, 2, 297.989, 63, \
             1, 567/512, 9/8, 147/128, 21/16, 1323/1024, 189/128, 3/2, 49/32, 7/4, 441/256, 63/32, 2

; Grady Centaur
giCent ftgen 102, 0, 128, -51, \
             12, 2, 240, 60, \
             1.0, 21/20, 9/8, 7/6, 5/4, 4/3, 7/5, 3/2, 14/9, 5/3, 7/4, 15/8, 2.0

; Meta Slendro C (derived by me, also by Warren Burt)
giMeta ftgen 103, 0, 128, -51, \
             12, 2, 240, 60, \
             1.0, 65/64, 9/8, 37/32, 151/128, 5/4, 21/16, 43/32, 3/2, 49/32, 25/16, 7/4, 57/32, 2.0

; bohlen_12.scl: 12-tone scale by Bohlen generated from the 4:7:10 triad, Acustica 39/2, 1978
giA12 ftgen 104, 0, 128, -51, \
            12, 3, 240, 60, \
            1.0, 11/10, 6/5, 30/23, 10/7, 11/7, 7/4, 21/11, 21/10, 23/10, 5/2, 11/4, 3.0

; bohlen_h_ji.scl: Bohlen's harmonic scale, just version
; as used in Prism, Mirror, Lens
;  1/1 27/25 9/7 7/5 5/3 9/5 15/7 7/3 63/25 3/1
giBph ftgen 105, 0, 128, -51, \
            12, 3, 240, 60, \
            1.0, 27/25, 9/7, 7/5, $N, 5/3, 9/5, 15/7, 7/3, $N, $N, 63/25, 3.0
          ; c    c+     d    d+       f    f+   g     g+           b      c

;;---------------
;; other globals
;;---------------

; active tuning, set on commandline using "--omacro:TUNING=N"
; defaults to Centaur
#ifdef TUNING
gi_tuning init $TUNING
#else
gi_tuning init giCent
#endif

; this is where we'll copy the active GEN51 tuning table
gi_pitchmap[] init 128

; global audio output busses
ga_main_out init 0
ga_combos_out init 0
ga_means_out init 0
ga_ringmod_out init 0

; wave tables assignments for secondary/derived instruments
gk_generated_wave init gi_sine

gi_left_on init 0

gi_left_freq init 0
gi_right_freq init 0

gi_left_note init 0
gi_right_note init 0

; for fixed reduction range
#define KBD_LOW_C     #48#
#define KBD_HIGH_C    #72#

#define REDUCE_NONE   #0#
#define REDUCE_FIXED  #1#
#define REDUCE_LOWER  #2#
#define REDUCE_UPPER  #3#

gi_reduction init $REDUCE_NONE

; table ID for scanned synthesis
#define SCAN_ID #4#


;;--------
;; UDOs
;;--------

; transpose a frequency value by octave if it falls outside the defined range
opcode reduce, k, kii
  ksig, imin, imax xin

  ; if either setting is 0, return frequence as-is
  if (imin == 0 || imax == 0) then
    kout = ksig
  else
    kout = abs(ksig)
    if (kout != 0) then
      if (kout < imin) then
        while kout < imin do
          kout *= 2
        od
      elseif (kout > imax) then
        while kout > imax do
          kout *= 0.5
        od
      endif
    endif
  endif

  xout kout
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
  ileft_note,iright_note xin

  if (ileft_note > iright_note) then
    ilower_note = ileft_note
    iupper_note = iright_note
  else
    ilower_note = iright_note
    iupper_note = ileft_note
  endif

  imin_note = 0
  imax_note = 0

  if (gi_reduction == $REDUCE_FIXED) then
    ; use a fixed (preset) range
    imin_note = $KBD_LOW_C
    imax_note = $KBD_HIGH_C
  elseif (gi_reduction == $REDUCE_LOWER) then
    ; use range defined by C-based octave that contains lower note
    imin_note, imax_note _calc_8ve_range ilower_note
  elseif (gi_reduction == $REDUCE_UPPER) then
    ; use range defined by C-based octave that contains upper note
    imin_note, imax_note _calc_8ve_range iupper_note
  endif

  imin = imin_note > 0 ? gi_pitchmap[imin_note] : 0
  imax = imax_note > 0 ? gi_pitchmap[imax_note] : 0

  ;prints("Min/max: lower=%d, upper=%d, type: %d -> min: %f (%d), max: %f (%d)\n",
  ;       ilower_note, ilower_note, gi_reduction, imin, imin_note, imax, imax_note)

  xout imin, imax
endop

opcode combination_engine, a, kiiiii
  ktab,iamp,ifreq1,ifreq2,imin,imax xin

  iamp /= 6

  idiff  = ifreq2 - ifreq1              ; difference tone
  idiff2 = (2 * ifreq2) - ifreq1        ; 2nd order difference tone
  idiff3 = (3 * ifreq2) - (2 * ifreq1)  ; 3rd order difference tone
  isum   = ifreq1 + ifreq2              ; summation tone
  isum2  = (2 * ifreq1) + ifreq2        ; 2nd order summation tone
  iprod = ifreq1 * ifreq2               ; product

  adiff  = oscilikt(iamp, reduce(idiff, imin, imax),  ktab)
  adiff2 = oscilikt(iamp, reduce(idiff2, imin, imax), ktab)
  adiff3 = oscilikt(iamp, reduce(idiff3, imin, imax), ktab)
  asum   = oscilikt(iamp, reduce(isum, imin, imax),   ktab)
  asum2  = oscilikt(iamp, reduce(isum2, imin, imax),  ktab)
  aprod  = oscilikt(iamp, reduce(iprod, imin, imax),  ktab)

  aout = (adiff  * $CTL_COMBOS_DIFF)  +
         (adiff2 * $CTL_COMBOS_DIFF2) +
         (adiff3 * $CTL_COMBOS_DIFF3) +
         (asum   * $CTL_COMBOS_SUM)   +
         (asum2  * $CTL_COMBOS_SUM2)  +
         (aprod  * $CTL_COMBOS_PROD)
  xout aout
endop

opcode means_engine, a, kiiiii
  ktab,iamp,ifreq1,ifreq2,imin,imax xin

  iamp /= 4

  iari = (ifreq1 + ifreq2) / 2                      ; arithmetic mean
  igeo = sqrt(ifreq1 * ifreq2)                      ; geometric mean
  ihar = (2 * ifreq1 * ifreq2) / (ifreq1 + ifreq2)    ; harmonic mean
  iphi = ifreq1 + ((ifreq2 - ifreq1) * 0.618)        ; golden mean
  ; prints("Means: ifreq1=%f ifreq2=%f\niari=%f igeo=%f ihar=%f iphi=%f\n",
  ;        ifreq1, ifreq2, iari, igeo, ihar, iphi)

  aari = oscilikt(iamp, reduce(iari, imin, imax), ktab)
  ageo = oscilikt(iamp, reduce(igeo, imin, imax), ktab)
  ahar = oscilikt(iamp, reduce(ihar, imin, imax), ktab)
  aphi = oscilikt(iamp, reduce(iphi, imin, imax), ktab)

  aout = (aari * $CTL_MEANS_ARI) + \
         (ageo * $CTL_MEANS_GEO) + \
         (ahar * $CTL_MEANS_HAR) + \
         (aphi * $CTL_MEANS_PHI)
  xout aout
endop

opcode start_if_off, 0, iiiiii
  iinst,iamp,ifreq1,ifreq2,imin,imax xin

  kgoto DONE

  icount = active(iinst)
  prints("    start_if_off: iinst=%f, iamp=%f icount=%d\n", iinst, iamp, icount)
  if (icount == 0) then
    event_i("i", iinst, 0, -1, iamp, ifreq1, ifreq2, imin, imax)
  endif

  DONE:
endop

opcode stop_if_on, 0,i
  iinst xin

  kgoto DONE

  icount = active(iinst)
  ; ensure negative inst number so it will stop
  if (iinst > 0) then
    iinst = 0 - iinst
  endif

  prints("    stop_if_on: iinst=%f, icount=%d\n", iinst, icount)
  if (icount > 0) then
    event_i("i", iinst, 0, 1)
  endif

  DONE:
endop

; set wave table to be used for generated tones (except ringmod)
opcode set_generated_waveform, 0,i
  itab xin

  gk_generated_wave = itab

  if (itab == gi_sine) then
    butt_led_on($BUTT_GENERATED_SIN, $LED_RED_FULL)
    butt_led_off($BUTT_GENERATED_FIB)
    butt_led_off($BUTT_GENERATED_PRI)
    butt_led_off($BUTT_GENERATED_ASY)
  elseif (itab == gi_fib) then
    butt_led_off($BUTT_GENERATED_SIN)
    butt_led_on($BUTT_GENERATED_FIB, $LED_RED_FULL)
    butt_led_off($BUTT_GENERATED_PRI)
    butt_led_off($BUTT_GENERATED_ASY)
  elseif (itab == gi_prime) then
    butt_led_off($BUTT_GENERATED_SIN)
    butt_led_off($BUTT_GENERATED_FIB)
    butt_led_on($BUTT_GENERATED_PRI, $LED_RED_FULL)
    butt_led_off($BUTT_GENERATED_ASY)
  elseif (itab == gi_asymp) then
    butt_led_off($BUTT_GENERATED_SIN)
    butt_led_off($BUTT_GENERATED_FIB)
    butt_led_off($BUTT_GENERATED_PRI)
    butt_led_on($BUTT_GENERATED_ASY, $LED_RED_FULL)
  endif
endop

; set how generated chords are reduced (or not)
opcode set_reduction_type, 0,i
  itype xin

  gi_reduction = itype
  if (itype == $REDUCE_NONE) then
    butt_led_on($BUTT_REDUCE_NONE, $LED_YELLOW_FULL)
    butt_led_off($BUTT_REDUCE_FIXED)
    butt_led_off($BUTT_REDUCE_LOWER)
    butt_led_off($BUTT_REDUCE_UPPER)
  elseif (itype == $REDUCE_FIXED) then
    butt_led_off($BUTT_REDUCE_NONE)
    butt_led_on($BUTT_REDUCE_FIXED, $LED_YELLOW_FULL)
    butt_led_off($BUTT_REDUCE_LOWER)
    butt_led_off($BUTT_REDUCE_UPPER)
  elseif (itype == $REDUCE_LOWER) then
    butt_led_off($BUTT_REDUCE_NONE)
    butt_led_off($BUTT_REDUCE_FIXED)
    butt_led_on($BUTT_REDUCE_LOWER, $LED_YELLOW_FULL)
    butt_led_off($BUTT_REDUCE_UPPER)
  elseif (itype == $REDUCE_UPPER) then
    butt_led_off($BUTT_REDUCE_NONE)
    butt_led_off($BUTT_REDUCE_FIXED)
    butt_led_off($BUTT_REDUCE_LOWER)
    butt_led_on($BUTT_REDUCE_UPPER, $LED_YELLOW_FULL)
  endif
endop

; copy tuning table to array for easy lookup by MIDI note number
opcode set_tuning, 0,i
  iscale xin

  gi_tuning = iscale
  prints("*** Tuning: %d ***\n", gi_tuning)
  copyf2array(gi_pitchmap, gi_tuning)

  if (iscale == giCent) then
    butt_led_on($BUTT_TUNE_CENTAUR, $LED_GREEN_FULL)
    butt_led_off($BUTT_TUNE_HEXANY)
    butt_led_off($BUTT_TUNE_BOHLEN_A12)
    butt_led_off($BUTT_TUNE_BOHLEN_HARM)
    butt_led_off($BUTT_TUNE_METASLENDRO)
    butt_led_off($BUTT_TUNE_WTP)
    butt_led_off($BUTT_TUNE_7)
    butt_led_off($BUTT_TUNE_8)
  elseif (iscale == giHex) then
    butt_led_off($BUTT_TUNE_CENTAUR)
    butt_led_on($BUTT_TUNE_HEXANY, $LED_GREEN_FULL)
    butt_led_off($BUTT_TUNE_BOHLEN_A12)
    butt_led_off($BUTT_TUNE_BOHLEN_HARM)
    butt_led_off($BUTT_TUNE_METASLENDRO)
    butt_led_off($BUTT_TUNE_WTP)
    butt_led_off($BUTT_TUNE_7)
    butt_led_off($BUTT_TUNE_8)
  elseif (iscale == giA12) then
    butt_led_off($BUTT_TUNE_CENTAUR)
    butt_led_off($BUTT_TUNE_HEXANY)
    butt_led_on($BUTT_TUNE_BOHLEN_A12, $LED_GREEN_FULL)
    butt_led_off($BUTT_TUNE_BOHLEN_HARM)
    butt_led_off($BUTT_TUNE_METASLENDRO)
    butt_led_off($BUTT_TUNE_WTP)
    butt_led_off($BUTT_TUNE_7)
    butt_led_off($BUTT_TUNE_8)
  elseif (iscale == giBph) then
    butt_led_off($BUTT_TUNE_CENTAUR)
    butt_led_off($BUTT_TUNE_HEXANY)
    butt_led_off($BUTT_TUNE_BOHLEN_A12)
    butt_led_on($BUTT_TUNE_BOHLEN_HARM, $LED_GREEN_FULL)
    butt_led_off($BUTT_TUNE_METASLENDRO)
    butt_led_off($BUTT_TUNE_WTP)
    butt_led_off($BUTT_TUNE_7)
    butt_led_off($BUTT_TUNE_8)
  elseif (iscale == giMeta) then
    butt_led_off($BUTT_TUNE_CENTAUR)
    butt_led_off($BUTT_TUNE_HEXANY)
    butt_led_off($BUTT_TUNE_BOHLEN_A12)
    butt_led_off($BUTT_TUNE_BOHLEN_HARM)
    butt_led_on($BUTT_TUNE_METASLENDRO, $LED_GREEN_FULL)
    butt_led_off($BUTT_TUNE_WTP)
    butt_led_off($BUTT_TUNE_7)
    butt_led_off($BUTT_TUNE_8)
  elseif (iscale == giWTP) then
    butt_led_off($BUTT_TUNE_CENTAUR)
    butt_led_off($BUTT_TUNE_HEXANY)
    butt_led_off($BUTT_TUNE_BOHLEN_A12)
    butt_led_off($BUTT_TUNE_BOHLEN_HARM)
    butt_led_off($BUTT_TUNE_METASLENDRO)
    butt_led_on($BUTT_TUNE_WTP, $LED_GREEN_FULL)
    butt_led_off($BUTT_TUNE_7)
    butt_led_off($BUTT_TUNE_8)
  endif
endop

opcode all_buttons_off, 0,0
  butt_led_off($BUTT_1U)
  butt_led_off($BUTT_2U)
  butt_led_off($BUTT_3U)
  butt_led_off($BUTT_4U)
  butt_led_off($BUTT_5U)
  butt_led_off($BUTT_6U)
  butt_led_off($BUTT_7U)
  butt_led_off($BUTT_8U)
  butt_led_off($BUTT_1L)
  butt_led_off($BUTT_2L)
  butt_led_off($BUTT_3L)
  butt_led_off($BUTT_4L)
  butt_led_off($BUTT_5L)
  butt_led_off($BUTT_6L)
  butt_led_off($BUTT_7L)
  butt_led_off($BUTT_8L)
endop

;;-------------
;; instruments
;;-------------

; MIDI setup for keyboard input...
massign 1, "Starter"
maxalloc "Starter", 2

; ...and buttons/pads
massign $BUTT_CHAN, "Buttons"

; set stuff up and start polling MIDI controllers
instr Init
  ; scanning synthesis initialization
  ; values from Tarmo's presets
  iinit = gip1
  irate = (gip2 == 0) ? 0.01 : gip2 ; do not allow 0!
  ifnvel = 60
  ifnmass = gip3
  ifnstif = 30
  ifncentr = gip4
  ifndamp = 50
  kmass = 1
  kstif = 0.1
  kcentr = 0.1
  kdamp = -0.001
  ileft = 0.1
  iright = 0.5
  kpos = 0
  kstrngth = 0
  idisp = 0
  itraj = gip5
  ain = 0

  ; set up two identical instances with different IDs
  ; they will be used as a detuned pair
  scanu(iinit, irate, ifnvel, ifnmass, ifnstif, ifncentr, ifndamp, kmass,
        kstif, kcentr, kdamp, ileft, iright, kpos, kstrngth, ain, idisp,
        $SCAN_ID)
  scanu(iinit, irate, ifnvel, ifnmass, ifnstif, ifncentr, ifndamp, kmass,
        kstif, kcentr, kdamp, ileft, iright, kpos, kstrngth, ain, idisp,
        $SCAN_ID+1)
  scanu(iinit, irate, ifnvel, ifnmass, ifnstif, ifncentr, ifndamp, kmass,
        kstif, kcentr, kdamp, ileft, iright, kpos, kstrngth, ain, idisp,
        $SCAN_ID+2)

  ; initialize button LEDs
  all_buttons_off
  set_generated_waveform(gi_sine)
  set_reduction_type($REDUCE_NONE)
  set_tuning(gi_tuning)

  turnoff
endin

instr Listener
  ; poll MIDI controllers
  read_controls

  ; printks("[ gi_left_on:%d gi_left_freq:%f gi_right_freq:%f ]\n", 2,
  ;         gi_left_on, gi_left_freq, gi_right_freq)
endin

; process MIDI notes
; only two instances allowed
instr Starter
  ; get note number, map to pitch
  inote_num = notnum()
  ifreq = gi_pitchmap[inote_num]
  if (ifreq == 0) then
    prints("Skipping note 0 (%d)\n", inote_num)
    goto DONE
  endif

  ; fractional instrument number embeds the note number
  instnum  = 23 + (inote_num * 0.001)

  iamp = ampmidi(0dbfs * 0.5)

  ; determine which "side" this is
  ileft = gi_left_on == 0 ? 1 : 0
  if (ileft == 1) then
    gi_left_freq = ifreq
    gi_left_note = inote_num
    gi_left_on = 1
  else
    gi_right_freq = ifreq
    gi_right_note = inote_num
  endif

  prints("Starting %d:%f (left:%d) %f Hz\n", inote_num, instnum, ileft, ifreq)
  event_i("i", instnum, 0, -1, ifreq, iamp)

  ; if we have two frequencies to work with, build the derived tones/chords
  if (gi_left_freq != 0 && gi_right_freq != 0) then
    imin, imax get_minmax gi_left_note, gi_right_note
    start_if_off(24, iamp, gi_left_freq, gi_right_freq, imin, imax)
    start_if_off(25, iamp, gi_left_freq, gi_right_freq, imin, imax)
    start_if_off(26, iamp, gi_left_freq, gi_right_freq, imin, imax)
  endif
  prints("\n");

  krel = release()
  if (krel == 1) then
    printks("Goodbye %d:%f\n", 1, inote_num, ifreq)
    event("i", "Stopper", 0, 0.1, instnum, ileft)
  endif

  DONE:
endin

; turn off a note and all derived tones
instr Stopper
  instnum = p4
  ileft = p5

  prints("Stopping %f (%d)\n", instnum, ileft)
  turnoff2(instnum, 4, 1)

  stop_if_on(24)
  stop_if_on(25)
  stop_if_on(26)

  if (ileft == 1) then
    gi_left_freq = 0
    gi_left_note = 0
    gi_left_on = 0
  else
    gi_right_freq = 0
    gi_right_note = 0
  endif

  turnoff
endin

; binaural scanned synth (main voice)
instr 23
  kcps = p4
  iamp = (p5 * 0.7) / 3

  aenv = linsegr(0,
                 2, 1,
                 1, 0)

  ; determine amount of detuning based on percentage of frequency
  kdiff = kcps * (scale($CTL_MAIN_DETUNE, 0.001, 0.0001) / 2)

  a1 = scans(iamp, kcps + kdiff, gip5, $SCAN_ID)
  a2 = scans(iamp, kcps - kdiff, gip5, $SCAN_ID+1)
  a3 = scans(iamp, kcps,         gip5, $SCAN_ID+2)

  aout = (a1 + a2 + a3) * aenv
  ga_main_out = ga_main_out + aout
endin

; Combination Engine driver
instr 24
  aenv = linsegr(0,
                 2, 1,
                 0.5, 0)
  a1 = combination_engine(gk_generated_wave, p4, p5, p6, p7, p8)
  aout = a1 * aenv * $CTL_COMBOS_LEVEL
  ga_combos_out = ga_combos_out + aout
endin

; Pythagorean & Golden Means driver
instr 25
  aenv = linsegr(0,
                 2, 1,
                 0.5, 0)
  a1 = means_engine(gk_generated_wave, p4, p5, p6, p7, p8)
  aout = a1 * aenv * $CTL_MEANS_LEVEL
  ga_means_out = ga_means_out + aout
endin

; RingMod driver
instr 26
  ileft_freq = p5
  iright_freq = p6

  if (ileft_freq < iright_freq) then
    iin = ileft_freq
    icarr = iright_freq
  else
    iin = iright_freq
    icarr = ileft_freq
  endif

  iamp = p4
  aenv = linsegr(0,
                 2, 1,
                 0.5, 0)

  ain = oscili(iamp, iin,  gi_sine)
  acarr = oscili(iamp, icarr,  gi_sine)
  a1 = ringmod(ain, acarr) * 1.5

  aout = a1 * aenv * $CTL_RINGMOD_LEVEL
  ga_ringmod_out = ga_ringmod_out + aout
endin

; respond to buttons sending low-numbered notes
; use to switch waveforms (tables)
instr Buttons
  ibutt = notnum()
  prints("Buttons: %d\n", ibutt)

  ; waveform for generated tones
  if (ibutt == $BUTT_GENERATED_SIN) then
    set_generated_waveform(gi_sine)
  elseif (ibutt == $BUTT_GENERATED_FIB) then
    set_generated_waveform(gi_fib)
  elseif (ibutt == $BUTT_GENERATED_PRI) then
    set_generated_waveform(gi_prime)
  elseif (ibutt == $BUTT_GENERATED_ASY) then
    set_generated_waveform(gi_asymp)
  ; reduction type
  elseif (ibutt == $BUTT_REDUCE_NONE) then
    set_reduction_type($REDUCE_NONE)
  elseif (ibutt == $BUTT_REDUCE_FIXED) then
    set_reduction_type($REDUCE_FIXED)
  elseif (ibutt == $BUTT_REDUCE_LOWER) then
    set_reduction_type($REDUCE_LOWER)
  elseif (ibutt == $BUTT_REDUCE_UPPER) then
    set_reduction_type($REDUCE_UPPER)
  ; tuning
  elseif (ibutt == $BUTT_TUNE_CENTAUR) then
    set_tuning(giCent)
  elseif (ibutt == $BUTT_TUNE_HEXANY) then
    set_tuning(giHex)
  elseif (ibutt == $BUTT_TUNE_BOHLEN_A12) then
    set_tuning(giA12)
  elseif (ibutt == $BUTT_TUNE_BOHLEN_HARM) then
    set_tuning(giBph)
  elseif (ibutt == $BUTT_TUNE_METASLENDRO) then
    set_tuning(giMeta)
  elseif (ibutt == $BUTT_TUNE_WTP) then
    set_tuning(giWTP)
  else
    prints("Button %d ignored\n", ibutt)
  endif
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

; Tarmo's tables for scanned synthesis
#include "inc/scanu_tables.sco"

#define PLAY_FOR      #0#
#define A_SHORT_TIME  #1#
#define A_LONG_TIME   #[3600*24]#

i "Init"      $PLAY_FOR $A_SHORT_TIME
i "Listener"  $PLAY_FOR $A_LONG_TIME
i "Output"    $PLAY_FOR $A_LONG_TIME
e

</CsScore>
</CsoundSynthesizer>
