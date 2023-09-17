#!/bin/sh

<<old_implementation
function handle {
  if [[ ${1:0:12} == "monitoradded" ]]; then
    hyprctl dispatch moveworkspacetomonitor "1 0"
    hyprctl dispatch moveworkspacetomonitor "2 0"
    hyprctl dispatch moveworkspacetomonitor "3 0"
    hyprctl dispatch moveworkspacetomonitor "4 0"
    hyprctl dispatch moveworkspacetomonitor "5 0"
    hyprctl dispatch moveworkspacetomonitor "6 1"
    hyprctl dispatch moveworkspacetomonitor "7 1"
    hyprctl dispatch moveworkspacetomonitor "8 1"
    hyprctl dispatch moveworkspacetomonitor "9 1"
    hyprctl dispatch moveworkspacetomonitor "10 1"
    wallpaper=$(cat ~/.config/wallpaper)
    swww img $wallpaper
    #./.scripts/theme.sh -w
  fi
}

socat - UNIX-CONNECT:/tmp/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock | while read line; do handle $line; done

old_implementation


handle() {
  case $1 in monitoradded*)
    hyprctl dispatch moveworkspacetomonitor "1 0"
    hyprctl dispatch moveworkspacetomonitor "2 0"
    hyprctl dispatch moveworkspacetomonitor "3 0"
    hyprctl dispatch moveworkspacetomonitor "4 0"
    hyprctl dispatch moveworkspacetomonitor "5 0"
    hyprctl dispatch moveworkspacetomonitor "6 1"
    hyprctl dispatch moveworkspacetomonitor "7 1"
    hyprctl dispatch moveworkspacetomonitor "8 1"
    hyprctl dispatch moveworkspacetomonitor "9 1"
    hyprctl dispatch moveworkspacetomonitor "10 1"
  esac
}

socat - "UNIX-CONNECT:/tmp/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" | while read -r line; do handle "$line"; done


