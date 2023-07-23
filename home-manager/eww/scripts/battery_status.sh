#!/usr/bin/env bash


time=$(acpi | cut -d ',' -f3)
hr=$(echo $time | cut -d ':' -f1)
min=$(echo $time | cut -d ':' -f2)

# Adding a number to 0 with remove leading 0's
hr=$(($hr+0))
min=$(($min+0))
echo "Time remaining\n$hr hr $min min"
