{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {

  systemd.tmpfiles.rules = [
    "L+ /home/${config.username}/.config/hypr/hyprland.conf - - - - ${./hyprland.conf}"
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    portalPackage = inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
  };

  users.users.${config.username}.packages = with pkgs; [
    xorg.xrandr # For xwyaland
  ];

  /*
  home-manager.users.${config.username} = {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      plugins = [
        #inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
        #inputs.hycov.packages.${pkgs.system}.hycov
        #inputs.hyprspace.packages.${pkgs.system}.Hyprspace # Fails to load on my "working" flake.lock
      ];

      extraConfig = builtins.readFile ./hyprland.conf;
    };
  };
  */
}
