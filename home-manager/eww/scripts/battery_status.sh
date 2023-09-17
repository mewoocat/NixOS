#!/usr/bin/env bash

# acpi output examples
#Battery 0: Charging, 30%, 00:43:15 until charged
#Battery 0: Discharging, 30%, 00:19:05 remaining

time=$(acpi | cut -d ',' -f3)
hr=$(echo $time | cut -d ':' -f1)
min=$(echo $time | cut -d ':' -f2)


# Adding a number to 0 with remove leading 0's
hr=$(($hr+0))
min=$(($min+0))

mode=$(acpi | cut -d ',' -f1 | cut -d ' ' -f3)
if [ $mode == "Charging" ]
then
    echo "Charging\n$hr hr $min min"
elif [ $mode == "Discharging" ]
then
    echo "Remaining\n$hr hr $min min"
else
    echo "Battery error..."
fi


