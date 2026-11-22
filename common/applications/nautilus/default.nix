{
  config,
  pkgs,
  lib,
  ...
}: {
  hjem.users.${config.username}.files = {
    /*
    "Templates/" = {
      clobber = true;
      source = ./Templates;
    };
    */
  };
  users.users.${config.username}.packages = with pkgs; [
    nautilus
    gvfs # for network file browsing
    #udiskie
  ];
}
