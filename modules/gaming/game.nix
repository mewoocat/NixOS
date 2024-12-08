{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./gameLite.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  # Testing fix for Deadlock crash
  boot.kernel.sysctl = {
    "vm.max_map_count" = 1048576;
  };

  programs.cdemu.enable = true; # For emulating CD-Roms
  programs.gamemode.enable = true; # Optimise system performance on demand
 
  home-manager.users.${config.username}.home.packages = with pkgs; [
    # Games
    gamescope

    duckstation
    pcsx2
    rpcs3
    dolphin-emu
    xonotic
    osu-lazer-bin
    heroic # Native GOG, Epic, and Amazon Games Launcher

    # Minecraft
    (prismlauncher.override {
      jdks = [
        temurin-bin-21
        temurin-bin-8
        temurin-bin-17
      ];
    })

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
