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
    enable = true;
    # Open ports in the firewall.
    allowedTCPPorts = [ 22 ];
    allowedUDPPortRanges = [];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
}
