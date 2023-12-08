#/bin/sh
# This is based on my two 1080p desktop monitors

# Disable internal monitor
hyprctl keyword monitor eDP-1,disable

# Enable external monitors
hyprctl keyword monitor DP-1,preferred,-1920x0,1
hyprctl keyword monitor DP-2,preferred,0x0,1

sleep 3

# Relaunch eww
~/myNixOSConfig/home-manager/eww/scripts/launchEww.sh
