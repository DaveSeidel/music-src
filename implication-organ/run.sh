#!/usr/bin/env bash

# -Q must use be a Launch Control XL
# -o will be the Pisound -- change to "-odac" for the generic case
# csound -Q$(../scripts/get-midi-out) -o $(../scripts/get-dac) implication-organ.csd
csound -o $(../scripts/get-dac) implication-organ.csd
