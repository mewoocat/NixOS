{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # For Nextcloud client
  services.gnome.gnome-keyring.enable = true;

  home-manager.users.${config.username} = {
    home.packages = with pkgs; [
      nextcloud-client
    ];
  };
}
