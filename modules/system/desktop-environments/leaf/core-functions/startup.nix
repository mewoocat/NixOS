{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  startup = pkgs.writeShellScriptBin "leaf" ''
    echo "Starting Leaf Desktop Environment..."
    zellij kill-all-session
    Hyprland
  '';
in {
  home-manager.users.${config.username} = {
    home.packages = [
      startup
    ];
  };
}
