#!/usr/bin/env bash

_flags=
if [ -n "$*" ]; then
  _flags=$*
fi

_dac=$(../scripts/get-dac "USB")
if [ -z "$_dac" ]; then
  echo "No USB output device"
  exit 1
fi

csound $_flags --nchnls=4 -+rtaudio=alsa -o$_dac -+rtmidi=portmidi --omacro:BASE_FREQ=261.626 --omacro:FREQ_MULT=2 implication-organ.csd
