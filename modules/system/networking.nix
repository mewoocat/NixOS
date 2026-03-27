{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Networking
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  # Firewall
  networking.firewall = {
    enable = false;
    # Open ports in the firewall.
    allowedTCPPorts = [ 22 ];
    allowedUDPPortRanges = [];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    #enable = false;
    settings.PasswordAuthentication = false;
  };
}
