{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.etc."nextcloud-admin-pass".text = "PWD";
  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    #hostName = "nextcloud.example.org";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    configureRedis = true; # Caching for fast page load times
    https = true;
    maxUploadSize = "1G";
  };

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

}
