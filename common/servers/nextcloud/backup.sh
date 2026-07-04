#!/bin/sh

hostName="maple"

# TODO: use nextcloud use for permissions
rsync -vvv --dry-run -Aavx \
  "$hostName:/home/eXia/test" "/tmp/test"
  #-e "ssh -tt" \
  #--rsync-path "rsync" \
  #"$hostName:/var/lib/nextcloud" "/run/media/eXia/server-backup/nextcloud-backup_$(date +"%Y%m%d")/"
