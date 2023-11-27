#!/bin/sh

state=$(hyprctl getoption general:gaps_out | grep int | awk '{print $2}')

if [[ "$state" -gt 0 ]]
then
    hyprctl keyword general:gaps_out 0
    hyprctl keyword general:gaps_in 0
    hyprctl keyword decoration:rounding 0
else
    hyprctl keyword general:gaps_out 20
    hyprctl keyword general:gaps_in 5
    hyprctl keyword decoration:rounding 14
fi