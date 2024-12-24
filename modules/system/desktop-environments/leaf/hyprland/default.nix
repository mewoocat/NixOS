{
  config,
  pkgs,
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
    xorg.xrandr # For xwayland
  ];

}
