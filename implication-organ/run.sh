#!/usr/bin/env bash

_flags=
if [ -n "$*" ]; then
  _flags=$*
fi

csound $_flags -+rtaudio=alsa -odac -+rtmidi=portmidi --omacro:BASE_FREQ=261.626 --omacro:GLOBAL_PRESET=2 --omacro:FREQ_MULT=2 implication-organ.csd
