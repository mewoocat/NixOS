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
      #nemo-with-extensions

      kdePackages.dolphin
      kdePackages.qtsvg # Needed for icons to work in dolphin

      # Calendar
      libsForQt5.merkuro
      kdePackages.merkuro

      kdePackages.partitionmanager
      kdePackages.kcalc

      pcmanfm-qt 
    ];
  };
}
