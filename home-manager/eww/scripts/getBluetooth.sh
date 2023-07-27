#!/bin/sh

status=$(bluetoothctl show | grep "Powered" | cut -d ' ' -f2)

if [[ $status == "yes" ]];
then
    echo "true"
else
    echo "false"
fi
