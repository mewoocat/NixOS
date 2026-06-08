{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Moonlight / Sunshine
  services.sunshine = {
    enable = false;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
  };
}
