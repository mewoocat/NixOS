#!/bin/sh

# Option 1
# passing in nix search path via `-I` doesn't seem to take effect
nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=/home/eXia/NixOS/utilities/iso-generation/config.nix

# Option 2
# Get the store path for pinned version of nixpkgs repo
#echo "$nix_path"
# The NIX_PATH environment variable determines the nixpkgs instance and nixos configuration to use for the build
#env NIX_PATH="$nix_path" nixos-rebuild build-image #--image-variant iso
