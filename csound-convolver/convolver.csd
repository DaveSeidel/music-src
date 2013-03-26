;
; Convolver tool, applies an IR file to a sound file.
; Assumes 96K 24-bit input and output files.
;
; The IR file should 96K or an even divisor of 96K (e.g., 48K).
;
; This is intended to be driven by the "convolve" shell script,
; and should reside in the same directory.
;
; by Dave Seidel, 2013
;

<CsoundSynthesizer>

<CsInstruments>
sr      = 96000
ksmps   = 1
nchnls  = 2
0dbfs   = 1


; Borrowed from the Blue Share repository and adapted for use in this context.
; The original comment states:
;  "Convolution Effect using pconvolve opcode by Matt Ingalls."
;  "The code for this effect is based on code by Matt Ingalls found in the Csound Manual;"
;  "please see the manual for more information regarding pconvolve."
opcode convolver, aa, aai

  ; get input
  ain1,ain2,iwet xin

  ; dry vs. wet  
  idry = 1 - iwet

  ; size of each convolution partion
  ipartsize = 1024

  ; calculate latency of pconvolve opcode
  idel = (ksmps < ipartsize ? ipartsize + ksmps : ipartsize)/sr

  prints "Convolving with a latency of %f seconds%n", idel

  awetl, awetr pconvolve iwet*(ain1+ain2), "$IRFILE", ipartsize

  ; Delay dry signal, to align it with the convolved sig
  adryl delay idry * ain1, idel
  adryr delay idry * ain2, idel

  ; mix
  aout1 = adryl+awetl
  aout2 = adryr+awetr
  
  ; send output
  xout aout1,aout2

endop


instr 1
  
  Soutfile getcfg 3
  prints "%n==========%ninput file: $INFILE%ngain adjustment: $GAIN%nimpulse response file: $IRFILE%noutput file: "
  prints Soutfile
  prints "%n==========%n%n"

  ; get length of file, use to set duration
  ilen filelen "$INFILE"
  p3 = ilen

  ; read it in
  aL, aR diskin2 "$INFILE", 1, 0, 0, 0, 8
  
  ; convolve it
  aLc, aRc convolver aL*$GAIN, aR*$GAIN, 1

  ; write it out
  outs aLc, aRc

endin

</CsInstruments>
<CsScore>

i1 0 1
e

</CsScore>

</CsoundSynthesizer>
