{ config, pkgs, lib, inputs, ... }: let
    #flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

    #hyprland = (import flake-compat {
    # src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
    #}).defaultNix;

      # Shell scripts
  #what = pkgs.writeShellScriptBin "lockScreen2" ''exec ${pkgs.gtklock}/bin/gtklock'';
  what = import ./scripts/lockScreen.nix { inherit pkgs; };
  
   huh = pkgs.writeShellScriptBin "lockScreen3" ''
        echo "what";
        ${pkgs.gtklock}/bin/gtklock;
    '';

in

{
  imports = [
    #hyprland.homeManagerModules.default
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "exia";
  home.homeDirectory = "/home/exia";

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
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
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

    git
    #neovim
    vim
    kitty
    firefox
    obsidian

    # File managers
    #cinnamon.nemo
    #gnome.nautilus
    #cinnamon.nemo-with-extensions

    xfce.thunar
    deepin.dde-file-manager

    
    #gvfs # for network file browsing
    #cifs-utils # for 3ds file system?
    
    webcord
    #obs-studio
    onlyoffice-bin
    acpi
    lm_sensors
    neofetch
    htop
    light
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
    eww-wayland
    glib
    gsettings-desktop-schemas # Don't need?
    gnome.nixos-gsettings-overrides

    shotman

    pywal

    #killall?
    jaq
    gojq
    socat
    ripgrep
    jq
    bc

    liberation_ttf
    arkpandora_ttf

    apple-cursor

    gnome.gucharmap
    #rofi
    wpgtk
    #lxappearance-gtk2
    #themechanger
  
    hyfetch
    vlc
    coreutils

    steam

    qdirstat
    #themechanger
    qalculate-gtk

    gamescope
    wlsunset

    #alsa-lib
    #alsa-plugins 
    #alsa-utils

    #libsForQt5.okular
    libreoffice

    mgba
    xournalpp

    tor-browser-bundle-bin
    #virtualbox # Installing vbox here causes the permissions not to work 

    #xdg-desktop-portal-hyprland # not needed?
    #obs-studio-plugins.wlrobs

    gcc

    # Some programs may crash without a notification daemon running
    dunst

    vscodium
    #vscode

    inkscape

    fontforge-gtk
  ];

  # Activation scripts 
  home.activation = {
  #Doesn'tWork.. Read home manager on home.activation 
  #    initTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #      /home/exia/myNixOSConfig/home-manager/theme_bird/theme.sh -D /home/exia/Downloads/apple-imac-colorful-stock-retina-display-gradients-7680x3753-2278.jpg
  #
  #  '';
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

   ".config/kitty".source = ./kitty; 
   ".config/nvim".source = ./nvim;
   ".config/hypr".source = ./hypr;
   ".config/eww".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/myNixOSConfig/home-manager/eww";
   ".config/tmux".source = ./tmux;

   # Add .themes dir with gtk theme


   ## Need to manually create .local/bin? 
   #".local/bin/lockScreen.sh" = {
   #  executable = true;
   #  recursive = true;
   #  source = ./scripts/lockScreen.sh;
   #};

  };


#    lockScreenVar = stdenv.mkDerivation rec {
#      name = "lockScreenName";
#      # disable unpackPhase etc
#      phases = "buildPhase";
#      builder = ./scripts/lockScreen.sh;
#      nativeBuildInputs = [ gtklock ];
#      PATH = lib.makeBinPath nativeBuildInputs;
#    };



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
  };



    #programs.eww = {
    #    enable = true;
    #    #configDir = ./eww;
    #    package = pkgs.eww-wayland;
    #};

    #programs.steam.enable = true;

  # export GSETTINGS_SCHEMA_DIR=/nix/store/hqd68mpllad47hjnhgnqr6zqcrsi3dsz-gnome-gsettings-overrides/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/;
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ~/.bashrc_backup
      export GSETTINGS_SCHEMA_DIR=/nix/store/hqd68mpllad47hjnhgnqr6zqcrsi3dsz-gnome-gsettings-overrides/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/;
    '';
  };
  
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
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
        #inputs.anyrun.packages.${pkgs.system}.shell
        #inputs.anyrun.packages.${pkgs.system}.dictionary
        #inputs.anyrun.packages.${pkgs.system}.kidex
        #inputs.anyrun.packages.${pkgs.system}.rink
        #./some_plugin.so
        #"${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/kidex"

      ];
      width = { fraction = 0.3; };
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
        margin-top: 100px;
        padding: 16px;
        border-radius: 18px;
        background-color: rgba(0,0,0,0.9);
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



# GTK Config
gtk = {
      enable = true;
      theme = {
        #name = "default";
        
        name = "WhiteSur-Dark";
        package = pkgs.whitesur-gtk-theme;
      };
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




  # From: https://www.reddit.com/r/NixOS/comments/nxnswt/cant_change_themes_on_wayland/
  # Doesn't fix gsettings schema issue?
  #xdg.systemDirs.data = [
  #  "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  #  "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  #]; 

    # start swayidle as part of hyprland, not sway
    systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

    services.swayidle = {
      enable = true; 
      package = pkgs.swayidle;
      #systemdTarget = "basic.target";
      #extraArgs = [ pkgs ];
      events = let
        lock = (pkgs.writeShellScriptBin "my-hello" ''
            wallpaper=$(${pkgs.coreutils}/bin/cat ~/.config/wallpaper);
            ${pkgs.gtklock}/bin/gtklock -t "%l:%M %P" -b $wallpaper;
            #${pkgs.gtklock}/bin/gtklock -t "%l:%M %P";
        '');

      in
      [
        #{ event = "before-sleep"; command = "${pkgs.gtklock}/bin/gtklock"; }
        #{ event = "before-sleep"; command = "${pkgs.gtklock}/bin/gtklock -t \"%l:%M %P\""; }
        #{ event = "before-sleep"; command = "${pkgs.my-hello}/bin/my-hello"; }
        { event = "before-sleep"; command = "${lock}/bin/my-hello"; }

      ];
    };


    services.udiskie = {
        enable = true;
        automount = true;
        tray = "never";
    };

    wayland.windowManager.hyprland = {
        enable = true;
        xwayland.hidpi = true;
        #extraConfig = ''  '';
      };


}
