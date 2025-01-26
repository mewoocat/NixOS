{pkgs, inputs, ...}: let
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
    owntracks-recorder
  ];


  services.mosquitto = {
    enable = true;
    listeners = [
      {
        port = 1883;
        omitPasswordAuth = true;
        address = "127.0.0.1";
        settings = {
          allow_anonymous = true;
        };
      }
    ];
  };
  
  networking.firewall.allowedTCPPorts = [ 
    80 # HTTP
    1883 # MQTT
    8083 # OwnTracks web interface
  ];

  users.users.owntracks = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  /*
  [Unit]
  Description=OwnTracks Recorder
  Wants=network-online.target
  After=network-online.target

  [Service]
  Type=simple
  User=owntracks
  WorkingDirectory=/
  ExecStartPre=/bin/sleep 3
  ExecStart=/usr/sbin/ot-recorder

  [Install]
  WantedBy=multi-user.target
  */
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


  # TLS setup
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

}
