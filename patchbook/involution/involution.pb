INVOLUTION:

// time / rhythmn
 - Wogglebug (Int Clk) c> Tempi (Tempo)
 - Wogglebug (Ch 1) c>  Mimeophon (Tempo)

 - Tempi (Ch 2) c> Rene (X Clk)
 - Tempi (Ch 3) c> Rene (Y Clk)
 - Tempi (Ch 4) c> Switch (Sel)

// pitch sources
 - Rene (X CV) p> uTune (CV In 1)
 - Rene (Y CV) p> uTune (CV In 2)
 - uTune (CV Out 1) p> CV Bus (I 3)
 - uTune (CV Out 2) p> CV Bus (I 4)

// pitch destinations
 - CV Bus (O 3) p> Switch (In 3)
 - CV Bus (O 4) p> Switch (In 4)

 - CV Bus (O 3) p> DPO A (1v/oct)
 - CV Bus (O 4) p> DPO B (1v/oct)

 - CV Bus (O 3) p> QPAS (Radiate L)
 - CV Bus (O 4) p> QPAS (Radiate R)

 - CV Bus (O 3) p> Loquelic Iteritas (Pitch A)
 - CV Bus (O 4) p> Loquelic Iteritas (Pitch B)
 - Switch (Out) p> Mimeophon (uRate)

// audio source 1
 - DPO A (Saw) -> Disting (X)
 - Disting (A) -> XPan (1A)

// audio source 2
 - DPO B (Final) -> XPan (1B)

// audio source 3
 - DPO A (Triangle) -> modDemix (Signal 1 In)
 - DPO A (Sine) -> modDemix (Carrier 1 In)
 - modDemix (Signal 1 Out) -> XPan (2A)

// audio source 4
 - DPO B (Square) -> modDemix (Signal 2 In)
 - DPO B (Sine) -> modDemix (Carrier 2 In)
 - modDemix (Signal 2 Out) -> XPan (2B)

// audio source 5
 - Loquelic Iteritas (Out) -> XPan (Aux L)

// consolidated audio (left)
 - XPan (L Out) -> Optomix (In 1)
 - Optomix (Out 1) -> QPAS (In L)
 - QPAS (LP L) -> Mimeophon (In L)
 - Mimeophon (Out L) -> Audio Bus (L)

// consolidated audio (right)
 - XPan (R Out) -> Optomix (In 2)
 - Optomix (Out 2) -> QPAS (In R)
 - QPAS (LP R) -> Mimeophon (In R)
 - Mimeophon (Out R) -> Audio Bus (R)

// Gate for left channel
 - Rene (X G) g> Maths (In 1)
 - Maths (Out 1) g> Optomix (Ctrl 1)

// Gate for right channel
 - Rene (Y G) g> Maths (In 4)
 - Maths (Out 4) g> Optomix (Ctrl 2)

// Gate for Mimeophon effects
 - Rene (C G) g> Mimeophon (Hold)

// Modulation
 - uLOAF (Tri 1) >> CV Bus (I 1)
 - uLOAF (Tri 2) >> CV Bus (I 2)
 - uLOAF (Tri Inv) >> Maths (In 3)

 - Maths (Out 3) >> Disting (Z)
 - Maths (Out 3) >> Mimeophon (Rate)

 - CV Bus (O 1) >> DPO B (Shape)
 - CV Bus (O 2) >> DPO B (Fold)

 - CV Bus (O 1) >> XPan (A Pan)
 - CV Bus (O 2) >> XPan (B Pan)

 - CV Bus (O 1) >> Disting (Y)
 - CV Bus (O 2) >> Mimeophon (Halo)

 - CV Bus (O 1) >> Loquelic Iteritas (Modulate)
 - CV Bus (O 2) >> Loquelic Iteritas (Morph)

 - Maths (Unity Out 1) >> XPan (Aux Level)
 - Maths (Unity Out 4) >> Mimeophon (Color)

 // Module settings

  * Tempi:
  | State = 1
  | Ch 1 = ×3
  | Ch 2 = ÷5
  | Ch 3 = ÷7
  | Ch 4 = ÷11
  | Ch 5 = ÷29
  | Ch 6 = ÷31

  * uTune:
  | Scale = meta-slendro

  * Rene:
  | X Quant = MOS-5 or MOS-7
  | X Quant Range = 3 8ves
  | Y Quant = MOS-5 or MOS-7
  | Y Quant Range = 2 8ves
  | State 1 = X:7 + Y:7
  | State 2 = X:7 + Y:5
  | State 3 = X:5 + Y:5

  * Disting:
  | Algo = D-3

  * Mimeophon:
  | Zone = 6
  | Repeats = 40%
  | Rate = 75%
  | Mix = 50%

  * modDemix:
  | Strength 1 = 75+%
  | Strength 2 = 75+%

  * Optomix:
  | All CV knobs = 0%

  * Maths:
  | Cycling = Off
  | Rise 1 = 100%
  | Fall 1 = 100%
  | Vari-Response 1 = Lin
  | Rise 2 = 100%
  | Fall 2 = 100%
  | Vari-Response 2 = Lin
  | Ch 1 Attenuverter = 100%
  | Ch 3 Attenuverter = 60%
  | Ch 4 Attenuverter = 100%

  * uLOAF:
  | Freq 1 = 0%
  | Skew 1 = 50%
  | Speed 1 = S
  | Freq 2 = 0%
  | Skew 2 = 50%
  | Speed 2 = S

  * QPAS:
  | Freq = 40-60%
  | Q = 40%
  | Radiate-L = 30%
  | Radiate-L Attenuverter = +5%
  | Radiate-R = 30%
  | Radiate-R Attenuverter = +5%

  * XPan:
  | X-Fade A = 10:30
  | Pan A = 10:00
  | X-Fade B = 10:30
  | Pan B = 10:00
  | Aux Level = 30%

  * Loquelic Iteritas:
  | Algo = VO
