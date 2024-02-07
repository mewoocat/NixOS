#!/bin/sh

state=$(hyprctl getoption device:razer-razer-blade-stealth-keyboard:enabled | grep int: | cut -d ' ' -f 2)
echo "State = $state"

externalKeyboard="splitkb.com-aurora-lily58-rev1"
hyprctl devices | grep $externalKeyboard > /dev/null
if [[ $? == 0 ]]
then
    if [[ $state == "0" ]]
    then
        echo "enabling..."
        hyprctl keyword device:razer-razer-blade-stealth-keyboard:enabled true 
    else
        echo "disabling..."
        hyprctl keyword device:razer-razer-blade-stealth-keyboard:enabled false
    fi
else
    echo "A valid external keyboard is not detected."
fi