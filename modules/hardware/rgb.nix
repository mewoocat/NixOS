{
  config,
  lib,
  pkgs,
  ...
}: {
  services.udev.packages = [
    pkgs.openrgb
  ];
  hardware.i2c.enable = true;
}
