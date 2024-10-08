{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./user.nix
    ./home-manager.nix
    ./boot.nix
    ./power.nix
    ./networking.nix
    ./disks.nix
    ./general.nix
    ./fonts.nix
    ./git.nix
  ];

}
