{
  config,
  pkgs,
  ...
}: { 
  networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ]; # Needed to resolve error when connecting with proton-vpn, see: https://github.com/NixOS/nixpkgs/issues/425431
  environment.systemPackages = with pkgs; [
    networkmanagerapplet # Needs to be running for VPN connection to work
    proton-vpn
  ];
}
