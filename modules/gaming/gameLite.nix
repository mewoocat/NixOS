{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  programs.steam = {
    enable = true;
    # add extra compatibility tools to your STEAM_EXTRA_COMPAT_TOOLS_PATHS
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  # Required for steam to run?

  # Unstable
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # 24.04
  /*
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  */

  users.users.${config.username}.packages = with pkgs; [
    mgba
  ];
}
