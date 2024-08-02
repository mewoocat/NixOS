{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./moonlight.nix
    ./nextcloud.nix
    ./thunar.nix
  ];
}
