{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  ### Programs ###
  programs.git = {
    enable = true;
    extraConfig = {
      credential.helper = "${
        pkgs.git.override {withLibsecret = true;}
      }/bin/git-credential-libsecret";
    };
  };

  programs.vscode = {
    enable = true;

    /*
    extensions = with pkgs; [
      #vscode-extensions.cmschuetz12.wal
      vscode-extensions.bbenoist.nix
      vscode-extensions.vscodevim.vim
    ];

    userSettings = {
      "window.titleBarStyle" = "custom";      # Fixes crash on startup
      #"workbench.colorTheme" = "Wal Bordered";         # Set theme
    };
    */
  };

  programs.obs-studio = {
    enable = true;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };

  programs.ags = {
    enable = true;

    # null or path, leave as null if you don't want hm to manage the config
    #configDir = ../ags;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      gtk-session-lock
      #coreutils # For date
    ];
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
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
