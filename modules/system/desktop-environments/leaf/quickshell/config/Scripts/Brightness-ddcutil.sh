#!/bin/sh

# This is a simple script which will set the brightness for any plugged in ddcutil compatible monitors.
# Usage: ./Brightness-ddutil.sh <desired-brightness>

VALUE=$1

# Get number of times "Display" is outputted.  Should be once per display.
NUMDISPLAY="$(ddcutil detect | grep -c 'Display')"

# Iterate over each display and set the brightness
for i in $(seq "$NUMDISPLAY"); do
  ddcutil setvcp 10 "$VALUE" --display "$i"
done
