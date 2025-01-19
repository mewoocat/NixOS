{
  config,
  pkgs,
  inputs,
  ...
}: {

  imports = [
    inputs.hyprland.nixosModules.default # Use hyprland nixos module from hyprland flake
  ];
  
  systemd.tmpfiles.rules = [
    "L+ /home/${config.username}/.config/hypr/hyprland.conf - - - - ${./hyprland.conf}"
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    portalPackage = inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
    withUWSM = true;
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];
  };

  users.users.${config.username}.packages = with pkgs; [
    xorg.xrandr # For xwayland
  ];

}
