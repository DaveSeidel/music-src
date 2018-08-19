# Implication Organ

This is a realtime microtonal Csound instrument with MIDI keyboard and OSC controller input. I designed it to my specific requirements as a composer based on several specific constraints. It is not intended to be a general-purpose instrument.

The Implication Organ (or IO) is duophonic, in that the performer can play no more than two notes at a time. "Implication" refers to the instrument's generation of chords built from pitches that are mathematically derived, or implied, from the two pitches currently being played. See below under "Features" for more on how this works.

For an example of v1.0 of the IO in use, see https://www.youtube.com/watch?v=hmFTd8E61Ts. In practice, this app is the kernel of a larger system that includes a bunch of hardware that processes the Csound output using a matrix mixer and a number of other effects devices, including loopers.

## Philosophy

I designed the IO as a vehicle for exploring intervals in rational tunings, and the chords that might be generated from those intervals based on mathematical procedures rather than the rules of harmony. It is specialized to favor the production of long tones or drones.

## Requirements

- Csound 6.12 beta or later (for the updated OSClisten opcode and the new OSCcount opcode)
- MIDI keyboard; I use a QuNexus, but any generic MIDI keyboard should do
- OSC controller; I am using Lemur with the UI running on a Google Nexus C tablet (Lemur project is included)

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
    - ring modulator (where one of the main pitches is used as the input, and the other is used as the carrier)
  - Generated voices (except the ring modulator) are expressed using one of three different waveforms:
    - sine wave
    - composite waveform based on harmonics in the Fibonacci series
    - composite waveform based on harmonics in the prime number series
    - David First's asymptotic sawtooth wave
- Selectable microtonal tunings, which can be changed on the fly:
   - A dual hexany scale, built by combining two interleaved 1-3-5-7 hexanies, with one transposed upward by 16/15 (i.e., a major 5-limit half-step). On a conventional keyboard, this maps one hexany to the fingering of the whole tone scale beginning on C, and the other hexany to the fingering of the whole tone scale beginning on C#. See the file dual-interleaved-hexany.scl in this repo.
   - Kraig Grady's [Centaur](http://www.anaphoria.com/centaur.html) tuning.
   - [Meta-Slendro](http://www.anaphoria.com/wilsonintroMERU.html) by Erv Wilson (by way of Kraig Grady); I am using the Meru #3 variant.
   - La Monte Young's Well Tuned Piano tuning.
   - Heinz Bohlen's A12 and JI Harmonic tunings (from the [Scala](http://www.huygens-fokker.org/scala/) archives).
   - Michael Harrison's Revelation tuning.
- OSC interface providing control over a number of parameters:
  - master level for main voices
  - master level for all generated voices
  - submaster level for all combination tones
  - submaster level for all mean tones
  - individual level for each combination tone
  - individual level for each mean tone
  - detuning amount for main voices
  - waveform selection for generated voices (and main voice, if blend is enabled)
  - reduction (i.e. range/transposition) selection for generated tones
  - blend switch (if on, main voice uses same oscillators as generated tone)
  - tuning selection
  - preset selection for main voice
- Outputs:
    - Main voices on channel 1
    - Generated voices on channel 2

## Changes between v1.0 and v2.0

- replaced MIDI controller interface with OSC controller interface (I intend to eventually document the OSC interface)
- added blend switch to make the main voice blend with the generated voices by using the same oscillators
- added preset selection for the main voices
- added Revelation tuning
- removed the ring modulator, as I found that I wasn't really using it, and to reduce CPU load
- made the attack and decay envelopes shorter
- lots of tweaks and a few bug fixes

## Version History

- v1.0, July 2018: initial release using Launch Control XL MIDI controller
- v2.0, August 2018: substantial rewrite to replace MIDI controller interface with OSC interface (but still with MIDI keyboard)

## TODO

Things that I may or may not do someday:
- Add file list to README
- Add filter controls for main voice
- Add alternate instrument definitions for the main voice

## Acknowledgements and Thanks

The IO incorporates work from several people. Thanks to:
- John ffitch from the Csound development team for his willingness to enhance Csound's OSC support. He added an alternate form of the OSClisten opcode that is more efficient for endpoints that send a long list of values (e.g., for radio-button controls, as used by the tuning and preset selectors). He also added a new opcode called OSCcount that returns the number of pending incoming OSC message, which makes it much more efficient to write code that needs to monitor a bunch of endpoints.
- Tarmo Johannes, for his system of presets for Csound's scanned synthesis opcodes. Tarmo's code is included as an example in [CsoundQT](https://csoundqt.github.io/), the powerful Csound front-end for which he is the primary author. Tarmo's code makes a very complex and powerful set of opcodes more approachable and usable than they might otherwise be.
- Steven Yi, for his implementation of Julian Parker's ring modulator design, which is based on an diode-based analog design. For more information, including a link to Parker's paper, see [Steven's article](http://kunstmusik.com/2013/09/07/julian-parker-ring-modulator/).
- Kyle Gann, for his [essential work on LMY's WTP tuning](http://www.kylegann.com/PNM-WellTunedPiano.pdf), without which I would have no rational basis (pun intended) for using it.
- Art Hunkins, for advice on MIDI controllers, and for helping me understand how to use MIDI in Csound.
- David First, for his asymptotic sawtooth wave, from his [article on Schuman Resonances](http://www.davidfirst.com/schumann_resonances.pdf).
- Michael Harrison, for his Revelation tuning.
- Kathleen, for infinite support and copy-editing.
- As always, many thanks to the Csound development and documentation teams for their great and ongoing work.


### Licensing

Copyright (c) Dave Seidel, 2018, some rights reserved. The contents of this repository are available under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported license (http://creativecommons.org/licenses/by-nc-sa/3.0/). You are welcome to fork this project as long as you abide by the licensing terms.
