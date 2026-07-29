# Host: obsidian
# Ryzen 5 + GTX 1080 / RX 470 Desktop
{inputs, ...}: {
  imports = [
    inputs.hjem.outputs.nixosModules.default

    # Hardware
    ./hardware-configuration.nix
    ../../common/hardware/bluetooth.nix
    ../../common/hardware/drawing-tablet.nix
    ../../common/hardware/ios.nix
    ../../common/hardware/razer.nix
    ../../common/hardware/rgb.nix
    ../../common/hardware/vial-keyboards.nix
    ../../common/hardware/nvidia.nix

    # Core system components
    ../../modules/system

    # Desktop environment
    ../../modules/system/desktop-environments/leaf

    # User
    ../../users/eXia
    #../../users/iris

    # Other
    ../../modules/utilities
    ../../common/gaming/game.nix
    ./zfs.nix
    ./samba.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["ntfs"];
  };

  # Android emulation
  #virtualisation.waydroid.enable = true;

  #virtualisation.docker.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    allowSFTP = false; # Not using this
    settings = {
      PasswordAuthentication = true;
    };
  };

  networking.firewall.allowedUDPPorts = [ 53 67 ];
  networking.firewall.allowedTCPPorts = [ 80 443 1883 6669 ];
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
