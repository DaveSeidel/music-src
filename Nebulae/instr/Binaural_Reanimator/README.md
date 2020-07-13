# Binaural Reanimator

Record button OFF = Chorus mode: binaural chorusing effect.
Input(s) split into binaural pair with slight pitch
offsets relative to original pitch. Separate pitch offset
and amplitude controls for each channel.

Record button ON = OSC mode: binaural beating oscillator.
Dual sine/triangle oscillators at same pitch,
set by v/oct or Pitch knob. Separate beating rate and
amplitude controls for each channel.

Panning/tremolo applies to both modes.

## Controls

 * Amplitude (Start and Size knobs/CV)
 * Beating rate/pitch offset (Density and Overlap knobs/CV)
 * Pitch (Pitch knob or v/oct CV input) - OSC MODE ONLY
 * Fine pitch control with Pitch knob when File button is held
 * Waveform (Blend knob/CV) - OSC MODE ONLY
 * Cross-Panning Speed (Window knob/CV)
 * Mode selection, FX vs OSC (Record button/CV)

## Details

### Chorus Mode (Record OFF)

In this mode, it is an effect that takes audio input and processes each channel separately into a binaural pair where left and right sizes have very slight pitch offsets set by the Density and Overlap knobs respectively; larger offsets increase the chorusing effect.

Each channel has its own amplitude control. In the case of mono input,
where the left inpout is normalized to the right input, this allows you to control the layering of the chorusing effect that is applied seperately to each channel. With stereo input, this is also the case, but you may prefer to set the pitch offset and amplitude controls to the same values.

### Oscillator Mode (Record ON)

In this mode, it is a dual oscillator using simple waveforms (morphable between sine and triangle waves) that allows you to create
classic binaural beating effects, suitable for use by itself or for combining with other sound sources.  

There are two oscillators here, and they are set to the same pitch (using the Pitch knob or the v/oct CV input), but each channel has its own amplitude and beating rate controls, which provides two layers of binaural beating with a lot of control. Note also that if you hold down the File button, you can use the Pitch knob for fine tuning.

The beating rate controls (Density and Overlap) range from 0 to 30Hz, which encompasses the delta, theta, alpha, and beta brainwave ranges. See [this article](https://www.healthline.com/health/binaural-beats#instructions) for more information. However, please see the [Disclaimer](#Disclaimer) below.

Waveform is controlled by the blend knob (or CV input). This control morphs smoothly through two waveforms: sine and triangle. These waveforms are used because he binaural beating effect is more pronounced with simple timbres.

### Cross-Panning

In both modes, there is an optional cross-panning effect that pans the two channels back and forth, each channel with its own LFO. The LFOs begin with opposite phase, operate at very slightly different speeds and move in opposite directions. The panning speed is controlled by the Window knob. This provides a kind of tremolo, most apparent at higher speeds. At slower speeds, it animates the output.

## Disclaimer

I make no claims whatsoever for any theoretical effects of binaural beats on cognition, mood, or anything else. My interest is purely musical.

## Changelog
 * v1.0 - initial release

---

Dave Seidel, July 2020, v1.0
