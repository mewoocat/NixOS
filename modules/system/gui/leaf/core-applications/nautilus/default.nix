{
  config,
  pkgs,
  lib,
  ...
}: {
  # Home manager config
  home-manager.users.${config.username} = {
    imports = [
    ];
    home.file = {
      "Templates/".source = ./Templates;
    };
    home.packages = with pkgs; [
      gnome.nautilus
      gvfs # for network file browsing
    ];
    # Services
    services.udiskie = {
      enable = true;
      automount = true;
      tray = "never";
    };
    systemd.user.tmpfiles.rules = [
      # There's probably a better way to do this
      #"L+ /home/${config.username}/.config/ags - - - - /home/${config.username}/NixOS/modules/system/gui/leaf/ags/ags-config"
    ];
  };
}
