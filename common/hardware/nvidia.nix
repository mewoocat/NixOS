{
  config,
  lib,
  pkgs,
  ...
}: {
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"]; # or "nouveau"

  nixpkgs = {
    config.nvidia.acceptLicense = true;
  };

  environment = {
    # What is this even doing?
    /*
    etc = {
      "modprobe.d/nvidia.conf" = {
        text = "options nvidia NVreg_RegistryDwords=\"PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3\"";
      };
    };
    */
  };

  boot.kernelParams = [
    # (doesn't seem to help) Graphical corruption and system crashes on suspend/resume fix
    #"nvidia.NVreg_TemporaryFilePath=/var/tmp"

    # Seems to cause suspend to fail to start
    #"nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  powerManagement.enable = true;

  hardware.nvidia = {
    # Modesetting (kernel mode setting / kms) is required for Wayland.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Often required for sleep/suspend to work
    # INFO: This fixes suspend on gtx 1080
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #package = config.boot.kernelPackages.nvidiaPackages.beta;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580; # For GTX 1080 support
  };
}
