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

      # File Manager
      pcmanfm-qt 
      kdePackages.dolphin
      kdePackages.qtsvg # Needed for icons to work in dolphin
      #nemo-with-extensions

      # Calendar
      #libsForQt5.merkuro
      #kdePackages.merkuro

      # Disks
      kdePackages.partitionmanager

      # Calculator
      gnome-calculator
      kdePackages.kcalc

      # Media viewer
      (mpv.override {
        scripts = with pkgs.mpvScripts; [
          thumbfast
          mpv-image-viewer.image-positioning # Need to setup keybinds
          mpv-image-viewer.minimap
          mpv-image-viewer.status-line
          mpv-image-viewer.freeze-window
        ];
      })
      pix
      #eog
      #gthumb

      # Text editor
      gnome-text-editor
    ];
  };

  # TODO: Look into https://github.com/occivink/mpv-image-viewer/blob/master/mpv.conf for image related conf
  # TODO: Look into https://github.com/occivink/mpv-image-viewer/blob/master/input.conf#L19-L67 for image-positioning keybinds
  hjem.users.${config.username}.files = {  
    ".config/mpv/mpv.conf" = {
      clobber = true;
      text = ''
        keep-open
        idle=yes
      '';
    };
  };

}
