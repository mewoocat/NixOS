{pkgs, ...}:{
  networking.firewall.allowedTCPPorts = [ 
    8082
  ];
  services.traccar.enable = true;
}
