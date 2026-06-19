#!/bin/sh

hostName="maple"

# TODO: use nextcloud use for permissions
rsync --dry-run -Aavx "$hostName:/var/lib/nextcloud" "/run/media/eXia/server-backup/nextcloud-backup_$(date +"%Y%m%d")/"
