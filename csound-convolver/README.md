csound-convolver
================

usage: convolve INPUT_FILE IMPULSE_FILE GAIN_ADJUST OUTPUT_FILE

Convolver tool, applies an IR file to a sound file.
Assumes 96K 24-bit input and output files.

You must have Csound installed and on the path.

The IR input file should 96K or an even divisor of 96K (e.g., 48K).

This is intended to be driven by the "convolve" shell script,
and should reside in the same directory.

Tested with Csound 5.19 under Xubuntu 12.10 (Quantal Quetzal).

Written by Dave Seidel, 2013.
