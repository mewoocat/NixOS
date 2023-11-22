#!/usr/bin/env bash

# Check if wifi is enabled
status=$(nmcli radio wifi)
if [[ $status == "disabled" ]]; then
    # Turn wifi on
    nmcli radio wifi on
else
    # Turn wifi off
    nmcli radio wifi off
fi