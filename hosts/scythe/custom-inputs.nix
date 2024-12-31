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
  hyprlandOverride = inputs.hyprland.packages.${pkgs.system}.hyprland.override {
    mesa = pkgs.mesa;
  };
in {

  programs.hyprland = {
    package = lib.mkForce hyprlandOverride;
  };

}
