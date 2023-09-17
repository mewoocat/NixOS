#!/bin/sh


while getopts id flag
do
    case "${flag}" in
        i) light -A 5;;
        d) light -D 5;;
    esac
done

~/.config/hypr/scripts/brightnessOSD.sh