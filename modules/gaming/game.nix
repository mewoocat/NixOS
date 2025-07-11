{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./gameLite.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = true;

  # Testing fix for Deadlock crash
  # Doesn't seem to fix anything
  /*
  boot.kernel.sysctl = {
    "vm.max_map_count" = 1048576;
  };
  */

  programs.cdemu.enable = true; # For emulating CD-Roms
  programs.gamemode.enable = true; # Optimise system performance on demand
  programs.gamescope.enable = true;

  services.udev.packages = with pkgs; [
    #dolphin # Needed for controllers to work? Doesn't seem fix the issue
  ];

  users.users.${config.username}.packages = with pkgs; [ 

    # Utilities
    #gamescope
    protontricks # Causes build error if installed in steam.extraPackages

    # Emulators
    duckstation
    pcsx2
    rpcs3
    dolphin-emu

    # Games
    xonotic
    #osu-lazer-bin # Low fps on openGL, crashes on vulken
    inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin # Works great on openGL :)

    # Minecraft
    (prismlauncher.override {
      jdks = [
        temurin-bin-21
        temurin-bin-8
        temurin-bin-17
      ];
    })

    # Launchers
    # Native GOG, Epic, and Amazon Games Launcher
    #heroic # Only start background process but window never loads
    heroic-unwrapped # This one's window opens

    (lutris.override {
      extraPkgs = pkgs: [
        # List package dependencies here
        #wine
        #wine-wayland
        wineWowPackages.stable
        winetricks
      ];
    })
    #inputs.nix-gaming.packages.${pkgs.system}.viper

    /*
    (retroarch.override {
      cores = with libretro; [
        snes9x
        pcsx-rearmed
        mgba
        #citra
        dolphin
        mupen64plus
        ppsspp
        #pcsx2
      ];
    })
    */
  ];
}
