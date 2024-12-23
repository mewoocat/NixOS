{
  options,
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  # This is a custom option
  username = "eXia";

  imports = [
    ../../modules/applications
    ../../modules/dev-environments
    inputs.hjem.nixosModules.default
    ./programs
  ];

  /*
  systemd.user.tmpfiles.users.${config.username}.rules = [
    "L+ /home/${config.username}/.config/test.txt - - - - ${./test.txt}"
  ];
  */

  homes.eXia = {
    enable = true;
    files = {
      ".config/what.txt" = {
        source = ./test.txt;
        clobber = true;
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eXia = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "networkmanager" "docker" "vboxusers" "cdrom"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [

      # Utilities
      bottom    
      blueberry
      hyfetch
      htop
      blueman
      nmap
      glow
      cmakeMinimal
      tmux
      ascii-image-converter
      gh
      zoxide
      openvpn
      linux-wifi-hotspot
      #inputs.myNvim.packages.x86_64-linux.default
      inputs.myNvimNvf.packages.x86_64-linux.default
      inputs.microfetch.packages.x86_64-linux.default  
      wineWowPackages.stable
      nh # Nix helper
      exfatprogs # exFAT filesystem userspace utilities
      stress 
      s-tui
      gcc14

      # Applications
      vesktop
      vscodium
      inkscape
      gimp
      blanket
      rhythmbox
      bookworm
      spotifywm spotify-tray
      vial
      evince # Gnome PDF viewer
      qdirstat
      gucharmap
      brasero
      ungoogled-chromium
      #teams-for-linux # Borked

      zellij
    ];
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Import Homemanger config
  home-manager.users.${config.username} = {
    imports = [
      ./home.nix
    ];
  };

}
