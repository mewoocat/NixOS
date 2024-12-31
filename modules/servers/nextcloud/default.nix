{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.etc."nextcloud-admin-pass".text = "thisisatestpassword";
  # Uses nginx reverse proxy by default
  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    #hostName = "nextcloud.example.org";
    #configureRedis = true; # Caching using Redis for faster page load times
    #database.createLocally = true;
    https = true;
    maxUploadSize = "1G";
    home = "/var/lib/nextcloud"; # Storage path of nextcloud.
    config = {
      adminuser = "admin";
      adminpassFile = "/etc/nextcloud-admin-pass";
    };
    settings = {
      dbname = "nextcloud";
      trusted_domains = [
        "192.168.0.104" # For local testing
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Setup fail2ban which bans IPs that repeatedly fail to login
  services.fail2ban = {
    enable = true;
  };

  /*
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };

  security.acme = {
    acceptTerms = true;   
    certs = { 
      ${config.services.nextcloud.hostName}.email = "your-letsencrypt-email@example.com"; 
    }; 
  };
  */
}
