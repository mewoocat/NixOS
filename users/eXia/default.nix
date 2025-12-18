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

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eXia = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable sudo for the user
      "video"
      "networkmanager"
      "docker"
      "vboxusers"
      "cdrom"
      "dialout" # Allows user to access serial devices, used for flashgbx
    ];
    # Set ssh public keys
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPDCMbjh85oDIz/XiQLUzBzUMTOccUo+VL857FHMcbC eXia@obsidian"
    ];
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
      dconf-editor
      eza # ls replacement
      openssl
      arduino

      # Applications
      vesktop
      vscodium
      inkscape
      gimp
      blanket
      rhythmbox
      #bookworm # Borken
      spotifywm spotify-tray
      vial
      evince # Gnome PDF viewer
      qdirstat
      gucharmap
      #brasero
      ungoogled-chromium
      #teams-for-linux # Borked
      newsflash
      obsidian
      vlc
      #inputs.ghostty.packages."${pkgs.system}".default
      yubioath-flutter
      librewolf
      onlyoffice-desktopeditors
      flashgbx
      qtcreator
    ];
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

}
