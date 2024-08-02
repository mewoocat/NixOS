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
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  home-manager.users.${config.username}.home.packages = with pkgs; [
    # Games
    mgba
  ];
}
