#/bin/sh

# Disable internal monitor
hyprctl keyword monitor eDP-1,disable

sleep 3

# Relaunch eww
~/myNixOSConfig/home-manager/eww/scripts/launchEww.sh