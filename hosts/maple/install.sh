#!/bin/bash

# nixos-anywhere helper script for installing host maple remotely
# Credits:
# - https://github.com/nix-community/nixos-anywhere/blob/main/docs/howtos/secrets.md#example-decrypting-an-openssh-host-key-with-pass

# Get args
ip=$1
user=$2
sshkey=$3 # Path to ssh key to copy over

# Create a temporary directory
temp=$(mktemp -d)

# Function to cleanup temporary directory on exit
cleanup() {
    rm -rf "$temp"
}
trap cleanup EXIT

# Create the directory where sshd expects to find the host keys
install -d -m755 "$temp/etc/ssh"

# Copy ssh key to expected location
cp "$sshkey" "$temp/etc/ssh"

# Set the correct permissions so sshd will accept the key
chmod 600 "$temp/etc/ssh/*"

# Install NixOS to the host system with our secrets
nixos-anywhere --extra-files "$temp" --flake ".#$hostname" --target-host "$user@$ip"
