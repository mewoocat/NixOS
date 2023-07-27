#!/bin/sh

# Start monitoring the audio output devices for changes
pactl subscribe |
while read line; do
  # Check if the line contains the sink event
  if echo "$line" | grep -qE 'Event sink|Event new|Event change'; then
    # Get the current volume level of the audio output device
    VOLUME=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n1 | awk -F/ '{print $2}' | tr -d '[:space:]')

    # Output a message indicating the volume has changed
    echo "Volume changed: $VOLUME"
  fi
done
