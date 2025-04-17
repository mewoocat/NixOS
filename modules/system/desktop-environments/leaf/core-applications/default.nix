{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nautilus
    ./gnome-calendar.nix
  ];

  users.users.${config.username} = {
    packages = with pkgs; [
      gnome-calculator
      eog
      gthumb
      gnome-text-editor
      nemo-with-extensions
    ];
  };
}
