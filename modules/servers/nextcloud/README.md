# Overview
- NixOS Nextcloud configuration

# Usage
## Installation


Installing this Nextcloud Module will setup the nextcloud instance with the provided configuration and a default "admin" user.  No database or user data is preconfigured.
To import an existing Nextcloud installation see [Restoring Nextcloud Instance](##restoring-nextcloud-instance)
- Default nextcloud admin username is `admin`
- Default nextcloud install location is `/var/lib/nextcloud`
- Nextcloud cli command: `nextcloud-occ`

## Backing Up Nextcloud Instance

Switch to maintenance mode.

```sh
nextcloud-occ maintenance:mode --on
```

### Database (mysql/mariadb)

Backup the database, in this case the db name is `nextcloud`.

```sh
sudo -u nextcloud -- mysqldump -u nextcloud nextcloud > database.sql
```

Turn maintenance mode off

```sh
nextcloud-occ maintenance:mode --off
```

For more details, see https://docs.nextcloud.com/server/latest/admin_manual/maintenance/backup.html.

### Files & Configuration
Backup the Nextcloud directory.  In this case the default is `/var/lib/nextcloud`.
This includes the config.php and data/ directories.
```sh
rsync -Aavx nextcloud/ nextcloud-dirbkp_`date +"%Y%m%d"`/
```


## Restoring Nextcloud Instance

After installing this Nextcloud module, non Nix managed data, settings, and files can be restored from an existing Nextcloud instance.

#### Database
It seems that importing a backup of a database into a new installation runs into a server exception if TOTP is setup.  I'm guessing this is due to the secret property in the config.php not matching.
I'm not sure how to set this in the config.php yet.
For now, I think disabling TOTP, exporting the database, then reenabling TOTP is the play.
...
I think the data/ backup may need to copied over to get the appdata for totp? (need to test this)
...
^ This is the fix!  Can login just fine with existing TOTP setup
Need to check if the secret and salt config values also needed to be copied over from backup.  Almost positive that the secret and salt need to be copied over.  Should do this
^nvm, pretty sure now that they don't need to be copied over

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

For more info, see https://docs.nextcloud.com/server/latest/admin_manual/maintenance/restore.html.

# Developing
## Local Development
- Add the ip address of the server to `services.nextcloud.settings.trusted_domains`.
- Disable SSL and HTTPS
- Access the server at `http://<ip_address>/login`

## Rebuilding Remotely
```sh
nixos-rebuild switch --flake </path/to/flake>#<hostname> --target-host "user@<host>" --use-remote-sudo`
```
*Need to look into multiple password prompts*

# Debugging
## Getting Nextcloud logs
Nextcloud php logs?

```sh
journalctl -r -u phpfpm-nextcloud.service

journalctl -t Nextcloud
```

## Checking for successful SSH logins

```sh
journalctl -r -u sshd | grep "Accepted publickey"
```
