
{ config, pkgs, inputs, ... }: let

  # Shell scripts
  #what = pkgs.writeShellScriptBin "lockScreen2" ''exec ${pkgs.gtklock}/bin/gtklock'';
  what = import ./scripts/lockScreen.nix { inherit pkgs; }; 
  huh = pkgs.writeShellScriptBin "lockScreen3" ''
        echo "what";
        ${pkgs.gtklock}/bin/gtklock;
        '';

  # Theme packaging
  src = builtins.readFile ./programs/theme/theme.sh;
  theme = pkgs.writeShellScriptBin "theme" src;

in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # Fix for obsidian using electron 25 which is EOL
    "electron-19.1.9" # For balena etcher
  ];


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
    cinnamon.nemo-with-extensions
    neofetch hyfetch
    htop
    vlc
    qalculate-gtk
    gnome.eog
    #gnome.gnome-disk-utility

    # Programs
    obsidian
    webcord
    vesktop
    xdg-utils # needed for discord/vesktop to open web links in default browser
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
    gh
    
    # Appearance
    liberation_ttf
    arkpandora_ttf
    apple-cursor

    # Components + utilities
    coreutils # Collision with busybox 
    acpi                # Battery
    lm_sensors          # 
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
    gnome.nixos-gsettings-overrides # For gsettings theming
    sway-contrib.grimshot
    pywal
    jaq
    gojq
    socat
    ripgrep
    jq
    bc
    wlsunset
    unzip
    gvfs # for network file browsing
    openrgb-with-all-plugins
    #busybox
    nmap
    dig

    # AGS
    sassc
    wf-recorder

    # Unsorted
    blueberry
    p7zip
    cantarell-fonts


    vial

    spotify
    btop
    
    l3afpad

    gthumb
    zoxide
    tmux

    inputs.matugen.packages.x86_64-linux.default

    # Gui display settings
    nwg-displays
    wlr-randr
    nwg-look
    gradience

    openvpn
    fastfetch

    gnome.gnome-calendar

    #inputs.self.packages.x86_64-linux.nvim # Install nvim package exported in flake

    inputs.myNvim.packages.x86_64-linux.default

    theme # Created from local shell script
    rhythmbox
    bookworm
    gnome.libgnome-keyring

    #qgnomeplatform
    #qgnomeplatform-qt6
    #libsForQt5.qtstyleplugin-kvantum
    #qt6Packages.qtstyleplugin-kvantum
    #lxqt.lxqt-config

    libsForQt5.qt5ct
    qt6Packages.qt6ct

    # For Nextcloud client 
    #gnome.gnome-keyring
  ];

}
