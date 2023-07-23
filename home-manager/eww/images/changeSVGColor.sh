#!/bin/bash

# Created by chatGPT

# Store the color value passed in as an argument
COLOR="$1"

# Loop through all SVG files in the current directory
for file in *.svg
do
    # Use sed to replace any color value in the file with the new color
    sed -i "s/#\([[:xdigit:]]\{6\}\)/$COLOR/g" "$file"
done
