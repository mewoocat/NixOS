{
  config,
  pkgs,
  lib,
  ...
}: {
  hjem.users.${config.username}.files = {
    "Templates/" = {
      clobber = true;
      source = ./Templates;
    };
  };
  users.users.${config.username}.packages = with pkgs; [
    nautilus
    gvfs # for network file browsing
    #udiskie
  ];

  # Create sevice to run udiskie for automounting
  systemd.user.services.udiskie = {
    enable = true;
    after = [ "graphical.target" ];
    wantedBy = [ "graphical.target" ];
    description = "udiskie service";
    serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.udiskie}/bin/udiskie'';
    };
  };
}
