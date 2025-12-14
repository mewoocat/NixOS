# Disk & File System

Using ZFS for both the file system and logical volume management.  Configured in a Raid-1 (RaidZ-MIRROR) configuration.

## Setup

nixos configuration
```
  boot.supportedFilesystems = [ "zfs" ]; # also enables boot.zfs
  boot.zfs.forceImportRoot = false; # enabling this helps with compatibility but limits safeguards zfs uses
  networking.hostId = "d01ce9f7"; # ensure when using ZFS that a pool isn’t imported accidentally on a wrong machine
```

imperative configuration to create the pool and mirror two drives
```sh
zpool create \
    -o ashift=12 \
    -O recordsize=1M \
    -O atime=off \
    -O compression=lz4 \
    -O xattr=sa \
    -O acltype=posixacl \
    -O dnodesize=auto \
    -O normalization=formD \
    -O mountpoint=none \
    zpool \
    mirror \
    /dev/sda \
    /dev/sdb
```
more info 
```
    -o ashift=12 \# Set block size in bits 
    -o xattr=sa \ # Store Linux eXtended Attributes in inodes rather than files (performance improvement when lots of little files)
    -o compression=lz4 \ # Enable compression (very fast)
    -o atime=off \ # Disable accessed time for files (performance improvement)
    -o recordsize=1M \ # More ideal for mostly reading/writing large chunks
    -O acltype=posixacl \
    -O dnodesize=auto \
    -O normalization=formD \
    -O mountpoint=none \ # Prevents auto mounting
```

## Resources
- https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/
- https://blog.tiserbox.com/posts/2024-02-09-zfs-on-nix-os.html
- https://blog.victormendonca.com/2020/11/03/zfs-for-dummies/
