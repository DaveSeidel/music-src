INVOLUTION:

// time / rhythmn
 - Clk (Out) g> Tempi (Tempo)

 - Maths (Out 2) g> LOL (O In)
 - LOL (O Out) g> Tempi (Mod)
 - LOL (M Out) g> Rene (X Mod)
 - LOL (G Out) g> Rene (Y Mod)

 - Tempi (Ch1) c>  Mimeophon (Tempo)
 - Tempi (Ch2) c> Rene (X Clk)
 - Tempi (Ch2) g> Maths (In 1)

 - Rene (X Gate) g> ADSR 1 (Gate)
 - ADSR 1 (Out) >> uTune (Gate 1)

 - Tempi (Ch3) c> Rene (Y Clk)
 - Tempi (Ch3) g> Maths (In 4)

 - Rene (Y Gate) g> ADSR 2 (Gate)
 - ADSR 2 (out) >> uTune (Gate 2)

 - Tempi (Ch6) c> Rene (Z Mod)

// pitch sources
 - Rene (X CV) p> uTune (CV 1)
 - Rene (Y CV) p> uTune (CV 2)
 - uTune (CV Out 1) p> CV Bus (I 3)
 - uTune (CV Out 2) p> CV Bus (I 4)

// pitch destinations
 - CV Bus (O 3) p> Switch (In 3)
 - CV Bus (O 3) p> DPO A (1V/Oct)
 - CV Bus (O 3) p> Disting (X)
 - Disting (B) p> Loquelic Iteritas (Pitch A)

 - CV Bus (O 4) p> Switch (In 4)
 - CV Bus (O 4) p> DPO B (1V/Oct)
 - CV Bus (O 4) p> Disting (Y)
 - Disting (A) p> Loquelic Iteritas (Pitch B)

 - Switch (Out) p> Mimeophon (uRate)

// audio source 1
 - DPO A (Sine) -> XPan (1A)
 - DPO A (Triangle) -> XPan (1B)
 - DPO A (Saw) -> XPan (2 Pan)

// audio source 2
 - DPO B (Sine) -> XPan (2A)
 - DPO B (Square) -> XPan (2B)
 - DPO B (Final) -> XPan (1 Pan)

// audio source 3
 - Loquelic Iteritas (Out) -> modDemix (In 1)
 - modDemix (Out 1) -> XPan (Aux-L)
 - modDemix (Out 2) -> XPan (Aux-R)

// consolidated audio (left)
 - XPan (L Out) -> QPAS (In L)
 - QPAS (LP L) -> Optomix (In 1)
 - Optomix (Out 1) -> Mimeophon (In L)
 - Mimeophon (Out L) -> Audio Output Bus (L)

// consolidated audio (right)
 - XPan (R Out) -> QPAS (In R)
 - QPAS (LP R) -> Optomix (In 2)
 - Optomix (Out 2) -> Mimeophon (In R)
 - Mimeophon (Out R) -> Audio Output Bus (R)

// Gate/envelope for left channel
 - Maths (Unity Out 1) >> Optomix (Ctrl 1)
 - Maths (Unity Out 1) >> modDemix (Carrier 1)

// Gate/envelope for right channel
 - Maths (Unity Out 4) >> Optomix (Ctrl 2)
 - Maths (Unity Out 4) >> modDemix (Carrier 2)

// Modulation
 - Pons Asinorum (Out 1) >> CV Bus (I 1)
 - Pons Asinorum (Out 2) >> CV Bus (I 2)
 - Pons Asinorum (Out 3) >> Mimeophon (Halo)
 - Pons Asinorum (Out 4) >> Mimeophon (Color)

 - CV Bus (O 1) >> Loquelic Iteritas (Morph)
 - CV Bus (O 1) >> DPO B (Shape)
 - CV Bus (O 1) >> XPan (1 X-Fade)
 - CV Bus (O 1) >> QPAS (Radiate-L)

 - CV Bus (O 2) >> Loquelic Iteritas (Modulate)
 - CV Bus (O 2) >> DPO B (Fold)
 - CV Bus (O 2) >> XPan (2 X-Fade)
 - CV Bus (O 2) >> QPAS (Radiate-R)

// Pons Asinorum control
 - Maths (Out 3) >> Pons Asinorum (CV 1)
 - Maths (Out 3) >> Pons Asinorum (CV 2)
 - Maths (Out 3) >> Pons Asinorum (CV 3)
 - Maths (Out 3) >> Pons Asinorum (CV 4)

 - Wogglebug (Stepped) >> Wogglebug (Speed)
 - Wogglebug (Stepped) >> Mimeophon (Rate)
 - Wogglebug (Woggle) >> Loquelic Iteritas (Damp)
 - Wogglebug (Smooth) >> Disting (Z)
 - Wogglebug (Burst) g> Switch (Sel)

 // Module settings

  * Wogglebug:
  | Speed/Chaos: 8:30
  | Speed/Chaos CV Attenuator: 9:00

  * Clk:
  | Rate = min

  * Tempi:
  | Run/Stop All = Enabled
  | Run/Stop Toggle = Enabled
  | State = 1
  | Ch 1 = ×5
  | Ch 2 = ÷5
  | Ch 3 = ÷7
  | Ch 4 = ÷11
  | Ch 5 = ÷29
  | Ch 6 = ÷31

  * uTune:
  | Scale = Meta-Slendro

  * Rene:
  | X Quant = MOS-5 or MOS-7 per state
  | X Quant Range = 4 8ves
  | Y Quant = MOS-5 or MOS-7 per state
  | Y Quant Range = 3 8ves
  | X FUN.MOD.RESET = On
  | Y FUN.MOD.RESET = On
  | State 1 = X:MOS-7 + Y:MOS-7
  | State 2 = X:MOS-7 + Y:MOS-5
  | State 3 = X:MOS-5 + Y:MOS-5

  * ADSR 1:
  | A = 0%
  | D = 0%
  | S = 100%
  | R = ~75%

  * ADSR 2:
  | A = 0%
  | D = 0%
  | S = 100%
  | R = ~75%

  * Mimeophon:
  | Zone = 1
  | Repeats = 65%
  | Rate = 12:00
  | Mix = 30%
  | Skew = On

  * modDemix:
  | Strength 1 = 100%
  | Strength 2 = 100%

  * Optomix:
  | Damp 1 = 50%
  | Damp 2 = 50%
  | Ctrl 1 = 100%
  | Ctrl 2 = 100%

  * Maths:
  | Cycling = Off
  | Rise 1 = 60%
  | Fall 1 = 60%
  | Vari-Response 1 = Lin/Log
  | Rise 2 = 70%
  | Fall 2 = 70%
  | Vari-Response 2 = Lin/Log
  | Ch 1 Attenuverter = 100%
  | Ch 2 Attenuverter = 60%
  | Ch 3 Attenuverter = 55%
  | Ch 4 Attenuverter = 100%

  * Pons Asinorum:
  | Mode = LFO
  | Response = Long
  | LFO 1 = Max
  | LFO 2 = Max
  | LFO 3 = Max
  | LFO 4 = Max

  * QPAS:
  | Freq = 40-60%
  | Q = 30-40%
  | Radiate-L = 15%
  | Radiate-L Attenuverter = +10%
  | Radiate-R = 15%
  | Radiate-R Attenuverter = +10%

  * XPan:
  | 1 X-Fade = 10:30
  | 1 Pan = 10:00
  | 2 X-Fade = 10:30
  | 2 Pan = 10:00
  | Aux Level = 30%

  * Loquelic Iteritas:
  | Algo = VO

  * Disting:
  | Algo = A-1
