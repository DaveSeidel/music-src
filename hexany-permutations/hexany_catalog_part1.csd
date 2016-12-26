<CsoundSynthesizer>

;; Disquiet Junto 0226
;; The 1-3-5-7 Hexany Chord Catalog (The 35 three-note chords possible in one octave)
;; Dave Seidel 2016-04-30 (thanks and apologies to Tom Johnson)

;; scanned synthesis instrument and supporting data adapted from the Scanned Synthesis
;; Sandbox program by Tarmo Johannes (included as an example with CsoundQt 0.9.2.1).

<CsOptions>
</CsOptions>

<CsInstruments>
#include "hexany_catalog.orc"
</CsInstruments>

<CsScore bin="python hexany_catalog_part1.py">
</CsScore>

</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
