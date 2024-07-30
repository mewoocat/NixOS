
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: 

{
  # For AGS Screenlock
  security.pam.services.ags = {};

  # This breaks the boot process
  /*
  services.greetd = {
    enable = true;
  };
  */
}
