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
  
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
