#!/usr/bin/env bash

icon_dir="/home/ghost/.config/eww/images/"


status="$(acpi | awk '{print $4}' | tr -d %,)"
state="$(acpi | awk '{print $3}' | tr -d ,)"
critical="no"

if [[ $state = "Discharging" ]]; then
    if (($status > 80)); then
        icon=""
        #icon=$(echo -e "\uf026")
    elif (($status > 60)); then
        icon=""
    elif (($status > 40)); then
        icon=""
    elif (($status > 20)); then
        icon=""
    else
        icon=""
        critical="yes"
    fi
    bg=""
else
    icon=""
    bg=""
fi

#echo "${icon}"
#echo "/home/ghost/.config/eww/images/wifi-3.svg"

echo "{\"icon\": \"${icon}\", \"bg\": \"${bg}\", \"critical\": \"${critical}\"}"
