{config, pkgs, lib, ...}:
{
  # Window manager
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    plugins = [
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      inputs.hycov.packages.${pkgs.system}.hycov
    ];
    
    extraConfig = ''

      plugin = ${inputs.hycov.packages.${pkgs.system}.hycov}/lib/libhycov.so
      bind = ALT,tab,hycov:toggleoverview
      bind = ALT,left,hycov:movefocus,l
      bind = ALT,right,hycov:movefocus,r
      bind = ALT,up,hycov:movefocus,u
      bind = ALT,down,hycov:movefocus,d


      plugin {
          hycov {
            overview_gappo = 60 #gaps width from screen
            overview_gappi = 24 #gaps width from clients
            hotarea_size = 10 #hotarea size in bottom left,10x10
            enable_hotarea = 1 # enable mouse cursor hotarea
          }
      }
    '';
    
  };
  # Window manager
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    plugins = [
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      inputs.hycov.packages.${pkgs.system}.hycov
    ];
    
    extraConfig = ''

      plugin = ${inputs.hycov.packages.${pkgs.system}.hycov}/lib/libhycov.so
      bind = ALT,tab,hycov:toggleoverview
      bind = ALT,left,hycov:movefocus,l
      bind = ALT,right,hycov:movefocus,r
      bind = ALT,up,hycov:movefocus,u
      bind = ALT,down,hycov:movefocus,d


      plugin {
          hycov {
            overview_gappo = 60 #gaps width from screen
            overview_gappi = 24 #gaps width from clients
            hotarea_size = 10 #hotarea size in bottom left,10x10
            enable_hotarea = 1 # enable mouse cursor hotarea
          }
      }
    '';
    
  };
}