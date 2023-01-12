# Risset Harmonic Oscillator for VCV Rack

I took the [Risset Harmonic Oscillator](https://github.com/DaveSeidel/music-src/tree/master/Nebulae/instr/Risset_Harmonic_Oscillator) instrument I designed for the Nebulae nodule and ported it to work in the context of DocB's great Csound module for VCV Rack, aka [dbCsound](https://github.com/docb/dbRackCsound). This is a great way to prototype Csound code. **NB: this requires v2.0.5 of dbCsound, which has not yet been released in binary form (but is available as source.)** This version of the instrument has slightly different features compared to the Nebulae version.

The instrument generates audio output using Risset's harmonic arpeggio technique. The controls are mapped as follows:

 * P1: *spread*, i.e., the distance between the individual tones that are combined to make the output
 * P2: *waveform*, morphs through a series of waveforms: triangle, saw, square, prime, and fibonacci (the last two are my design)
 * P3: *distortion*, using tanh distortion via the distort1 opcode
 * P4: *tremolo pan*, which is effect I came up with that applies two separate LFOs to the left/right outputs; this control sets the LFO speed

The control inputs IN1-4 apply to these controls. **They expect a 0-10 (unipolar) input voltage.**

Thanks to docB for the Csound module, and Dave Phillips for adding the output envelope.
