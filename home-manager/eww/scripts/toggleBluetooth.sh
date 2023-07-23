#!/bin/sh

status=$(bluetoothctl show | grep "Powered" | cut -d ' ' -f2)

if [[ $status == "yes" ]];
then
    bluetoothctl power off
else
    bluetoothctl power on
fi
