#!/bin/sh

POOL="TestPool"

sync # Synchronize cached writes to persistent storage
sudo umount -t zfs $POOL # Unmount dataset
sudo zpool export $POOL
