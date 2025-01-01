#!/bin/sh

nix run github:nix-community/nixos-anywhere -- \
    --flake ~/NixOS#maple \
    --target-host root@192.168.0.100 \
    --generate-hardware-config nixos-generate-config ~/NixOS/hosts/maple/hardware-configuration.nix \

