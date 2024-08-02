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
  home-manager.users.${config.username} = {
    home.packages = with pkgs; [
      openrgb-with-all-plugins
    ];
  };
}
