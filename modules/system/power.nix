{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Power management
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}
