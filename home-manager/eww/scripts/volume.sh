#!/bin/sh


level=$(amixer -D pulse sget Master | grep 'Left:' | awk -F'[][]' '{ print $2 }' | tr -d '%' | head -1)
# Bluetooth headset no worky ?
#level=$(amixer -D pulse sget Master | grep 'Mono:' | awk -F'[][]' '{ print $2 }' | tr -d '%' | head -1)

if (($level))
then
    mute=false
    if (($level > 75)); then
        icon=$(echo -e "")
    elif (($level > 50)); then
        icon=$(echo -e "")
    elif (($level > 25)); then
        icon=$(echo -e "")
    else
        icon=$(echo -e "")
    fi
    bg=$(echo -e "")
else
    mute=true
    icon=$(echo -e "")
    bg=$(echo -e "")
fi

device=$(pactl list sinks | grep device.description | awk -F "=" '{print $2}' | tr -d '"' | cut --complement -b 1)

#echo -n $level
echo "{\"icon\": \"${icon}\", \"bg\": \"${bg}\", \"level\": \"${level}\", \"mute\": \"${mute}\", \"device\": \"${device}\"}"
