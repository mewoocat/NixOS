{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./virtualization.nix
    ./overclocking.nix
  ];
}
