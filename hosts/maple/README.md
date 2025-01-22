# Overview
- This is my personal Nextcloud NixOS server

# Usage
## Installation
...
## Backing Up Nextcloud Instance
Not all files related to a Nextcloud instance are managed by Nix.  Here are instructions on what need to be backed up.
Also see: https://docs.nextcloud.com/server/latest/admin_manual/maintenance/backup.html

Switch to maintenance mode
...
```sh
nextcloud-occ maintenance:mode --on
```

### Database (mysql/mariadb)
Backup the database
```sh
sudo -u nextcloud -- mysqldump -u nextcloud nextcloud > database.sql
```

### Files & Configuration
backup /var/lib/nextcloud 
...
The this includes the config.php and data/ dir

Turn maintenance mode off
```sh
nextcloud-occ maintenance:mode --off
```


## Restoring Nextcloud Instance
After installing this Nextcloud module, non Nix managed data, settings, and files can be restored from an existing Nextcloud instance.
https://docs.nextcloud.com/server/latest/admin_manual/maintenance/restore.html

### Database
It seems that importing a backup of a database into a new installation runs into a server exception if TOTP is setup.  I'm guessing this is due to the secret property in the config.php not matching.
I'm not sure how to set this in the config.php yet.
For now, I think disabling TOTP, exporting the database, then reenabling TOTP is the play.
...
I think the data/ backup may need to copied over to get the appdata for totp? (need to test this)
...
^ This is the fix!  Can login just fine with existing TOTP setup
Need to check if the secret and salt config values also needed to be copied over from backup.  Almost positive that the secret and salt need to be copied over.  Should do this

Import database.sql with username "nextcloud" into database called "nextcloud"
```sh
sudo -u nextcloud -- mysql -u nextcloud nextcloud < database.sql
```

### Files & Configuration
Restore desired files from `/var/lib/nextcloud` backup.
...
Restoring data dir
- Copy over `/var/lib/nextcloud` and make sure all the files are owned by the `nextcloud` user and group
```sh
chown -R nextcloud:nextcloud <backup_data_dir>
```

# Info
- Default nextcloud admin username is `admin`
- Default nextcloud install location is `/var/lib/nextcloud`
- Nextcloud cli command: `nextcloud-occ`

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
