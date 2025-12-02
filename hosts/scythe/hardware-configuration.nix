{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix") # TODO: what does this do?
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [
    "kvm-intel"
    "i2c-dev" # For openrgb
    #"i2c-i801" # Also for openrgb (Not sure if needed)
  ];
  boot.extraModulePackages = [];
  boot.kernelParams = [
    #"quiet"
    "button.lid_init_state=open"
    "intel_idle.max_cstate=1"

    #"pcie_port_pm=off" # Fix for unstable thunderbolt connection (no fix?)
    "thunderbolt.d3cold=0" # Fix for unstable thunderbolt connection
    "pcie_port_pm=off"
    "pcie_aspm.policy=performance"

  ];

  boot.kernelPackages = pkgs.linuxPackages_6_17;

  systemd.tpm2.enable = false; # Having this enabled on this host causes a 1.5 min wait at boot

  # Disable device
  # idVendor and idProduct can be found by `cat /proc/bus/input/devices`
  # Disable touchscreen
  #services.udev.extraRules = "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"04f3\", ATTRS{idProduct}==\"223c\", ATTR{authorized}=\"0\"";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/cb414339-cb4f-4c62-90ac-a9f9732ed657";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2910-1A24";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/67a3a7da-1ffb-4b45-a4cf-c74fc86bbfcb";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Unstable
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Undervolting
  #
  # Note: that only enabling this service without any other options set 
  #       will cause the service to fail to start.  Add an option to remedy this.
  #
  # Note: There is a 2 min timeout before the undevolts are applied at boot. 
  #       This allows for a grace period to disable a configuration that results
  #       in a crash.
  #
  # Note: Disabled for now since the 2 min grace period doesn't appear to work.
  services.undervolt = {
    enable = false;
    coreOffset = -100;
    gpuOffset = -100;
    analogioOffset = -100;
    uncoreOffset = -100;
  };
  
}
