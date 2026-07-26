#!/bin/sh

DRIVE="/dev/disk/by-id/ata-WDC_WD40EFZZ-68CPAN0_WD-WX52DC5FWJ57-part1"
POOL="TestPool"
MNT="/mnt/TestStorage"

sudo mkdir -p $MNT
sudo zpool import -d $DRIVE $POOL
sudo zfs load-key TestPool
sudo mount -t zfs $POOL $MNT
