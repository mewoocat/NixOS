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
    ./ags
    ./hyprland
    ./theming
    ./dynamic
    ./quickshell
  ];

  programs.light.enable = true;
  programs.dconf.enable = true; # Required for gtk?
  programs.kdeconnect.enable = true;

  environment = {
    sessionVariables = {
    };
    variables = {
      NIXOS_OZONE_WL = "1";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland;xcb";
      GSETTINGS_SCHEMA_DIR = "${pkgs.gnome.nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/";
    };
  };

  system.userActivationScripts = {
    # This breaks the nixos-activation service if an error occurs here :/
    /*
    # Initialize dynamic configurations
    leaf-startup.text = ''
      mkdir -p ${leaf-dir}
      mkdir -p ${leaf-dir}/theme 
      cp ${defaultConfigStr} ${leaf-dir}/defaultUserSettings.json
      mkdir -p ${leaf-dir}/hypr
      touch ${leaf-dir}/hypr/monitors.conf
      touch ${leaf-dir}/hypr/workspaces.conf
      touch ${leaf-dir}/hypr/userSettings.conf
    '';
    */
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

  environment.systemPackages = with pkgs; [
    polkit_gnome # Not sure if this is needed since the service is defined above?
    gnome-system-monitor
  ];

  users.users.${config.username}.packages = with pkgs; [
    gnome-bluetooth_1_0
    fastfetch
    xdg-utils # needed for discord/vesktop to open web links in default browser
    usbutils
    liberation_ttf
    arkpandora_ttf
    cantarell-fonts
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
        command = "${pkgs.cage}/bin/cage -s -- leaf";
        user = "eXia"; # Set user to auto login
      };
    };
  };
}
