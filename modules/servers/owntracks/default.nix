# NOTE: This module is in a highly unfunctional state

{config, pkgs, inputs, ...}: let
  hostName = "${builtins.readFile (inputs.secrets + "/plaintext/nextcloud-domain.txt")}"; #TODO: change domain
  letsEncryptEmail = builtins.readFile (inputs.secrets + "/plaintext/letsencrypt-email.txt");

  init = pkgs.writeShellScriptBin "ot-recorder-init" ''  
    # Initilize the database if not already created
    DB_PATH=/var/spool/owntracks/recorder/store/ghash/data.mdb
    if ! test -f $DB_PATH; then
      echo "Initializing ot-recorder db..."
      ${pkgs.owntracks-recorder}/bin/ot-recorder --initialize
    fi
  '';

in {

  imports = [
    ./ot-recorder-config.nix
  ];

  environment.systemPackages = with pkgs; [
    # For the cli utilities
    owntracks-recorder
    mosquitto
  ];

  age.secrets.mosquitto-reader-pass = {
    file = inputs.secrets + "/mosquitto-reader-pass.age";
    #owner = "nextcloud";
    #group = "nextcloud";
  };
  age.secrets.mosquitto-exia-pass.file = inputs.secrets + "/mosquitto-exia-pass.age";
  age.secrets.mosquitto-iris-pass.file = inputs.secrets + "/mosquitto-iris-pass.age";
  age.secrets.gandiv5-pat.file = inputs.secrets + "/gandiv5-pat.age";

  # Create TLS certificates
  security.acme = {
    acceptTerms = true;
    certs = {
      owntracks = {
        email = "${builtins.readFile (inputs.secrets + "/plaintext/letsencrypt-email.txt")}";
        domain = "${builtins.readFile (inputs.secrets + "/plaintext/owntracks-domain.txt")}";
        #directory = "/var/lib/acme/owntracks"; # Default
        group = "mosquitto"; # So mosquitto can access the certificates
        # Needed to generate certificates
        dnsProvider = "gandiv5";
        environmentFile = config.age.secrets.gandiv5-pat.path;
      };
    };
  };

  # MQTT Broker
  services.mosquitto = {
    enable = true;
    #logType = [ "debug" ];
    #logDest = [ "topic" ];
    listeners = [
      {
        #port = 1883; # Non TLS
        port = 8883;
        address = "0.0.0.0"; # Listen on all network interfaces
        #omitPasswordAuth = true;
        settings = let 
          certDir = config.security.acme.certs.owntracks.directory;
          in {
          #allow_anonymous = true;

          # For TLS
          cafile = "${certDir}/chain.pem";
          certfile = "${certDir}/cert.pem";
          keyfile = "${certDir}/key.pem";
        };
        users = {
          recorder = {
            acl = [
              "read owntracks/#"
              "write owntracks/+/+/cmd"
            ];
            passwordFile = config.age.secrets.mosquitto-reader-pass.path;
          };
          exia = {
            acl = [
              "readwrite owntracks/exia/#"
              "read owntracks/+/+"
              "read owntracks/+/+/event"
              "read owntracks/+/+/info"
            ];
            passwordFile = config.age.secrets.mosquitto-exia-pass.path;
          };
          iris = {
            acl = [
              "readwrite owntracks/iris/#"
              "read owntracks/+/+"
              "read owntracks/+/+/event"
              "read owntracks/+/+/info"
            ];
            passwordFile = config.age.secrets.mosquitto-iris-pass.path;
          };
        };
      }
    ];
  };
  
  networking.firewall.allowedTCPPorts = [ 
    80 # HTTP
    #1883 # MQTT
    8883 # MQTT TLS
    8083 # OwnTracks web interface
  ];

  users.users.owntracks = {
    #TODO: Probably could just make this a system user?
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # From: https://github.com/owntracks/recorder/blob/master/etc/ot-recorder.service
  #TODO: Force restart on rebuild, currently need to restart manaully
  systemd.services.owntracks = {
    description = "OwnTracks Recorder";
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ]; # Starts at boot
    after = [ "network-online.target" "mosquitto.service" ];

    # [Service]
    serviceConfig = {
      Type = "simple";
      User = "owntracks";
      WorkingDirectory = "/";
      ExecStart = "${pkgs.owntracks-recorder}/bin/ot-recorder";
      ExecStartPre = "${init}/bin/ot-recorder-init && ${pkgs.coreutils}/bin/sleep 3"; 
    };
  };


  # TLS setup
  /*
  services.nginx.virtualHosts.${hostName} = {
    forceSSL = true;
    enableACME = true;
  };
  security.acme = {
    acceptTerms = true;   
    certs = { 
      ${hostName}.email = letsEncryptEmail; 
    }; 
  };
  */
}
