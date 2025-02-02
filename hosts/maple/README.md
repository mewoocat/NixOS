# Overview
- This is my personal Nextcloud NixOS server.


## Rebuilding Remotely
```
nixos-rebuild switch --flake </path/to/flake>#<hostname> --target-host "user@<host>" --use-remote-sudo
```
*Need to look into multiple password prompts*

