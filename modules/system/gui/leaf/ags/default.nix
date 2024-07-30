
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
}
