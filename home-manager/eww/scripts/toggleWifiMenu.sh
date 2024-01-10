#!/bin/sh

#eww open --toggle wifi_menu 
#eww open --toggle system_menu 
#scripts/toggleSystemMenu.sh

if [[ $(eww get showWifi) == false ]]
then
    eww update showMain=false
    eww update showWifi=true
else
    eww update showWifi=false
    eww update showMain=true
fi

# Fixes quick toggle missing an instance (Doesn't work anymore?)
#sleep 0.5

