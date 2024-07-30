{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: 

{
  imports = [
    ./core-applications/gnome-calendar.nix
    ./core-functions
    ./ags
  ];
}
