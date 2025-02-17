{config, pkgs, inputs, ...}: let
  init = pkgs.writeShellScriptBin "ot-recorder-init" ''  
    # Initilize the database if not already created
    DB_PATH=/var/spool/owntracks/recorder/store/ghash/data.mdb
    if ! test -f $DB_PATH; then
      echo "Initializing ot-recorder db..."
      ${pkgs.owntracks-recorder}/bin/ot-recorder --initialize
    fi
  '';

  generate-ot-certs = pkgs.writeShellApplication {
    name = "generate-ot-certs";
    runtimeInputs = with pkgs; [  
      openssl
    ];
    text = builtins.readFile ./cert.sh;
  };

  domain = "${builtins.readFile (inputs.secrets + "/plaintext/owntracks-domain.txt")}";
  #email = "${builtins.readFile (inputs.secrets + "/plaintext/letsencrypt-email.txt")}";
  certDir = "/etc/ssl/certs/owntracks";
in {

  imports = [
    ./ot-recorder-config.nix
  ];

  environment.systemPackages = with pkgs; [
    # For the cli utilities
    owntracks-recorder
    mosquitto
    openssl # For generating certificates
  ];

  # TLS
  # Generates ca, server, and client certs, as well as their corresponding keys
  system.activationScripts."generate-ot-certs" = ''
    ${generate-ot-certs}/bin/generate-ot-certs "${certDir}" "Private-CA" "Owntracks-Server" ${domain} "Owntracks-Client"
  '';

  age.secrets = {
    mosquitto-reader-pass.file = inputs.secrets + "/mosquitto-reader-pass.age";
    mosquitto-exia-pass.file = inputs.secrets + "/mosquitto-exia-pass.age";
    mosquitto-iris-pass.file = inputs.secrets + "/mosquitto-iris-pass.age";
    gandiv5-pat.file = inputs.secrets + "/gandiv5-pat.age";
  };

  # Create TLS certificates using DNS provider
  /*
  security.acme = {
    acceptTerms = true;
    certs = {
      owntracks = {
        email = email;
        domain = domain;
        #directory = "/var/lib/acme/owntracks"; # Default
        group = "mosquitto"; # So mosquitto can access the certificates

        # Needed to generate certificates
        dnsProvider = "gandiv5";
        environmentFile = config.age.secrets.gandiv5-pat.path;
      };
    };
  };
  */

  # MQTT Broker
  services.mosquitto = {
    enable = true;
    logType = [ "debug" ];
    listeners = [
      {
        #port = 1883; # Non TLS
        port = 8883;
        address = "0.0.0.0"; # Listen on all network interfaces
        settings = {
          # For TLS
          cafile = "${certDir}/ca.crt";
          certfile = "${certDir}/server.crt";
          keyfile = "${certDir}/server.key";

          # For requiring client certificates to authenticate
          require_certificate = true;

          # For allowing login without username and password.
          # Pretty sure it uses the CN of the client cert to determine the username.
          #use_identity_as_username = false; 
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
      
      # Local listener owntracks recorder
      {
        port = 1883; # Non TLS
        address = "127.0.0.1"; # Listen on all network interfaces
        users = {
          recorder = {
            acl = [
              "read owntracks/#"
              "write owntracks/+/+/cmd"
            ];
            passwordFile = config.age.secrets.mosquitto-reader-pass.path;
          };
        };
      }
    ];
  };
  
  networking.firewall.allowedTCPPorts = [ 
    #80 # HTTP
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
}

