#!/bin/sh

export MANGOHUD_CONFIG=fps_only,font_size=10,background_alpha=0.0,hud_no_margin,offset_x=0,offset_y=0
#gamescope -H 1080 -r 60 --steam --mangoapp --force-grab-cursor -- steam -steamdeck -steamos3
gamescope -W 1920 -H 1080 -r 60 --steam --mangoapp --force-grab-cursor -- steam -steamdeck -steamos3
