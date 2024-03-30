{ config, pkgs, lib, inputs, ... }: let
  # Shell scripts
  #what = pkgs.writeShellScriptBin "lockScreen2" ''exec ${pkgs.gtklock}/bin/gtklock'';
  what = import ./scripts/lockScreen.nix { inherit pkgs; }; 
  huh = pkgs.writeShellScriptBin "lockScreen3" ''
        echo "what";
        ${pkgs.gtklock}/bin/gtklock;
        '';
  nvimConfig = import ./nixvim.nix;
in

{
  imports = [
    inputs.ags.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
    
    programs/bash.nix
    programs/hyprland.nix
    ./nvim
 ];

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = (pkg: true);
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0" # Fix for obsidian using electron 25 which is EOL
      "electron-19.1.9" # For balena etcher
    ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "eXia";
  home.homeDirectory = "/home/eXia";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    (pkgs.writeShellScriptBin "my-hello" ''
        ${pkgs.gtklock}/bin/gtklock
    '')

    # Core
    git
    vim
    lunarvim
    kitty
    firefox
    floorp
    #xfce.thunar
    cinnamon.nemo-with-extensions
    #gnome.nautilus
    neofetch hyfetch
    htop
    vlc
    #steam
    qalculate-gtk
    gnome.eog
    #gnome.gnome-disk-utility

    # Programs
    obsidian
    webcord
    vesktop
    onlyoffice-bin
    gnome.gucharmap
    #vscodium
    inkscape
    gimp
    fontforge-gtk
    mgba
    xournalpp
    tor-browser-bundle-bin
    nextcloud-client
    bottles
    qdirstat
    ascii-image-converter 
    
    # Appearance
    liberation_ttf
    arkpandora_ttf
    apple-cursor

    # Components + utilities
    #coreutils # Collision with busybox 
    acpi                # Battery
    lm_sensors          # 
    #light
    brightnessctl
    bluez
    swww
    wirelesstools
    pipewire
    pulseaudio
    alsa-utils
    pamixer
    pavucontrol
    gtklock
    swayidle
    wl-clipboard
    glib
    #gsettings-desktop-schemas # Don't need?
    gnome.nixos-gsettings-overrides # This is used instead
    sway-contrib.grimshot
    pywal
    jaq
    gojq
    socat
    ripgrep
    jq
    bc
    wlsunset
    #gcc # Enabling this causes collision with busybox  
    #dunst # Some programs may crash without a notification daemon running
    unzip
    gvfs # for network file browsing
    openrgb-with-all-plugins
    busybox
    nmap


    # Unsorted
    blueberry
    p7zip
    cantarell-fonts
    sassc # For ags
    vial

    spotify
    btop
    
    l3afpad

    gthumb
    zoxide
    tmux

    #inputs.matugen.packages.x86_64-linux.default

    # Gui display settings
    nwg-displays
    wlr-randr
    nwg-look
    gradience

    openvpn
    fastfetch

    gnome.gnome-calendar

    inputs.self.packages.x86_64-linux.nvim # Install nvim package exported in flake


  ];

  # Activation scripts 
  home.activation = {
    #Read home manager on home.activation 
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

   ".config/kitty".source = ./kitty; 
   ".config/ags".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixOS/home-manager/ags";
   ".config/tmux".source = ./tmux;
   ".config/matugen".source = ./matugen;
   ".config/btop".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixOS/home-manager/programs/btop";
   ".config/lvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixOS/home-manager/lvim";

   # Themes
   ".local/share/themes/adw-gtk3".source = ./theme/adw-gtk3;
   ".local/share/themes/adw-gtk3-dark".source = ./theme/adw-gtk3-dark;

  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/exia/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
    # Set wayland flags
    # Doesn't work?
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER="wayland";
    QT_QPA_PLATFORM="wayland;xcb";
    DEFAULT_BROWSER = "firefox"; # Doesn't seem to work
  };


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




  # Services

  # start as part of hyprland, not sway
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
  services.swayidle = {
    enable = true; 
    package = pkgs.swayidle;
    #systemdTarget = "basic.target";
    #extraArgs = [ pkgs ];
    events = let
      lock = (pkgs.writeShellScriptBin "my-hello" ''
          wallpaper=$(${pkgs.coreutils}/bin/cat ~/.config/wallpaper);
          ${pkgs.gtklock}/bin/gtklock -i -t "%l:%M %P" -b $wallpaper;
      '');

    in
    [
      { event = "before-sleep"; command = "${lock}/bin/my-hello"; }

    ];
  };

  services.udiskie = {
      enable = true;
      automount = true;
      tray = "never";
  };

  # GTK Config
  gtk = {
    enable = true;
    #theme = {
    #  #name = "adw-gtk3";  
    #  name = "WhiteSur-Dark";
    #  package = pkgs.whitesur-gtk-theme;
    #};
    cursorTheme = {
      name = "macOS-BigSur";
      package = pkgs.apple-cursor;
      size = 24;
    };
    iconTheme = {
    	name = "kora";
      package = pkgs.kora-icon-theme;
    };
  };

  # QT Config (BROKEN)
  #qt = {
  #  enable = true;
  #  platformTheme = "gtk";
  #  style = {
  #    package = pkgs.adwaita-qt;
  #    name = "adwaita-dark";
  #  };
  #};


  # XDG
  xdg.desktopEntries = {
    obsidian = {
      name = "Obsidian :)";
      exec = "obsidian --disable-gpu %u";
      categories = [ "Office" ];
      comment = "Knowledge base";
      icon = "obsidian";
      mimeType = [ "x-scheme-handler/obsidian" ];
      type = "Application";
    };

    webcord = {
      name = "Webcord :)";
      exec = "webcord --disable-gpu";
      categories = [ "Network" "InstantMessaging" ];
      comment = "A Discord and SpaceBar electron-based client implemented without Discord API";
      icon = "webcord";
      type = "Application";
    };

    vesktop = {
      name = "Vesktop :)";
      exec = "vesktop --disable-gpu";
      categories = [ "Network" "InstantMessaging" "Chat" ];
      icon = "vesktop";
      type = "Application";
    };
  };

  # These are the applications that were in .config/mimeapps.list before HM started managing them
  /*
    [Default Applications]
    image/jpeg=org.gnome.eog.desktop
    application/x-zerosize=org.gnome.eog.desktop
    image/png=org.gnome.eog.desktop
    application/zip=org.freedesktop.Xwayland.desktop
    text/plain=l3afpad.desktop

    [Added Associations]
    image/jpeg=code.desktop;gimp.desktop;org.gnome.eog.desktop;
    video/mp4=org.gnome.gThumb.desktop;vlc.desktop;org.gnome.eog.desktop;
    application/x-zerosize=gimp.desktop;org.gnome.eog.desktop;
    application/x-theme=l3afpad.desktop;
    image/png=org.gnome.eog.desktop;
    application/zip=org.freedesktop.Xwayland.desktop;
    text/markdown=l3afpad.desktop;
    text/plain=l3afpad.desktop;

  */

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  # Not needed?
  /*
  xdg.mimeApps.associations.added = {
    "text/html" = "firefox";
    "x-scheme-handler/http" = "firefox";
    "x-scheme-handler/https" = "firefox";
    "x-scheme-handler/about" = "firefox";
    "x-scheme-handler/unknown" = "firefox";
  };
  */
  xdg.mimeApps.defaultApplications = {

    # Set default browser 
    # Not sure if this is working
    "text/html" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
    "x-scheme-handler/about" = ["firefox.desktop"];
    "x-scheme-handler/unknown" = ["firefox.desktop"];
    "application/x-extension-htm" = ["firefox.desktop"];
    "application/x-extension-html" = ["firefox.desktop"];
    "application/x-extension-shtml" = ["firefox.desktop"];
    "application/x-extension-xht" = ["firefox.desktop"];
    "application/x-extension-xhtml" = ["firefox.desktop"];
    "application/xhtml+xml" = ["firefox.desktop"];
    "x-scheme-handler/ftp" = ["firefox.desktop"];
  };

}
