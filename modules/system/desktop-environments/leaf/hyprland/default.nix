{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.hyprland.enable = true;

  users.users.${config.username}.packages = with pkgs; [
    xorg.xrandr # For xwyaland
  ];

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
}
