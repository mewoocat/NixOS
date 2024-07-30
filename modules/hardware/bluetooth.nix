
{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    Policy = {
      AutoEnable = "false";
    };
  };
}
