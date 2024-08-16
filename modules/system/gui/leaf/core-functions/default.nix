{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./sound.nix
    ./screenlock.nix
    ./startup.nix
  ];
}
