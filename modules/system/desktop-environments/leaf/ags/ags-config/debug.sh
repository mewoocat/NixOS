#!/bin/sh

sassc ~/NixOS/modules/system/desktop-environments/leaf/ags/ags-config/Style/style.scss ~/.config/leaf-de/ags.css
bun build ~/NixOS/modules/system/desktop-environments/leaf/ags/ags-config/main.ts \
    --outdir /tmp/ags/js \
    --external "resource://*" \
    --external "gi://*" &&
ags -b testing -c /tmp/ags/js/main.js \
    inspector 
    #-t ControlPanel 
