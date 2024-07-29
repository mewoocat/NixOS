{
  options,
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  # This is a custom option
  username = "eXia";

  home-manager.users.${config.username} = {
    imports = [
      ./home.nix
    ];
  };
}
