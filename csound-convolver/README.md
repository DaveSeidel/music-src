csound-convolver
================

Convolver tool, applies an impulse respone (IR) file to a sound file.

usage: convolve INPUT_FILE IMPULSE_FILE GAIN_ADJUST OUTPUT_FILE

where:
- INPUT_FILE is the name of the sound file to be convolved (assumed to be 96K 24-bit WAV)
- IMPULSE_FILE is a sound file consisting of an impulse response recording (WAV file assumed, should be 96K or 48K)
- GAIN_ADJUST is the amount by which the gain of the input file should be scaled (numeric, 0.1 means 10%)
- OUTPUT_FILE is the name of the output sound file (96k 24-bit WAV)

Notes:
- You must have Csound installed and on the path.
- The IR input file should 96K or an even divisor of 96K (e.g., 48K).
- The GAIN_ADJUST parameter is used to reduce the level of the input file to avoid clipping; depending on the IR, convolution can add a lot of gain.

The "convolve" shell script requires the Csound script "convolver.csd", which must be located in the same directory as "convole".

Tested with Csound 5.19 under Xubuntu 12.10 (Quantal Quetzal).

For more information on Csound, see http://www.csounds.com.

A good source for free IR files is http://www.openairlib.net.

Written by Dave Seidel, 2013.

Copyright (c) Dave Seidel, 2013, some rights reserved. The contents of this repository are available under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported license (http://creativecommons.org/licenses/by-nc-sa/3.0/). You are welcome to fork this project as long as you abide by the licensing terms.

