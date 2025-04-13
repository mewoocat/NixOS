{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default # Use hyprland nixos module from hyprland flake
  ];
  
  /*
  systemd.tmpfiles.rules = [
    "L+ /home/${config.username}/.config/hypr/hyprland.conf - - - - ${./hyprland.conf}"
  ];
  */

  hjem.users.${config.username}.files = {
    ".config/hypr/hyprland.conf" = {
      clobber = true;
      source = ./hyprland.conf;
    };
    ".config/hypr/nixManaged.conf" = {
      clobber = true;
      text = ''
        plugin = ${inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars}/lib/libhyprbars.so
      '';
    };
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    portalPackage = inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
    withUWSM = true;
    # This adds "plugin = ..." to /etc/xdg/hypr/hyprland.conf
    # However having the plugin value set here doesn't seem to work
    # Manully adding it to the main config file above
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];
  };

  users.users.${config.username}.packages = with pkgs; [
    xorg.xrandr # For xwayland
  ];

}
