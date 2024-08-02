{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # For Nextcloud client
  services.gnome.gnome-keyring.enable = true;
}
