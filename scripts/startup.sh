#!/bin/sh

if [[ "$(hostname)" == "scythe" ]]; then
    sh ~/NixOS/scripts/laptopMonitor.sh
fi

hyprctl dispatch -- exec [workspace 1 silent] kitty fastfetch none
hyprctl dispatch -- exec [workspace 2 silent] obsidian --disable-gpu
hyprctl dispatch -- exec [workspace 3 silent] firefox # No worky
hyprctl dispatch -- exec [workspace 4 silent] kitty vi
hyprctl dispatch -- exec [workspace 9 silent] vesktop --disable-gpu
hyprctl dispatch -- exec [workspace 10 silent] kitty btop
hyprctl dispatch -- exec [workspace 10 silent] nextcloud

