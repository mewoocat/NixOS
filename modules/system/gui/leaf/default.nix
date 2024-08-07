{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./core-applications
    ./core-functions
    ./ags
    ./hyprland
    ./theming
  ];

  programs.dconf.enable = true; # Required for gtk?
  programs.kdeconnect.enable = true;

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
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

  environment.systemPackages = with pkgs; [
    polkit_gnome # Not sure if this is needed since the service is defined above?
    gnome.gnome-system-monitor
  ];

  # Home manager
  home-manager.users.${config.username} = {
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland;xcb";
    };

    home.packages = with pkgs; [
      gnome.gnome-bluetooth_1_0
      fastfetch
      xdg-utils # needed for discord/vesktop to open web links in default browser
      usbutils
      # Appearance
      liberation_ttf
      arkpandora_ttf
      cantarell-fonts
      coreutils # Collision with busybox
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
  };
}
