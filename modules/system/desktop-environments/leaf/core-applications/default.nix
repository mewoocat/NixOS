{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./nautilus
    ./gnome-calendar.nix
  ];

  # Home manager config
  home-manager.users.${config.username} = {
    home.file = {
    };
    home.packages = with pkgs; [
      gnome.gnome-calculator
      gnome.eog
      gthumb
    ];
  };
}
