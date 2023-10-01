#!/bin/sh


level=$(amixer get Capture | grep 'Left:' | awk -F'[][]' '{ print $2 }' | tr -d '%' | head -1)

if (($level))
then
    mute=false
    if (($level > 0)); then
        icon=$(echo -e "")
    fi
else
    mute=true
    icon=$(echo -e "")
fi

#echo -n $level
echo "{\"icon\": \"${icon}\", \"level\": \"${level}\", \"mute\": \"$mute\"}"

