#!/bin/sh

currentMonitor=$(hyprctl activeworkspace -j | jq --raw-output '.monitor')
echo $currentMonitor
grim -o $currentMonitor - | satty -f - --early-exit --initial-tool crop --copy-command wl-copy
