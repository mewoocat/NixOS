{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home-manager.users.${config.username}.home.packages = with pkgs; [
    sunshine
  ];

  # Moonlight / Sunshine
  ######################################################################
  services.avahi.enable = true;
  services.avahi.publish.userServices = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [47984 47989 47990 48010];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48000;
      }
    ];
  };
}
