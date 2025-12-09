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

    extraPackages = [
    ];
  };

  # Required for steam to run?

  # Unstable
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

}
