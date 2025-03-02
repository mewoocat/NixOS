{
  config,
  lib,
  pkgs,
  ...
}: {

  nix = {
    settings = {    
      # Enable flakes and the nix command
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["eXia"]; # Needed to allow eXia to rebuild remotely
    };
  };

  # This is a BIOS host so we are using grub
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  users.users.eXia = {
    isNormalUser = true;
    extraGroups = ["wheel" "video"]; # Enable ‘sudo’ for the user.
    hashedPassword = "$y$j9T$Pb8ERrwDCIQE4HqB15PA60$ykb7An0BUxkXmQjWTYUPsqdhwaOvDmLnZTkbIL0bLU7";
    openssh.authorizedKeys.keys = [
    ];
    packages = with pkgs; [
      git
      neovim
    ];
  };

 # Networking
  networking = {
    hostName = "chrysanthemum";
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPortRanges = [];
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    #allowSFTP = false; # Not using this
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      LogLevel = "VERBOSE";
    };
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
