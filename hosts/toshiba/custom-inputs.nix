{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {

  home-manager.users.${config.username} = {
    wayland.windowManager.hyprland = {
      # Use different input for hyprland
      #package = lib.mkForce inputs.hyprland-wlr.packages."${pkgs.system}".hyprland;
      package = lib.mkForce inputs.hyprland-0-45-2.packages."${pkgs.system}".hyprland;
    };
  };
}
