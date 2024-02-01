{ config, pkgs, lib, inputs, ... }: let
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
    inputs.ags.homeManagerModules.default
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
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # Fix for obsidian using electron 25 which is EOL
  ];

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
    kitty
    firefox
    #xfce.thunar
    #cinnamon.nemo-with-extensions
    neofetch hyfetch
    htop
    vlc
    steam
    qalculate-gtk
    gnome.eog
    gnome.gnome-disk-utility

    # Programs
    obsidian
    webcord
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
    eww-wayland
    glib
    gsettings-desktop-schemas # Don't need?
    gnome.nixos-gsettings-overrides
    sway-contrib.grimshot
    pywal
    jaq
    gojq
    socat
    ripgrep
    jq
    bc
    gamescope
    wlsunset
    #gcc # Enabling this causes collision with busybox  
    #dunst # Some programs may crash without a notification daemon running
    unzip
    gvfs # for network file browsing
    openrgb-with-all-plugins
    busybox
    nmap

    # Games
    duckstation
    #retroarchFull # Error building

    # Unsorted
    blueberry
    dolphin-emu
    p7zip
    cantarell-fonts
    sassc
    vial
    (lutris.override {
       extraPkgs = pkgs: [
         # List package dependencies here
         wine
       ];
    })

    xonotic
    

    # Inactive
    #cifs-utils # for 3ds file system?
    #wpgtk
    #alsa-lib
    #alsa-plugins 
    #alsa-utils
    #xdg-desktop-portal-hyprland # not needed?
    #obs-studio-plugins.wlrobs


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

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

   ".config/kitty".source = ./kitty; 
   ".config/nvim".source = ./nvim;
   ".config/hypr".source = ./hypr;
   ".config/eww".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixOS/home-manager/eww";
   ".config/ags".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixOS/home-manager/ags";
   ".config/tmux".source = ./tmux;
   # Add .themes dir with gtk theme

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
  };


  # Programs



  # export GSETTINGS_SCHEMA_DIR=/nix/store/hqd68mpllad47hjnhgnqr6zqcrsi3dsz-gnome-gsettings-overrides/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/;
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      #. ~/.bashrc_backup -> this is what's below (testing)
      # Note: two single quotes escapes $ { ... }
      ######################################
      #
      # ~/.bashrc
      #

      # If not running interactively, don't do anything
      [[ $- != *i* ]] && return

      alias ls='ls -altr --color=auto'
      #alias rm='rm -i'

      #PS1='\e[\u@\h \W]\$ \e[m'
      export PS1="\e[0;31m[\u@\h \W]\$ \e[m "

      #######################
      RESET="\[\017\]"
      NORMAL="\[\033[0m\]"
      RED="\[\033[31;1m\]"
      YELLOW="\[\033[33;1m\]"
      WHITE="\[\033[37;1m\]"
      SMILEY="''${WHITE}:)''${NORMAL}"
      FROWNY="''${RED}:(''${NORMAL}"
      SELECT="if [ \$? = 0 ]; then echo \"''${SMILEY}\"; else echo \"''${FROWNY}\"; fi"

      # Throw it all together 
      PS1="''${RESET}''${YELLOW}\h''${RED}@''${YELLOW}\u''${NORMAL} [\T] \W \`''${SELECT}\` ''${YELLOW}>''${NORMAL} "
      #######################

      # Import colorscheme from 'wal' asynchronously
      # &   # Run the process in the background.
      # ( ) # Hide shell job control messages.
      # Not supported in the "fish" shell.
      #(cat ~/.cache/wal/sequences &)

      # Alternative (blocks terminal for 0-3ms)
      #cat ~/.cache/wal/sequences
      #


      ([ -f ~/.cache/wal/sequences ] && cat ~/.cache/wal/sequences &)

      # To add support for TTYs this line can be optionally added.
      #source ~/.cache/wal/colors-tty.sh


      # BEGIN_KITTY_SHELL_INTEGRATION
      if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
      # END_KITTY_SHELL_INTEGRATION

      export QSYS_ROOTDIR="/hom/ghost/.cache/yay/quartus-free/pkg/quartus-free-quartus/opt/intelFPGA/21.1/quartus/sopc_builder/bin"
      export PATH="/home/ghost/.local/bin":$PATH

      alias lock='/home/exia/myNixOSConfig/home-manager/scripts/lockScreen.sh'
      alias vi='nvim'
      alias tmux='tmux -2' # Makes tmux assume 256 bit colors which fixed color issue with vim within tmux

      # Fixes kitty ssh issue
      alias ssh="kitty +kitten ssh"

      # [ -f ~/.fzf.bash ] && source ~/.fzf.bash

      # Use bash-completion, if available
      #[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
      #    . /usr/share/bash-completion/bash_completion

      alias rta="~/Projects/Scripts/RandomTerminalArt.sh"

      alias f="neowofetch --backend off"

      # Run initial programs
      #neofetch


      ######################################
      # Fix for gsettings no schema
      export GSETTINGS_SCHEMA_DIR=/nix/store/hqd68mpllad47hjnhgnqr6zqcrsi3dsz-gnome-gsettings-overrides/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/;
    '';
  };

  programs.vscode = {
    enable = true;
    userSettings = {
      "window.titleBarStyle" = "custom";
    };
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
          ${pkgs.gtklock}/bin/gtklock -t "%l:%M %P" -b $wallpaper;
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


  # Window manager
  wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      ];
  };

  # XDG
  #xdg.desktopEntries.zettlr = {
  #  name = "zettlr";
  #  exec = "zettlr --disable-gpu --enable-features=UseOzonePlatform --ozone-platform=wayland";
  #};

  # GSettings setup??
  # From: https://www.reddit.com/r/NixOS/comments/nxnswt/cant_change_themes_on_wayland/
  # Doesn't fix gsettings schema issue?
  #xdg.systemDirs.data = [
  #  "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  #  "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  #]; 
}
