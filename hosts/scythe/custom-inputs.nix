{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {

  # Fixes hyprland crash on startup
  # Fix mesa version mismatch
  # This uses mesa from hyprland's nixpkgs input
  hardware.opengl = {
    package = lib.mkForce inputs.hyprland-laptop.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.mesa.drivers;
  };


  home-manager.users.${config.username} = {
    wayland.windowManager.hyprland = {
      # Use different input for hyprland
      #package = lib.mkForce inputs.hyprland.packages."${pkgs.system}".hyprland;
      package = lib.mkForce inputs.hyprland-laptop.packages."${pkgs.system}".hyprland;
    };
  };
}
