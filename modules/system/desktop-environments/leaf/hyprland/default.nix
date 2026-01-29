{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default # Use hyprland nixos module from hyprland flake
  ];
 
  hjem.users.${config.username}.files = {
    
    ".config/hypr/hyprland.conf" = {
      clobber = true;
      #source = ./hyprland.conf;
      # For development
      source = "/home/${config.username}/NixOS/modules/system/desktop-environments/leaf/hyprland/hyprland.conf";
    };
    
    # To load the plugins when hyprland starts
    ".config/hypr/nixManaged.conf" = {
      clobber = true;
      #text = '''';
      text = ''
        plugin = ${inputs.hyprland-plugins.packages.${config.hostSystem}.hyprbars}/lib/libhyprbars.so
        exec-once = hyprctl plugin load ${inputs.hyprland-plugins.packages.${config.hostSystem}.hyprbars}/lib/libhyprbars.so
      '';
        /*
        #plugin = ${inputs.Hyprspace.packages.${config.hostSystem}.Hyprspace}/lib/libHyprspace.so
        #exec-once = hyprctl plugin load ${inputs.Hyprspace.packages.${config.hostSystem}.Hyprspace}/lib/libHyprspace.so
        */
    };
  };

  programs.hyprland = {
    enable = true;
    #package = inputs.hyprland.packages."${config.hostSystem}".hyprland;
    #portalPackage = inputs.hyprland.packages."${config.hostSystem}".xdg-desktop-portal-hyprland;
    withUWSM = true;
    # This adds "plugin = ..." to /etc/xdg/hypr/hyprland.conf
    # However having the plugin value set here doesn't seem to work
    # Manully adding it to the main config file above
    plugins = [
      inputs.hyprland-plugins.packages.${config.hostSystem}.hyprbars
      #inputs.Hyprspace.packages.${config.hostSystem}.Hyprspace
    ];
  };

  users.users.${config.username}.packages = with pkgs; [
    xorg.xrandr # For xwayland
  ];

}
