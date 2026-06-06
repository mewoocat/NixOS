{ config, pkgs, sources, ... }: let

in {
    imports = [
      (import sources.hjem { inherit pkgs; }).nixosModules.default
      # Core system config
      ./core.nix

      # Hardware
      ./hardware-configuration.nix
      ../../modules/hardware/bluetooth.nix
      #../../modules/hardware/drawing-tablet.nix
      #../../modules/hardware/ios.nix
      #../../modules/hardware/razer.nix
      #../../modules/hardware/rgb.nix
      ../../modules/hardware/vial-keyboards.nix
      #./displaylink.nix

      # Core system components
      ../../modules/system

      # Desktop environment
      ../../modules/system/desktop-environments/leaf
      #../../modules/system/desktop-environments/kde

      # Users
      ../../users/eXia
      #../../modules/gaming/gameLite.nix

      # Utilities
      #../../modules/utilities

      #./patches.nix
    ];
}
