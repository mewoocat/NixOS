#!/bin/sh
# This is a wrapper around the nixos-rebuild command to support npins.  This script can be executed
# with the same arguments that nixos-rebuild expects.

hostname=scythe

# Get the store path for pinned version of nixpkgs repo
nixpkgs_store_path=$(nix-instantiate --eval npins/ -A nixpkgs.outPath | tr -d '"')
# The nixos configuration to build
nixos_configuration="$(pwd)/hosts/$hostname/configuration.nix"
nix_path="nixpkgs=$nixpkgs_store_path:nixos-config=$nixos_configuration"

echo "nixpkgs store path: $nixpkgs_store_path"
echo "nixos config path:  $nixpkgs_store_path"
echo "$nix_path"

# The NIX_PATH environment variable determines the nixpkgs instance and nixos configuration to use for the build
env NIX_PATH="$nix_path" nixos-rebuild "$@"
