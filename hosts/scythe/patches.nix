{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let 

  # Fixes hyprland crash on startup
  # Fix mesa version mismatch
  # Override the mesa package in the hyprland input to use the mesa package from the nixpkgs input
  /*
  hyprlandOverride = inputs.hyprland.packages.${config.hostSystem}.hyprland.override {
    mesa = pkgs.mesa;
  };
  */

  #pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {

  /*
  programs.hyprland = {
    #package = lib.mkForce hyprlandOverride;
  };
  */

  # fix mesa version mismatch when using hyprland v0.48.1 with nixpkgs stable 24.11
  # See: https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
  /*
  hardware.opengl = {
    package = pkgs-unstable.mesa.drivers;

    # if you also want 32-bit support (e.g for Steam)
    driSupport32Bit = true;
    package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
  };
  */

}
