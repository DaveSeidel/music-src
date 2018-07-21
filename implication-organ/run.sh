#!/usr/bin/env bash

# -Q must use be a Launch Control XL
# -o will be the Pisound -- change to "-odac" for the generic case
csound -Q$(get-midi-out) -o $(get-dac) implication-organ.csd
