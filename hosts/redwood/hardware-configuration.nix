{ config, lib, pkgs, modulesPath, ... }: {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # This system has been configured using zfs
  #
  # The datasets in main pool are configured as mountpoint=none (i think).
  # Seems like configuration with mountpoint=legacy would work just as fine.
  # 
  # Disable zfs auto mounting since we're specifying the drives here.  Or remove the fileSystems entries.
  # Disabling zfs-mount allows us to specify mountpoints with the nixos fileSystems option but use a non legacy
  # mountpoint.
  # See: wiki.nixos.org/wiki/ZFS
  systemd.services.zfs-mount.enable = false;

  # Auto import pools on boot 
  boot.zfs.extraPools = [ "main" "StoragePool" ];
  
  # Avoid potential issues with disk ids if pool was create via /dev/disk/by-id
  boot.zfs.devNodes = "/dev/disk/by-id";

  #services.zfs.autoScrub.enable = true;
  #services.zfs.trim.enable = true;
 
  # ZFS filesystems (datasets)
  #
  # "zfsutil" is needed for non legacy mountpoints (i.e. none or /path/to/mountpoint)
  # If using legacy mountpoints, then the "zfsutil" option must not be used.
  # See: https://discourse.nixos.org/t/decrypting-zfs-pools-over-ssh-on-26-05/77828/9
  fileSystems."/" =
    { device = "main/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/nix" =
    { device = "main/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var" =
    { device = "main/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home" =
    { device = "main/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  # This dataset has zfs mountpoint set to none, just like the above ^
  fileSystems."/srv/Storage" =
    { device = "StoragePool";
      fsType = "zfs";
      options = [ "zfsutil" ];

      # Don't use "zfsutil" if this filesystem has a legacy mountpoint
      #options = [  ];
      # Cause this filesystem to be mounted in stage 1 of boot, which allows for remote unlocking via the same
      # `systemctl default` from ssh client.

      # Ideally, you don't unlock non essential filesystems during stage 1 and instead perform in stage 2 by setting 
      # a keyfile location on the main root encypted drive that can be used once root is mounted and decrypted in stage 1.
      # handle 
      # See: https://discourse.nixos.org/t/decrypting-zfs-pools-over-ssh-on-26-05/77828/2
      neededForBoot = true;
    };

  # Boot filesystem
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/43D9-B6C6";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-partuuid/e8cb929c-0ad6-4af1-b43f-8e016968a40a";
	randomEncryption = true;  # Encrypted with a random secret on each boot
	}
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
