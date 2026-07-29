{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./razer.nix
  ];

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };
}
