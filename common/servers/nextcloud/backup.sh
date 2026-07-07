#!/bin/sh

hostName="maple"

rsync \
  -Aavx \
  --rsync-path "sudo rsync" \
  --info=progress2 \
  --human-readable \
  --hard-links \
  --no-inc-recursive \
  --compress \
  --delete \
  "$hostName:/var/lib/nextcloud" "/run/media/eXia/server-backup/nextcloud-backup_var-lib-nextcloud/"
  #-vvv
  #"$hostName:/home/eXia/test" "/tmp/test"
  #-e "ssh -tt" \
