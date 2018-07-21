# Implication Organ

This is a realtime microtonal Csound instrument with MIDI keyboard and controller input. I designed it to my specific requirements as a composer based on several specific constraints. It is not intended to be a general-purpose instrument.

The Implication Organ (or IO) is duophonic, in that the performer can play no more than two notes at a time. "Implication" refers to the instrument's generation of chords built from pitches that are mathematically derived, or implied, from the two pitches currently being played. See below under "Features" for more on how this works.

For an example of the IO in use, see https://www.youtube.com/watch?v=hmFTd8E61Ts.

## Philosophy

I designed the IO as a vehicle for exploring intervals in rational tunings, and the chords that might be generated from those intervals based on mathematical procedures rather than the rules of harmony. It is specialized to favor the production of long tones or drones. Its use of relatively slow attack and decay envelopes encourages the performer to work slowly and patiently, and to take time to listen.

## Requirements

- Csound 6.09 or later (earlier 6.x releases may work, but have not been tested)
- Two MIDI input devices:
 - Keyboard (I use a QuNexus, but any generic MIDI keyboard should do)
 - Launch Control XL (similar controllers might be used, but this would require some new coding and possibly some more extensive redesign). Technically this is also an output device, because there's code to set the LED colors for the buttons. The Launch Control XL must be configured using the file included in the sysex directory so that channels and controller numbers will be set up as expected.

The IO was designed for a Raspberry Pi 3 with a Pisound sound card, but could easily be run on more powerful systems. The code makes no use of features specific to either the Raspberry Pi or the Pisound, but has been optimized to work well in that environment.

Likewise, although I wrote this on Linux-based systems, and provide Linux-specific scripts for running it, nothing in the code should prevent it from running on a MacOS or Windows platform.

## Features
- Two main voices, each built from three instances of the Csound `scanu`/`scans` opcodes (scanned synthesis). The three sound sources for each voice consist of one exact pitch and two detuned pitches, one slightly sharp and one slightly flat. The main pitches are played on the MIDI keyboard; these are the only notes played by the performer.
- Eleven generated voices derived from the currently-playing pair of main pitches, as follows:
 - Combination tones:
   - first, second, and third-order difference tones
   - first and second-order summation tones
   - product
 - Pythagorean and other means:
   - arithmetic mean
   - geometric mean
   - harmonic mean
   - golden mean
   - Ring modulator (where one of the main pitches is used as the input, and the other is used as the carrier)
 - Generated voices (except the ring modulator) are expressed using one of three different waveforms:
   - sine wave
   - composite waveform based on harmonics in the Fibonacci series
   - composite waveform based on harmonics in the prime number series
- Selectable microtonal tunings, which can be changed on the fly:
  - A dual hexany scale, built by combining two interleaved 1-3-5-7 hexanies, with one transposed upward by 16/15 (i.e., a major 5-limit half-step). On a conventional keyboard, this maps one hexany to the fingering of the whole tone scale beginning on C, and the other hexany to the fingering of the whole tone scale beginning on C#. See the file dual-interleaved-hexany.scl in this repo.
  - Kraig Grady's [Centaur](http://www.anaphoria.com/centaur.html) tuning.
  - [Meta-Slendro](http://www.anaphoria.com/wilsonintroMERU.html) by Erv Wilson (by way of Kraig Grady); I am using the Meru #3 variant.
  - La Monte Young's Well Tuned Piano tuning.
  - Heinz Bohlen's A12 and JI Harmonic tunings (from the [Scala](http://www.huygens-fokker.org/scala/) archives).
- MIDI control over a number of parameters (based on the Launch Control XL):
  - Sliders (left to right)
   - master level for main voices
   - master level for all generated voices
   - level for all combination tones
   - level for all mean tones
   - level for ring modulator
  - Knobs
   - individual level for each combination tone (top row)
   - individual level for each mean tone (middle row)
   - detuning amount for main voices (bottom row)
  - Buttons
   - waveform selection for generated voices, except ring modulator (top row, left)
   - range/transposition selection for generated tones (top row, right)
   - tuning selection (bottom row)
- Outputs:
   - Main voices on channel 1
   - Generated voices on channel 2

## TODO

Things that I may or may not do:
- Add file list to README
- Add filter controls for main voice
- Add alternate instrument definitions for the main voice
- Add additional waveform options for the generated voices

## Acknowledgements and Thanks

The IO incorporates work from several people. Thanks to:
- Steven Yi, for his implementation of Julian Parker's ring modulator design, which is based on an diode-based analog design. For more information, including a link to Parker's paper, see [Steven's article](http://kunstmusik.com/2013/09/07/julian-parker-ring-modulator/).
- Tarmo Johannes, for his system of presets for Csound's scanned synthesis opcodes. Tarmo's code is included as an example in [CsoundQT](https://csoundqt.github.io/), the powerful Csound front-end for which he is the primary author. Tarmo's code makes a very complex and powerful set of opcodes more approachable and usable than they might otherwise be.
- Kyle Gann, for his [essential work on LMY's WTP tuning](http://www.kylegann.com/PNM-WellTunedPiano.pdf), without which I would have no rational basis (pun intended) for using it.
- Art Hunkins, for advice on MIDI controllers, and for helping me understand how to use MIDI in Csound.
- Kathleen, for infinite support and copy-editing.
- As always, many thanks to the Csound development and documentation teams for their great and ongoing work.


### Licensing

Copyright (c) Dave Seidel, 2018, some rights reserved. The contents of this repository are available under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported license (http://creativecommons.org/licenses/by-nc-sa/3.0/). You are welcome to fork this project as long as you abide by the licensing terms.
