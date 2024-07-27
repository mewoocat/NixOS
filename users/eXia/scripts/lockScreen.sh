#!/bin/sh

wallpaper=~/.cache/wallpaper
#${pkgs.gtklock}/bin/gtklock -b $wallpaper -t "%l:%M %P"
gtklock -b $wallpaper -t "%l:%M %P"
#gtklock -t "%l:%M %P"
