{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./user.nix
    ./boot.nix
    ./power.nix
    ./networking.nix
    ./disks.nix
    ./general.nix
    ./fonts.nix
    ./git.nix
  ];

  options = {
    hostSystem = lib.mkOption {
      type = lib.types.str;
      default = pkgs.stdenv.hostPlatform.system;
    };
  };
}
