
{ config, pkgs, inputs, ... }: let

  # Shell scripts
  #what = pkgs.writeShellScriptBin "lockScreen2" ''exec ${pkgs.gtklock}/bin/gtklock'';
  #what = import ./scripts/lockScreen.nix { inherit pkgs; }; 

  # Theme packaging
  src = builtins.readFile ./programs/theme/theme.sh;
  theme = pkgs.writeShellScriptBin "theme" src;

  # Wallust packaging
  wallust = pkgs.callPackage ./programs/wallust.nix {};

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
    hyfetch fastfetch
    htop
    qalculate-gtk
    gnome.eog
    gnome.nautilus
    evince # Gnome PDF viewer
    gnome.gnome-bluetooth_1_0
    blueman

    # Programs
    obsidian
    vesktop
    xdg-utils # needed for discord/vesktop to open web links in default browser
    #onlyoffice-bin
    gnome.gucharmap
    inkscape
    gimp
    #fontforge-gtk
    mgba
    #xournalpp
    tor-browser-bundle-bin
    nextcloud-client
    #bottles
    qdirstat
    ascii-image-converter 
    gh
    vial
    btop 
    l3afpad
    gthumb
    rhythmbox
    bookworm
    spotifywm spotify-tray
    nwg-displays
    wlr-randr
    nwg-look
    gradience
    openvpn
    zoxide
    tilix
    blanket
    
    # Appearance
    liberation_ttf
    arkpandora_ttf
    cantarell-fonts
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    pywal
    swww

    # Components + utilities
    coreutils # Collision with busybox 
    acpi                # Battery
    lm_sensors          # 
    brightnessctl
    bluez
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
    nmap
    dig
    libnotify
    p7zip
    tmux
    blueberry
    cmakeMinimal
    glow
    satty
    grim
    lynx

    # AGS
    sassc
    wf-recorder
    slurp # Used to select screen in wf-recorder
    python312Packages.gpustat
    gtk-session-lock

    # Self packaged
    wallust 
    theme 

    # From flake
    inputs.myNvim.packages.x86_64-linux.default
    inputs.matugen.packages.x86_64-linux.default

    # Testing out
    niri

  ];

}
