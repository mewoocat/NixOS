#!/bin/sh

DRIVE="/dev/disk/by-id/ata-WDC_WD40EFZZ-68CPAN0_WD-WX52DC5FWJ57-part1"
POOL="StoragePool"
MNT="/mnt/Storage"

sudo mkdir -p $MNT
sudo zpool import -d $DRIVE $POOL
sudo zfs load-key $POOL
sudo mount -t zfs $POOL $MNT
