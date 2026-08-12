{...}: {
  #ZFS config
  boot.supportedFilesystems = [ "zfs" ]; # also enables boot.zfs
  boot.zfs.forceImportRoot = false; # Setting this to true helps with compatibility but limits safeguards zfs uses
  networking.hostId = "bc8c311b"; # ensure when using ZFS that a pool isn’t imported accidentally on a wrong machine
}
