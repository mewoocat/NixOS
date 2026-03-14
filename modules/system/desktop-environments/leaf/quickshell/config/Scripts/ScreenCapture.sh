#!/bin/sh

#mkdir ~/Screenrecordings;

geometry="$(slurp)"

notify-send "Recording Screen!"
wf-recorder \
  -f ~/Screenrecordings/recording_"$(date +\'%b-%d-%Y-%I:%M:%S-%P\')".mp4 \
  -g "$geometry" \
  --pixel-format yuv420p

#notify-send "Stopped Screen!"
