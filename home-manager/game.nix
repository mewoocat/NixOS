
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

    (retroarch.override {
      cores = with libretro; [
        snes9x
        pcsx-rearmed
        #pcsx2
      ];
    })

    (lutris.override {
       extraPkgs = pkgs: [
         # List package dependencies here
         wine
       ];
    })


  ];

}
