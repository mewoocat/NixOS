{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
in {
  imports = [
    ./bash.nix
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
    #".config/btop/btop.conf".source = ./programs/btop/btop.conf;
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "firefox"; # Not sure if this works
  };

  # XDG
  xdg.desktopEntries = {

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

  home.packages = with pkgs; [
    vscodium
    bottom
  
    blueberry
    hyfetch
    htop
    evince # Gnome PDF viewer
    blueman


    nmap
    glow
    cmakeMinimal
    tmux
    ascii-image-converter
    gh
    zoxide
    openvpn

    # Programs
    vesktop
    inkscape
    gimp
    blanket
    l3afpad
    rhythmbox
    bookworm
    spotifywm spotify-tray
    vial


    qdirstat
    gnome.gucharmap

    inputs.myNvim.packages.x86_64-linux.default
    inputs.microfetch.packages.x86_64-linux.default
    
    brasero
    #teams-for-linux # Borked
    ungoogled-chromium

    #gradience
    #niri
    #lynx
    #nwg-displays
    #wlr-randr
    #nwg-look
    #fontforge-gtk
    #xournalpp
    #bottles
    #onlyoffice-bin
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
