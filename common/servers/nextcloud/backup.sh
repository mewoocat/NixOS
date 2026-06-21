#!/bin/sh

hostName="maple"

# TODO: use nextcloud use for permissions
rsync -vvv --dry-run -Aavx -e "ssh -tt" --rsync-path "sudo rsync" "$hostName:/var/lib/nextcloud" "/run/media/eXia/server-backup/nextcloud-backup_$(date +"%Y%m%d")/"
