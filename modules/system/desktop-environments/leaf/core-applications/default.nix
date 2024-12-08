{
  config,
  pkgs,
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
      gnome-calculator
      eog
      gthumb
      gnome-text-editor
    ];
  };
}
