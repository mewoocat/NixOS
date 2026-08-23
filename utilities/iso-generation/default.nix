{ config, pkgs, ... }:
{
  imports = [
    # import the iso-image nixos module and base configuration for a minimal installer iso
    # todo?: rewrite this using the nixpkgs input
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
  ];
}
