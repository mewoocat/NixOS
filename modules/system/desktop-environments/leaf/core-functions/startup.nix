{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  startup = pkgs.writeShellScriptBin "leaf" ''
    echo "Starting Leaf Desktop Environment..."
    #Hyprland
    exec uwsm start hyprland-uwsm.desktop # Run hyprland as a systemd service
                                          # This is needed to start the graphical-session.target
  '';
in {
  users.users.${config.username} = {
    packages = [
      startup
    ];
  };
}
