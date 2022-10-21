ELEGY:

  // Harmonium
  - SWN (out l/r) -> Prism (in l/r)
  - Prism (out l) -> Mixer (ch 1)
  - Prism (out r) -> Mixer (ch 2)
 
  - Sloths (apathy:z) >> SWN (browse)
  - Sloths (apathy:+) >> SWN (dispersion)
  - Sloths (apathy:y) >> SWN (longitude)
  
  - Skew Fade LFO (out) >> Prism (comb)
  - Skew Fade LFO 666 (out) >> Prism (cutoff)
 
  // Obligato
  - Scanned (out) -> LPG (audio in)
  - LPG (out) -> Electus Versio (in l)
  - Electus Versio (out l/r) -> Mixer (ch 7)
  - ADSR (out) >> LPG (cv in)
  
  - VC Octave Switch (out 1) p> Scanned (1v/oct)
  - Rene (y:g) g> Scanned (excite)
  - Sloths (topor:x) >> Scanned (strength)
  - Diode Chaos (x) >> Scanned (shape)
  - Diode Chaos (y) >> Electus Versio (tone) 
  - Diode Chaos (z) >> Scanned (center)
  - Sloths (apathy:x) >> VC Octave Switch (qua 1)
  - uTune (2:cv out) p> VC Octave Switch (cv 1)
  - Wogglebug (smooth) >> Wogglebug (speed)
  
  // Bass
  - DPO (2:final) -> Optomix (1:in)
  - DPO (1:saw) -> Optomix (2:in)
  - uTune (1:cv out) p> DPO (1:1v/oct)
  - uTune (1:cv out) p> DPO (2:1v/oct)
  - uTune (1:cv out) p> Mimeophon (u)
  - Optomix (out 1) -> QPAS (in l)
  - Optomix (out 2) -> QPAS (in r)
  - QPAS (out l) -> Mimeophon (in l)
  - QPAS (out r) -> Mimeophon (in r)
  - Mimeophon (out l/r) -> Mixer (ch 8)
  - Ochd (3) >> DPO (angle)
  - Ochd (4) >> QPAS (radiate l)
  - Ochd (5) >> QPAS (radiate r)
  - Ochd (6) >> DPO (shape)
  - Ochd (7) >> DPO (fold)
  - Rene (x:g) g> Maths (4:trigger)
  - Maths (2:unity) >> Optomix (1:ctrl)
  - Maths (2:unity) >> Optomix (2:ctrl)
  - Tempi (2) t> Rene (x:clk)
  - Tempi (1) t> Rene (y:clk)
  - Tempi (4) t> Rene (y-mod)
  - Wogglebug (stepped) >> Rene (y:cv in)
  - Rene (x:cv out) p> uTune (1:cv in)
  - Rene (y:cv out) p> uTune (2:cv in)
  
  // Mixer control
  - Morphing LFO (1:out) >> Mixer (ch 1:pan)
  - Morphing LFO (2:out) >> Mixer (ch 2:pan)
 
  // Tuning
  - Maths (3:out) p> uTune (a:cv in)
  - uTune (a:cv out) p> Mult (3)
  