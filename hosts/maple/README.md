# Overview
- This is my personal Nextcloud NixOS server

# Usage
## Installation
...
## Backing Up Nextcloud Instance
Not all files related to a Nextcloud instance are managed by Nix.  Here are instructions on what need to be backed up.
...
? backup /var/lib/nextcloud ?
## Restoring Nextcloud Instance
After installing this Nextcloud module, non Nix managed data, settings, and files can be restored from an existing Nextcloud instance.

# Info
- Default nextcloud admin username is `admin`
- Default nextcloud install location is `/var/lib/nextcloud`

# Developing
## Local Development
- Add the ip address of the server to `services.nextcloud.settings.trusted_domains`.
- Disable SSL and HTTPS
- Access the server at `http://<ip_address>/login`

## Rebuilding Remotely
`nixos-rebuild switch --flake </path/to/flake>#<hostname> --target-host "root@<ip_address>"`
