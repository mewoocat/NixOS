#/bin/sh

# Get secondary monitor name 
#mon2=$(hyprctl monitors | grep "(ID 1):" | awk {'print $2'})
#

primary="DP-2"
secondary="HDMI-A-1"

# Set monitors (Assumes second monitor is )
hyprctl keyword monitor $primary,1920x1080@144,0x0,1
hyprctl keyword monitor $secondary,640x480@60,1920x200,1
hyprctl keyword monitor $secondary,addreserved,-8,-8,4,4


hyprctl keyword workspace 1, monitor:$primary, default:true
hyprctl keyword workspace 2, monitor:$primary
hyprctl keyword workspace 3, monitor:$primary
hyprctl keyword workspace 4, monitor:$primary, gapsin:0, gapsout:0, rounding:0
hyprctl keyword workspace 5, monitor:$primary
hyprctl keyword workspace 6, monitor:$secondary, default:true
hyprctl keyword workspace 7, monitor:$secondary
hyprctl keyword workspace 8, monitor:$secondary
hyprctl keyword workspace 9, monitor:$secondary
hyprctl keyword workspace 10, monitor:$secondary

