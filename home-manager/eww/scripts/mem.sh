#!/bin/sh

total=$(cat /proc/meminfo | grep "MemTotal" | awk  '{ print $2 }')
available=$(cat /proc/meminfo | grep "MemAvailable" | awk '{print $2}')
# cut -c 2- from: https://www.baeldung.com/linux/bash-remove-first-characters
echo "scale = 2; 1 - (${available} / ${total})" | bc | cut -c 2-
