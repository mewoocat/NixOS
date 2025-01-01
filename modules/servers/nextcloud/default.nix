{

  config,
  lib,
  pkgs,
  ...
}: {


  environment.systemPackages = with pkgs; [
    sqlite
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  environment.etc."nextcloud-admin-pass".text = "WhaT3#hiHuH?H0w2";

  # WARNING: It appears that the first time nextcloud is enabled, it runs a setup script that
  # produces some state.  Future rebuilds don't seem to change certain options that were set, 
  # most notably the admin username and password.  
  #
  # Need to figure out how to trigger a reinstall and which options are affected.
  # What seems to work:
  #   - Delete /var/lib/nextcloud and rebuild with services.nextcloud.enable set to false
  #   - Reboot
  #   - Enable nextcloud again and rebuild

  # Uses nginx reverse proxy by default
  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    #hostName = "nextcloud.example.org";
    #database.createLocally = true;
    package = pkgs.nextcloud30;
    #https = true;
    maxUploadSize = "1G";
    home = "/var/lib/nextcloud"; # Storage path of nextcloud.
    config = {
      # These two options appear to be only used during the initial nextcloud install
      # For these to take affect again, nextcloud must be fully reinstalled
      #
      # I think idealy that these options should just be used for initially setting the 
      # admin username and password and then changing them in the client later
      adminuser = "admin";
      adminpassFile = "/etc/nextcloud-admin-pass";
    };
    settings = {
      trusted_domains = [
        "192.168.0.100" # For local testing
      ];
    };
  };

  # Setup fail2ban which bans IPs that repeatedly fail to login
  /*
  services.fail2ban = {
    enable = true;
  };
  */

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
