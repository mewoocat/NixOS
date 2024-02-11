#!/usr/bin/env bash
#
# Usage: ./rebuildNixOS.sh <host-name>
# Example ./reBuildNixOS.sh scythe

system=$1
sudo nixos-rebuild switch --flake /home/eXia/NixOS#obsidian
systemctl --user restart udiskie
systemctl --user restart swayidle

