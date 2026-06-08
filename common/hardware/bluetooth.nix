{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    settings = {
      Policy.AutoEnable = "false";
    };
  };
}
