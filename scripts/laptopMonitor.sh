#/bin/sh

# Set internal display
#hyprctl keyword monitor eDP-1,2560x1440@60,0x0,1.66667
hyprctl keyword monitor eDP-1,1280x720@60,0x0,1.0

hyprctl keyword workspace 1, monitor:$primary, default:true
hyprctl keyword workspace 2, monitor:$primary
hyprctl keyword workspace 3, monitor:$primary
hyprctl keyword workspace 4, monitor:$primary, gapsin:0, gapsout:0, rounding:0
hyprctl keyword workspace 5, monitor:$primary
hyprctl keyword workspace 6, monitor:$secondary
hyprctl keyword workspace 7, monitor:$secondary
hyprctl keyword workspace 8, monitor:$secondary
hyprctl keyword workspace 9, monitor:$secondary
hyprctl keyword workspace 10, monitor:$secondary
