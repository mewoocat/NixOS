#obsidian
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Causes random xorg display manager to show on boot and login no worky
  #services.xserver.enable = true;
  #services.xserver.videoDrivers = ["amdgpu"];

  # Enable OpenGL
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Unstable version of OpenGL
  /*
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  */

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];

  boot.kernelModules = [
    "kvm-amd"
    "i2c-dev" # For openrgb
  ];
  boot.extraModulePackages = [];
  boot.kernelParams = ["quiet"];

  networking.hostName = "obsidian"; # Define your hostname.

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0737052e-e75f-40d2-8b85-728aaf24564b";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C142-122B";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/b6e54efd-7622-40cc-85f5-133f24e6d24c";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
