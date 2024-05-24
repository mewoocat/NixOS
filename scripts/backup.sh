#!/bin/sh
#
# Usage: ./backup.sh src/ dest/

src=$1
dest=$2

date=$(date +"%b-%d-%Y-%T")
backupDir="Backup-$date"
mkdir $dest/$backupDir

#--dry-run
rsync --human-readable --hard-links --archive --info=progress2 --no-inc-recursive $src $dest/$backupDir
