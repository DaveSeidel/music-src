INVOLUTION:

 - Clk (Out) c> Tempi (Tempo) 

 - Tempi (Ch5) c> Rene (X Clk)
 - Tempi (Ch5) t> Maths (Trigger 1)
 - Tempi (Ch6) c> Rene (Y Clk)
 - Tempi (Ch6) t> Maths (Trigger 4)
 - Tempi (Ch3) c> Rnd (Clk)

 - Maths (Out 1) >> CV Bus 1 (In)
 - Maths (Out 4) >> CV Bus 2 (In)
 - Maths (Out 2) g> LOL (O In)
 - Maths (Out 3) g> LOL (G In)

 - LOL (O Out) g> Tempi (Mod)
 - LOL (O Out) g> Rene (X Mod)
 - LOL (O Out) g> Rene (Y Mod)

// tuning only
 - LOL (M Out) g> Tuning (Gate)
 - LOL (G Out) g> Tuning (Pitch)

// pitch sources
 - Rene (X CV Out) p> uTune (CV 1)
 - Rene (Y CV Out) p> uTune (CV 2)
 - uTune (CV Out 1) p> CV Bus 3 (In)
 - uTune (CV Out 2) p> CV Bus 4 (In)

// pitch destinations
 - CV Bus 3 (Out) p> Switch (In 1)
 - CV Bus 3 (Out) p> DPO A (1V/Oct)
 - CV Bus 3 (Out) p> Dual Oscillator 258t A (Iv/Oct)

 - CV Bus 4 (Out) p> Switch (In 4)
 - CV Bus 4 (Out) p> DPO B (1V/Oct)
 - CV Bus 4 (Out) p> Dual Oscillator 258t B (Iv/Oct)

 - Switch (Out) p> Mimeophon (uRate)

// audio source 1
 - DPO A (Sine) -> XPan (Pan 1)
 - DPO A (Triangle) -> XPan (X-Fade 2)
 - DPO A (Saw) -> QPas (R-In)
 - QPas (LP L) -> Optomix (In 1)
 - Optomix (Out 1) -> XPan (In 1 R)

// audio source 2
 - DPO B (Sine) -> XPan (Pan 2)
 - DPO B (Square) -> XPan (X-Fade 2)
 - DPO B (Final) -> QPas (L-In)
 - QPas (LP R) -> Optomix (In 2)
 - Optomix (Out 2) -> XPan (In 2 R)

// audio source 3
 - Dual Oscillator 258t A (Out 1) -> modDemix (In 1)
 - Dual Oscillator 258t A (Out 2) -> modDemix (Carrier 2)
 - modDemix (Out 1) -> DPLPG (In 1)
 - DPLPG (Out 1) -> XPan (Aux L)

// audio source 4
 - Dual Oscillator 258t B (Out 1) -> modDemix (In 2)
 - Dual Oscillator 258t B (Out 2) -> modDemix (Carrier 1)
 - modDemix (Out 2) -> DPLPG (In 2)
 - DPLPG (Out 2) -> XPan (Aux-R)

// consolidated audio (left)
 - XPan (L Out) -> Mimeophon (In L)
 - Mimeophon (Out L) -> Audio Output Bus (L)

// consolidated audio (right)
 - XPan (R Out) -> Mimeophon (In R)
 - Mimeophon (Out R) -> Audio Output Bus (R)

// Gate/envelope for left channel
 - CV Bus 1 (Out) >> uTune (Gate In 1)
 - CV Bus 1 (Out) >> SynthBT Gate Comb (In 1)
 - CV Bus 2 (Out) >> Optomix (Ctrl 1)
 - CV Bus 1 (Out) >> DPLPG (CV 1)

// Gate/envelope for right channel
 - CV Bus 2 (Out) >> uTune (Gate In 2)
 - CV Bus 2 (Out) >> SynthBT Gate Comb (In 2)
 - CV Bus 1 (Out) >> Optomix (Ctrl 2)
 - CV Bus 2 (Out) >> DPLPG (CV 2)

 - SynthBT Gate Comb (Out) >> QPas (Mix)
 - SynthBT Gate Comb (Out) >> XPan (Aux Level)

// Modulation
 - Ochd (2) >> Dual Oscillator 258t B (Waveform)
 - Ochd (3) >> Dual Oscillator 258t A (Waveform)
 - Ochd (4) >> DPO B (Shape)
 - Ochd (4) >> Mimeophon (Color)
 - Ochd (5) >> DPO B (Angle)
 - Ochd (6) >> QPas (Radiate-R)
 - Ochd (7) >> Qpas (Radiate-L)
 
 - Wogglebug (Stepped) >> Wogglebug (Speed)
 - Wogglebug (Int Clock) g> Switch (Sel)

 - Rnd (Quant) >> Rene (X CV In)
 - Rnd (Quant) >> Rene (Y CV In)

 // Module settings

  * Wogglebug:
  | Speed/Chaos: 8:30
  | Speed/Chaos CV Attenuator: 9:00

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
  | Scale = Centaur

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
  | Damp 1 = 0%
  | Damp 2 = 0%
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

  * QPAS:
  | Freq = 40-60%
  | Q = 30-40%
  | Radiate-L = 15%
  | Radiate-L Attenuverter = +10%
  | Radiate-R = 15%
  | Radiate-R Attenuverter = +10%

  * XPan:
  | 1 X-Fade = 100%
  | 1 Pan = 100%
  | 2 X-Fade = 100%
  | 2 Pan = 100%
  | Aux Level = 30-40%
