{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  startup = pkgs.writeShellScriptBin "leaf" ''
    echo "Starting Leaf Desktop Environment..."
    exec uwsm start hyprland-uwsm.desktop # Run hyprland as a systemd service
                                          # This is needed to start the graphical-session.target

    # temp fix https://github.com/hyprwm/Hyprland/discussions/12661
    #exec uwsm start ${config.programs.hyprland.package}/share/wayland-sessions/hyprland.desktop
    #systemctl --user start hyprland
  '';
in {
  users.users.${config.username} = {
    packages = [
      startup
    ];
  };
}
