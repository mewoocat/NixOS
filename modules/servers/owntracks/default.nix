{pkgs, inputs, ...}: let
  hostName = "${builtins.readFile (inputs.secrets + "/plaintext/nextcloud-domain.txt")}"; #TODO: change domain
  letsEncryptEmail = builtins.readFile (inputs.secrets + "/plaintext/letsencrypt-email.txt");

  /*
  ot-recorder-init = pkgs.writeShellScriptBin "ot-recorder-init" ''  
    ${pkgs.sudo}/bin/sudo mkdir -p /var/spool/owntracks/recorder/htdocs
    #mkdir -p /var/spool/owntracks/recorder/store
  '';
  */

in {

  imports = [
    ./ot-recorder-config.nix
  ];

  environment.systemPackages = with pkgs; [
    owntracks-recorder
  ];
  
  networking.firewall.allowedTCPPorts = [ 
    80 # HTTP
    #1883 # MQTT
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
    after = [ "network-online.target" ];

    # [Service]
    serviceConfig = {
      Type = "simple";
      User = "owntracks";
      WorkingDirectory = "/";
      ExecStart = "${pkgs.owntracks-recorder}/bin/ot-recorder";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3"; 
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
