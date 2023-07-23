#!/bin/sh

# From: https://stackoverflow.com/questions/34936783/watch-for-volume-changes-in-alsa-pulseaudio

# Set volume initially 
~/.config/eww/scripts/volume.sh

# Set volume on change
pactl subscribe | grep --line-buffered "sink" | while read -r UNUSED_LINE; do ~/.config/eww/scripts/volume.sh; done
