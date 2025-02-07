#!/bin/sh

# INFO:
# - nixos-anywhere helper script for installing host maple remotely
# Credits:
# - https://github.com/nix-community/nixos-anywhere/blob/main/docs/howtos/secrets.md#example-decrypting-an-openssh-host-key-with-pass

# Get args
ip=$1 # IP address of target host
user=$2 # SSH user name of target host
targetKeyPath=$3 # Path to the ssh private key for accessing the target host in order to initiate installation.
hostKeyPath=$4 # Path to ssh host key to copy over.  Needed for decrypting secrets.

# Globals
hostname="maple"
sshkeyType="ed25519"

# Create a temporary directory
temp=$(mktemp -d)

# Function to cleanup temporary directory on exit
cleanup() {
    rm -rf "$temp"
}
trap cleanup EXIT

# Create the directory where sshd expects to find the host keys
install -d -m755 "$temp/etc/ssh"

# Copy ssh private key to expected location
cp "$hostKeyPath" "$temp/etc/ssh/ssh_host_${sshkeyType}_key"

# Set the correct permissions so sshd will accept the key
chmod 600 "$temp/etc/ssh/ssh_host_${sshkeyType}_key"

# Install NixOS to the host system with our secrets
nix run github:nix-community/nixos-anywhere -- \
    --extra-files "$temp" \
    --flake ".#$hostname" \
    --target-host "$user@$ip"\
    -i "$targetKeyPath"
