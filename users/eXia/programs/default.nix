{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  ### Programs ###

  programs.obs-studio = {
    enable = true;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "SpaceMono Nerd Font:size=10";
        pad = "12x12";
      };
      colors = {
        alpha = 0.78;
      };
    };
  };

  programs.gnome-terminal = {
    enable = false;
    showMenubar = false;
    profile."642ab23b-1a4b-488a-872d-f3eeb408ebeb" = {
      visibleName = "Default";
      default = true;
      font = "SpaceMono Nerd Font 10";
      transparencyPercent = 40;
    };
  };

  programs.librewolf = {
    #enable = true;
  };
}
