# Host: scythe
# Razer blade stealth late 2016
{ config, pkgs, inputs, ... }: {
    imports = [
      # Nixos modules
      inputs.hjem.outputs.nixosModules.default

      # Hardware
      ./hardware-configuration.nix
      ../../common/hardware/bluetooth.nix
      ../../common/hardware/drawing-tablet.nix
      ../../common/hardware/ios.nix
      ../../common/hardware/razer.nix
      ../../common/hardware/rgb.nix
      ../../common/hardware/vial-keyboards.nix

      # Core system components
      ../../modules/system

      # Desktop environment
      ../../modules/system/desktop-environments/leaf

      # Users
      ../../users/eXia

      # Utilities
      ../../modules/utilities

    ];

  networking.hostName = "scythe"; # Define your hostname.
  
  services.hardware.bolt.enable = true; # Thunderbolt

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["ntfs"];
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
