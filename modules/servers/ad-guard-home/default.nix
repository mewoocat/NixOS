{config, pkgs, ...}: {
  services.adguardhome = {
    enable = true;
    port = 3000; # Port to serve HTTP pages on
    openFirewall = true; # Opens the above port
  };
}
