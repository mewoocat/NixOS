
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

    (retroarch.override {
      cores = with libretro; [
        snes9x
        pcsx-rearmed
        #pcsx2
      ];
    })

  ];

}
