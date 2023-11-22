#!/bin/sh

handle() {

    echo "hi"

  #case $1 in
  #  monitoradded*) do_something ;;
  #  focusedmon*) do_something_else ;;
  #esac
  
}

# Listens for Hyprland events and calls handle() on each one
socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done