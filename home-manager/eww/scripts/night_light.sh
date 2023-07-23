#!/bin/sh

if [[ $1 == "on" ]]; then
    eww update night_light=true
    pkill gammastep
    gammastep -O 2000
fi

if [[ $1 == "off" ]]; then
    eww update night_light=false
    pkill gammastep
fi
