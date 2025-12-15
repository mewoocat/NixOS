{

  config,
  lib,
  pkgs,
  inputs,
  ...
}: let 
  rootDomain = builtins.readFile (inputs.secrets + "/plaintext/domain.txt"); 
in {
  
  # Add Agenix secrets
  #age.secretsDir = "/tmp";
  age.secrets = {
    nextcloud-admin-pass = {
      file = inputs.secrets + "/nextcloud-admin-pass.age";
      # File need to be access by the nextcloud user
      owner = "nextcloud";
      group = "nextcloud";
    };
    porkbun-api-key = {
      file = inputs.secrets + "/porkbun-api-key.age";
    };
  };


  environment.systemPackages = with pkgs; [
    # Provide database related commands for management
    # mariadb is a drop in replacement for mysql and is what is used in the nextcloud module
    # when mysql is selected as the db 
    mariadb
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

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
    #hostName = "localhost";
    hostName = "${builtins.readFile (inputs.secrets + "/plaintext/nextcloud-domain.txt")}";
    database.createLocally = true; # Need to create mysql db if not manually creating it
    package = pkgs.nextcloud32;
    https = true;
    maxUploadSize = "50G";
    home = "/var/lib/nextcloud"; # Storage path of nextcloud.
    config = { 
      # These two options appear to be only used during the initial nextcloud install
      # For these to take affect again, nextcloud must be fully reinstalled
      #
      # I think idealy that these options should just be used for initially setting the 
      # admin username and password and then changing them in the client later
      adminuser = "admin";
      #adminpassFile = "/etc/nextcloud-admin-pass";
      adminpassFile = config.age.secrets.nextcloud-admin-pass.path;

      # I'm also guess that most if not all of these values are used for the intial setup script
      # and cannot be declaritively changed
      dbtype = "mysql";
      /*
      dbpassFile = "/etc/nextcloud-db-pass";
      // Defaults
      dbuser = "nextcloud";
      dbname = "nextcloud";
      */
      objectstore.s3.secretFile = "/tmp/nextcloud-config-secret";
    };
    settings = {
      trusted_domains = [
        "192.168.0.103" # For local testing
        "localhost" # For local testing
        config.services.nextcloud.hostName
      ];

      # Might be able to declare the config.php secret property this way
      #secret = ""; 

      log_type = "file"; # Enable file based logging. By default logs to a file called nextcloud.log in the data dir
    };

    # Instead of using pkgs.nextcloud29Packages.apps or similar,
    # we'll reference the package version specified in services.nextcloud.package
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) contacts calendar notes tasks;
    };
    extraAppsEnable = true;
  };

  # TLS setup
  # This configuration is designed for being hosted behind a vpn.  The nextcloud service will be
  # accessible using a domain name which points to the private internal ip of the server within
  # the vpn.  This means that http challenge (for proving to the CA e.g. letsencrypt) that the
  # server controls the domain, is not possible due to the web server not being exposed directly
  # the public internet.  Instead, DNS validation must be used instead, which is what is done here.
  security.acme = {
    acceptTerms = true;   
    defaults = {
      email = builtins.readFile (inputs.secrets + "/plaintext/letsencrypt-email.txt"); 
      # The the DNS provider for the domain
      dnsProvider = "porkbun";
      # Sets the needed secret env variables to authenticate api access to porkbun
      # See: https://go-acme.github.io/lego/dns/porkbun/ details
      environmentFile = config.age.secrets.porkbun-api-key.path;
    };
    # Generate root wildcard certificate (can be used for the root domain and any first level subdomains)
    certs = { 
      ${rootDomain} = {
        # ACME servers will only hand out wildcard certs over DNS validation
        domain = "*.${rootDomain}";
        group = config.services.nginx.group;
      };
    }; 
  };
  services.nginx.virtualHosts."${config.services.nextcloud.hostName}" = {
    forceSSL = true;
    #enableACME = true; # Auto tries to generate cert?
    useACMEHost = rootDomain; # Use wildcard certificate generated for the root domain
    acmeRoot = null; # Disable the .well-known/acme-challenge/ endpoint since we're using DNS-01 Challenge instead of HTTP-01

  };

  # Nextcloud backup
  # See: https://wiki.nixos.org/wiki/Systemd/timers
  /*
  systemd.timers."nextcloud-backup" = {
    wantedBy = [ "timers.target" ];
    OnCalendar = "*-*-* 00:00:00"; # Should run daily at midnight (i think)
    Unit = "nextcloud-backup.service";
  };
  */
}
