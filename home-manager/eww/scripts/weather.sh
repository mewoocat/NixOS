#!/bin/sh

while [ true ]
do
    curl wttr.in/?format="%C+%t\n"
    sleep 5
done

#curl wttr.in
