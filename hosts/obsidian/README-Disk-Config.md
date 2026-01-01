# !!!! WARNING THIS IS INCOMPLETE AND NOT IN USE

# ZFS Setup

### nixos configuration
```
  boot.supportedFilesystems = [ "zfs" ]; # also enables boot.zfs
  boot.zfs.forceImportRoot = false; # enabling this helps with compatibility but limits safeguards zfs uses
  networking.hostId = "d01ce9f7"; # ensure when using ZFS that a pool isn’t imported accidentally on a wrong machine
```

### imperative configuration
create the pool for one partion
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
    /dev/sda1
```
