#!/bin/sh

currentMonitor=$(hyprctl activeworkspace -j | jq --raw-output '.monitor')
echo $currentMonitor
pkill satty
grim -o $currentMonitor - | satty -f - --early-exit --initial-tool crop --copy-command wl-copy --fullscreen
