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
      "wireshark"
    ];
    # Set ssh public keys
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPDCMbjh85oDIz/XiQLUzBzUMTOccUo+VL857FHMcbC eXia@obsidian"
    ];
    packages = with pkgs; [

      # Utilities
      bottom    
      blueberry
      blueman
      nmap
      cmakeMinimal
      ascii-image-converter
      gh
      zoxide
      openvpn
      linux-wifi-hotspot
      #inputs.myNvim.packages.x86_64-linux.default
      inputs.myNvimNvf.packages.x86_64-linux.default
      microfetch
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
      rhythmbox
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
      yubioath-flutter
      librewolf
      onlyoffice-desktopeditors
      flashgbx
      qtcreator
      clementine # Music player

      # Network tools
      wireshark
      iw
      tcpdump
      aircrack-ng
      linssid # For channel analysis

      # Rust
      cargo
      rustc
    ];
  };

  programs.wireshark.enable = true; # Add Wireshark to the global environment and create a ‘wireshark’ group

  # Set your time zone.
  time.timeZone = "America/Chicago";

}
