


# Backing Up and Restoring
There is probably a better way to do this but right now the method that seems to work.
1. Stop the specific minecraft server systemd service
2. Backup the `world/` server sub directory
3. Enable and initialize the world on the new server.
4. Stop the service on the new server and then delete the newly generated `world/` directory
5. Copy the world backup to the new server directory and then restart the service.

WARNING: It seems that there isn't anything we care about preserving that isn't in the world directory.  It all appears to be configuration and mods which are handled by the nixos option.  I could be wrong but so far so good.
