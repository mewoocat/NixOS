{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./razer.nix
  ];
  services.udev.packages = [
    pkgs.openrgb
  ];
  hardware.i2c.enable = true;
  users.users.${config.username}.packages = with pkgs; [
    openrgb-with-all-plugins
  ];
}
