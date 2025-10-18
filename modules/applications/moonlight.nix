{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Moonlight / Sunshine
  ######################################################################
  /*
  users.users.${config.username}.packages = with pkgs; [
    (sunshine.override { cudaSupport = true; })
  ];
  */
  services.sunshine = {
    enable = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
  };
  /*
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
  */
}
