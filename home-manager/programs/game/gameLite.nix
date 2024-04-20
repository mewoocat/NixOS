
{ config, pkgs, lib, inputs, ... }: 

{
  imports = [

  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  home.packages = with pkgs; [
    # Games
    gamescope
    duckstation
    osu-lazer-bin
    prismlauncher # Minecraft
    mangohud

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

  ];

}
