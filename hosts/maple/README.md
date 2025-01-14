# Overview
- This is my personal Nextcloud NixOS server

# Usage
## Installation
...
## Backing Up Nextcloud Instance
Not all files related to a Nextcloud instance are managed by Nix.  Here are instructions on what need to be backed up.
Also see: https://docs.nextcloud.com/server/latest/admin_manual/maintenance/backup.html

### Database (mysql/mariadb)
Switch to maintenance mode.
...

Backup the database
```sh
sudo -u nextcloud -- mysqldump -u nextcloud nextcloud > database.sql
```

### Files & Configuration
backup /var/lib/nextcloud 
...

## Restoring Nextcloud Instance
After installing this Nextcloud module, non Nix managed data, settings, and files can be restored from an existing Nextcloud instance.
https://docs.nextcloud.com/server/latest/admin_manual/maintenance/restore.html

### Database
It seems that importing a backup of a database into a new installation runs into a server exception if TOTP is setup.  I'm guessing this is due to the secret property in the config.php not matching.
I'm not sure how to set this in the config.php yet.
For now, I think disabling TOTP, exporting the database, then reenabling TOTP is the play.

Import database.sql with username "nextcloud" into database called "nextcloud"
```sh
sudo -u nextcloud -- mysql -u nextcloud nextcloud < database.sql
```

### Files & Configuration
Restore desired files from `/var/lib/nextcloud` backup.
...

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

# Debugging
## Getting Nextcloud logs
nextcloud php logs?
```sh
journalctl -r -u phpfpm-nextcloud.service
```
## Checking for successful logins
```sh
journalctl -u sshd -r | grep "Accepted publickey
```
