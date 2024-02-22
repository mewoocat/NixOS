#/bin/sh

# Get secondary monitor name 
mon2=$(hyprctl monitors | grep "(ID 1):" | awk {'print $2'})

# Set monitors (Assumes second monitor is 1080p)
#hyprctl keyword monitor eDP-1,preferred,0x1080,1.6667
#hyprctl keyword monitor $mon2,preferred,0x0,1

# Set monitors (Assumes second monitor is )
hyprctl keyword monitor eDP-1,preferred,0x2160,1.6667
hyprctl keyword monitor $mon2,preferred,0x0,1

