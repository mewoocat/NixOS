#!/bin/sh

state=$(eww get system_menu_open)

if [ $state == "false" ]; then
    eww update system_menu_open=true;
    #eww open --toggle system_menu
else
    eww update system_menu_open=false;
    #eww open --toggle system_menu
fi

# Fixes quick toggle missing an instance (Doesn't work anymore?)
#sleep 0.5

