{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let


in {
  imports = [
    ./programs/default.nix
    ./programs/firefox
    ./programs/bash.nix
    ./programs/zellij
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "eXia";
  home.homeDirectory = "/home/eXia";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  # Activation scripts
  home.activation = {
    #Read home manager on home.activation
  };

  # Dotfiles
  home.file = {
    ".config/kitty".source = ./programs/kitty;
    ".config/tmux".source = ./programs/tmux;
    ".config/btop/btop.conf".source = ./programs/btop/btop.conf;
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "firefox"; # Not sure if this works
  };


  # XDG
  xdg.desktopEntries = {
    obsidian = {
      name = "Obsidian :)";
      exec = "obsidian --disable-gpu %u";
      categories = ["Office"];
      comment = "Knowledge base";
      icon = "obsidian";
      mimeType = ["x-scheme-handler/obsidian"];
      type = "Application";
    };

    webcord = {
      name = "Webcord :)";
      exec = "webcord --disable-gpu";
      categories = ["Network" "InstantMessaging"];
      comment = "A Discord and SpaceBar electron-based client implemented without Discord API";
      icon = "webcord";
      type = "Application";
    };

    vesktop = {
      name = "Vesktop :)";
      exec = "vesktop --disable-gpu";
      categories = ["Network" "InstantMessaging" "Chat"];
      icon = "vesktop";
      type = "Application";
    };
  };

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "image/png" = ["org.gnome.gThumb.desktop"];
    "image/jpeg" = ["org.gnome.gThumb.desktop"];
    "video/mp4" = ["org.gnome.gThumb.desktop;"];
    "application/pdf" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
    "text/markdown" = ["l3afpad.desktop"];
    "text/plain" = ["l3afpad.desktop"];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # Fix for obsidian using electron 25 which is EOL
  ];

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = with pkgs; [
    cmakeMinimal
    lynx
    tmux
    blueberry
    nmap
    glow
    openrgb-with-all-plugins
    hyfetch
    htop
    evince # Gnome PDF viewer
    blueman

    # Programs
    obsidian
    vesktop
    #onlyoffice-bin
    gnome.gucharmap
    inkscape
    gimp
    #fontforge-gtk
    #xournalpp
    tor-browser-bundle-bin
    nextcloud-client
    #bottles
    qdirstat
    ascii-image-converter
    gh
    vial
    l3afpad
    rhythmbox
    bookworm
    spotifywm
    spotify-tray
    nwg-displays
    wlr-randr
    nwg-look
    gradience
    openvpn
    zoxide
    blanket

    inputs.myNvim.packages.x86_64-linux.default

    # Testing out
    niri
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.
}
