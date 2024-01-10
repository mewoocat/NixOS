#/bin/sh

# Get secondary monitor name 
mon2=$(hyprctl monitors | grep "(ID 1):" | awk {'print $2'})

# Set monitors (Assumes second monitor is 1080p)
hyprctl keyword monitor eDP-1,preferred,0x1080,1.5
hyprctl keyword monitor $mon2,preferred,0x0,1

sleep 3

# Relaunch eww
~/myNixOSConfig/home-manager/eww/scripts/launchEww.sh

# Reset wallpaper
~/myNixOSConfig/home-manager/theme_bird/theme.sh -w