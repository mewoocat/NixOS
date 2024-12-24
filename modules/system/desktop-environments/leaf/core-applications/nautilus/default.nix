{
  config,
  pkgs,
  lib,
  ...
}: {
  homes.${config.username}.files = {
    "Templates/" = {
      clobber = true;
      source = ./Templates;
    };
  };
  users.users.${config.username}.packages = with pkgs; [
    nautilus
    gvfs # for network file browsing
  ];

  # Old HM Service, need to fix
  /*
  services.udiskie = {
    enable = true;
    automount = true;
    tray = "never";
  };
  */
}
