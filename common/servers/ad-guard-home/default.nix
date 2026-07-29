{config, pkgs, ...}: {

  # Open DNS port
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  services.adguardhome = {
    enable = true;
    port = 3000; # Port to serve HTTP pages on
    openFirewall = true; # Opens the above port
  };
}
