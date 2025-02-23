# Example to create a bios compatible gpt partition
{ ... }:
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/wwn-0x50026b76827f43b4";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}


/*
# Copied from: https://github.com/nix-community/nixos-anywhere-examples/blob/main/disk-config.nix
# Example to create a bios compatible gpt partition
{ lib, ... }:
{
  disko.devices = {
    disk.disk1 = {
      #device = lib.mkDefault "/dev/sda";
      #device = lib.mkDefault "/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B76827F43B4";
      #device = lib.mkDefault "/dev/disk/by-id/ata-WDC_WD10EADS-65L5B1_WD-WCAU4A946314";
      device = "/dev/disk/by-id/wwn-0x50026b76827f43b5";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "pool";
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
*/

/*
{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B76827F43B4";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}

*/


/*
{ lib, ... }:
{
  disko.devices = {
    disk.disk1 = {
      #device = lib.mkDefault "/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B76827F43B4";
      #device = lib.mkDefault "/dev/disk/by-id/ata-WD_Blue_SA510_2.5_500GB_241805A003EB";
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
*/
