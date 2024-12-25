{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # For Nextcloud client
  services.gnome.gnome-keyring.enable = true;

  users.users.${config.username}.packages = with pkgs; [
    nextcloud-client
  ];
}
