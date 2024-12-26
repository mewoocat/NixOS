#!/bin/sh
exec uwsm start hyprland-uwsm.desktop

:<< 'comment'
hyprctl dispatch -- exec [workspace 1 silent] foot fastfetch none
hyprctl dispatch -- exec [workspace 2 silent] obsidian --disable-gpu
hyprctl dispatch -- exec [workspace 3 silent] firefox #
#hyprctl dispatch -- exec [workspace 4 silent] kitty vi
hyprctl dispatch -- exec [workspace 9 silent] vesktop --disable-gpu
hyprctl dispatch -- exec [workspace 10 silent] foot btop
hyprctl dispatch -- exec [workspace 10 silent] nextcloud
comment
