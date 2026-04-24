{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./nautilus
  ];

  nixpkgs.overlays = [
    inputs.dolphin-overlay.overlays.default # Provides "open with" fix
  ];

  users.users.${config.username} = {
    packages = with pkgs; [

      # File Manager
      pcmanfm-qt 

      kdePackages.dolphin
      kdePackages.qtsvg # Needed for icons to work in dolphin
      kdePackages.ark # File archiver (compression)
      /*
      kdePackages.plasma-workspace # Has the SolidUiServer i think but not sure how to start it
      kdePackages.kio # needed since 25.11
      kdePackages.kio-fuse #to mount remote filesystems via FUSE
      kdePackages.kio-extras #extra protocols support (sftp, fish and more)
      */
      #nemo-with-extensions
    
      kdePackages.konsole

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
