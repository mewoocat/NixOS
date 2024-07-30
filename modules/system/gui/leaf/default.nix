{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: 

{
  imports = [
    ./core-applications/gnome-calendar.nix
    ./core-functions
    ./ags
    ./hyprland
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
}
