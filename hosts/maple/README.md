# Overview
- This is my personal NixOS server.

# Usage

## Installation

This host is designed to be installed remotely via [nixos-anywhere](https://github.com/nix-community/nixos-anywhere).  Note that these are the very basic instructions to get this machine up and running.  The [nixos-anywhere](https://github.com/nix-community/nixos-anywhere/blob/main/docs/INDEX.md) documentation should be consulted for further information.

### Prerequisites 
- Ensure key based SSH access to the target machine as root.
~~- Set the user's password on the build machine to the `SSHPASS` environment variable.  This together with the `--env-password` avoids SSH password prompts.~~
- Ensure that you are supplying a public ssh key for a user on the target system.  Without this you won't be able to login remotely after installing.

### Install

This will also automatically generate the `hardware-configuration.nix` file.

| Parameter | Description |
| - | - |
| ip | IP address of target machine to install NixOS on |
| user | User to login into on target machine |
| target_ssh_key_path | Path to the private key to authenticat the login on the target machine |
| host_ssh_key_path | Path to the new private key for the installed host, needed to decrypt secrets |

```
./install.sh <ip> <user> <target_ssh_key_path> <host_ssh_key_path>
```

Example

```
./install.sh "192.168.0.103" "root" "~/.ssh/old_machine" "~/.ssh/maple"
```

## Rebuilding the Flake Remotely
```
nixos-rebuild switch --flake </path/to/flake>#<hostname> --target-host "<user>@<hostname>" --use-remote-sudo
```
*Need to look into multiple password prompts issue*

