#!/bin/sh

state=$(eww get system_menu_open)

if [ $state == "false" ]; then
    #eww open system_menu
    eww update system_menu_open=true;
else
    #eww close system_menu
    eww update system_menu_open=false;
fi

# Fixes quick toggle missing an instance (Doesn't work anymore?)
#sleep 0.5

