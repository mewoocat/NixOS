{
  config,
  pkgs,
  ...
}: { 
  environment.systemPackages = with pkgs; [
    networkmanagerapplet # Needs to be running for VPN connection to work
    proton-vpn
  ];
}
