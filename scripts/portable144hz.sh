#/bin/sh

# Get secondary monitor name 
#mon2=$(hyprctl monitors | grep "(ID 1):" | awk {'print $2'})
#

primary="HDMI-A-1"

# Set monitors (Assumes second monitor is )
hyprctl keyword monitor $secondary,2560x1600@120,1920x500,1.6


hyprctl keyword workspace 1, monitor:$primary, default:true
hyprctl keyword workspace 2, monitor:$primary
hyprctl keyword workspace 3, monitor:$primary
hyprctl keyword workspace 4, monitor:$primary, gapsin:0, gapsout:0, rounding:0
hyprctl keyword workspace 5, monitor:$primary
hyprctl keyword workspace 6, monitor:$primary
hyprctl keyword workspace 7, monitor:$primary
hyprctl keyword workspace 8, monitor:$primary
hyprctl keyword workspace 9, monitor:$primary
hyprctl keyword workspace 10, monitor:$primary

