{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  programs.steam = {
    enable = true;
    # add extra compatibility tools to your STEAM_EXTRA_COMPAT_TOOLS_PATHS
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  # Enable SteamOS like experience
  # This host doesn't support vulken (i5-2435M)
  # gamescope fails to launch with "[gamescope] [Error] vulkan: physical device doesn't support VK_EXT_physical_device_drm"
  # Also see https://github.com/Jovian-Experiments/Jovian-NixOS/issues/512
  /*
  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      user = "eXia";
      desktopSession = "plasma";
    };
    devices.steamdeck.enableVendorDrivers = false;
    hardware.has.amd.gpu = false;
  };
  */

  # Unstable
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

}
