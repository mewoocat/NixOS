#!/bin/sh

#mkdir ~/Screenrecordings;

geometry="$(slurp)"
notify-send "Recording Screen!"

# Issue seems to be that running slurp in a quickshell process will cause it to hang until the process is set to not running

wf-recorder \
  -f ~/Screenrecordings/recording_"$(date +\'%b-%d-%Y-%I:%M:%S-%P\')".mp4 \
  -g "$geometry" \
  --pixel-format yuv420p


#notify-send "Stopped Screen!"
