
{ config, pkgs, lib, inputs, ... }:
{
    
  ### Programs ###

  programs.vscode = {
    enable = true;
    extensions = with pkgs; [
      #vscode-extensions.cmschuetz12.wal 
      vscode-extensions.bbenoist.nix
      vscode-extensions.vscodevim.vim
    ];

    userSettings = {
      "window.titleBarStyle" = "custom";      # Fixes crash on startup
      "workbench.colorTheme" = "Wal Bordered";         # Set theme
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = [ pkgs.obs-studio-plugins.wlrobs ];
  };

  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        # An array of all the plugins you want, which either can be paths to the .so files, or their packages
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun.packages.${pkgs.system}.shell
        inputs.anyrun.packages.${pkgs.system}.dictionary
        #inputs.anyrun.packages.${pkgs.system}.kidex
        #inputs.anyrun.packages.${pkgs.system}.rink
        #./some_plugin.so
        #"${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/kidex"

      ];
      width = { fraction = 0.3; };
      #height = { fraction = 0.4; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = true;
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = 12;

      # Options no longer exist?
      #position = "top";
      #verticalOffset = { absolute = 10; };
      
    };
    extraCss = '' 

      #entry {
        margin-top: 48px;
        padding: 16px;
        border-radius: 18px;
        background-color: rgba(0,0,0,0.6);
      }

      #window {
        background: transparent;
      }

    '';

    extraConfigFiles."applications.ron".text = ''
      // Also show the Desktop Actions defined in the desktop files, e.g. "New Window" from LibreWolf
      desktop_actions: false,
      max_entries: 10, 
      // The terminal used for running terminal based desktop entries, if left as `None` a static list of terminals is used
      // to determine what terminal to use.
      terminal: Some("kitty"),
    )

    '';

  };

  programs.ags = {
    enable = true;

    # null or path, leave as null if you don't want hm to manage the config
    #configDir = ../ags;

    # additional packages to add to gjs's runtime
    extraPackages = [  ];
  };
  
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
  };


  programs.nixvim = {
    enable = false;
  };
}