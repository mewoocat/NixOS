
{ config, pkgs, lib, inputs, ... }: 

{
  imports = [
    ./gameLite.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  home.packages = with pkgs; [
    # Games
    gamescope
    duckstation
    pcsx2
    rpcs3
    dolphin-emu
    xonotic
    osu-lazer-bin
    prismlauncher # Minecraft

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

    (retroarch.override {
      cores = with libretro; [
        snes9x
        pcsx-rearmed
        mgba
        citra
        dolphin
        mupen64plus
        ppsspp
        #pcsx2
      ];
    })

    sunshine
  ];

}
