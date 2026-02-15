{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  leaf-dir = "/home/${config.username}/.config/leaf-de";
  # Accessing the path using ${} from within a string returns the nix store version of the file
  defaultConfigStr = "${./ags/ags-config/defaultUserSettings.json}"; 
in{
  imports = [
    ./core-applications
    ./core-functions
    #./ags
    ./hyprland
    ./theming
    ./quickshell
    inputs.qtengine.nixosModules.default
  ];

  # Unlike qt(5/6)ct, qtengine doesn't support hot reloading of colors.  Support is planned for the future.
  programs.qtengine = {
    enable = true;
    config = {
      theme = {
        # Note that this file apparently affect the colors of icons
        colorScheme = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
        #colorScheme = "${leaf-dir}/qtengine.colors";
        iconTheme = "kora";
        style = "darkly";
        font = {
          family = "Rubik";
          size = 11;
          weight = -1;
        };
        fontFixed = {
          family = "SpaceMono Nerd Font";
          size = 11;
          weight = -1;
        };
      };
      misc = {
        menusHaveIcons = true;
      };
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.space-mono
    rubik

    # fonts
    liberation_ttf
    arkpandora_ttf
    cantarell-fonts
  ];

  programs.light.enable = true;
  programs.dconf.enable = true; # Required for gtk?
  programs.kdeconnect.enable = true;

  environment = {
    systemPackages = with pkgs; [

      # theming
      kdePackages.breeze
      kdePackages.breeze.qt5 # For Qt5 support
      kdePackages.breeze-icons kora-icon-theme
      darkly
      darkly-qt5 # For Qt5 support

      polkit_gnome # Not sure if this is needed since the service is defined below?
      gnome-system-monitor

    ];
    sessionVariables = {};
    variables = {
      NIXOS_OZONE_WL = "1";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland;xcb";
      GSETTINGS_SCHEMA_DIR = "${pkgs.gnome.nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/";
    };
  };

  # If an error occurs in any of the scripts here, the nixos-activation service will break
  system.userActivationScripts = {
  };

  # Autostarts gnome polkit
  # Needed for apps that require sudo permissions (i.e. gnome-disks)
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # System service for starting hyprland
  /*
  systemd.user.services.hyprland = {
    description = "Hyprland session";
    before = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${config.programs.hyprland.package}/bin/Hyprland";
    };
  };
  */

  users.users.${config.username}.packages = with pkgs; [
    fastfetch
    xdg-utils # needed for discord/vesktop to open web links in default browser
    usbutils
    coreutils
    acpi # Battery
    lm_sensors #
    brightnessctl
    bluez
    wirelesstools
    pipewire
    pulseaudio
    alsa-utils
    pamixer
    pavucontrol
    wl-clipboard
    glib
    gnome.nixos-gsettings-overrides # For gsettings theming
    jaq
    gojq
    socat
    ripgrep
    jq
    bc
    wlsunset
    unzip
    gvfs # for network file browsing
    dig
    libnotify
    p7zip
    satty
    grim
    ddcutil
    ddcui
  ];

  # GreetD
  services.greetd = {
    enable = false;
    settings = {
      default_session = {
        #command = "${pkgs.cage}/bin/cage -s -- leaf";
        command = "leaf";
        user = "eXia"; # Set user to auto login
      };
    };
  };
}
