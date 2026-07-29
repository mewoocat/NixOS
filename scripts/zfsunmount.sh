#!/bin/sh

POOL="StoragePool"

sync # Synchronize cached writes to persistent storage
sudo umount -t zfs $POOL # Unmount dataset
sudo zpool export $POOL
