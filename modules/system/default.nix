{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./user.nix
  ];

  options = {
    hostSystem = lib.mkOption {
      type = lib.types.str;
      default = pkgs.stdenv.hostPlatform.system;
    };
  };
}
