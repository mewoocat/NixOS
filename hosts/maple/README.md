# Overview
- This is my personal NixOS server.

# Usage

## Installation

This host is designed to be installed remotely via [nixos-anywhere](https://github.com/nix-community/nixos-anywhere).  Note that these are the very basic instructions to get this machine up and running.  The [nixos-anywhere](https://github.com/nix-community/nixos-anywhere/blob/main/docs/INDEX.md) documentation should be consulted for further information.

### Prerequisites 
- Ensure key based SSH access to the target machine as root.
- Set the user's password on the build machine to the `SSHPASS` environment variable.  This together with the `--env-password` avoids SSH password prompts.
- Ensure that your user to install has a corresponding public ssh key provided.  Without this you won't be able to login remotely after installing.

### Install

This will also automatically generate the `hardware-configuration.nix` file.

```
nix run github:nix-community/nixos-anywhere -- --flake <path/to/this/flake>#<hostname> --target-host <your-sudo-user>@<ip address> -i <path/to/ssh/key> --env-password
```

## Rebuilding the Flake Remotely
```
nixos-rebuild switch --flake </path/to/flake>#<hostname> --target-host "<user>@<hostname>" --use-remote-sudo
```
*Need to look into multiple password prompts issue*

