#!/bin/sh

nix run github:nix-community/nixos-anywhere -- \
    --flake ~/NixOS #<configuration name> \
    --target-host root@192.168.0.100
