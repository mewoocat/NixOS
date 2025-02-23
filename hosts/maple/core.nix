{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  system.stateVersion = "24.11";

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    #efiSupport = true;
    #efiInstallAsRemovable = true;
  };

  nix = {
    settings = {    
      # Enable flakes
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["eXia"]; # Needed to allow eXia to rebuild remotely
    };
  };

  # Networking
  networking = {
    hostName = "maple";
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
    allowSFTP = false; # Not using this
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "yes";
      LogLevel = "VERBOSE";
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${system}".default # Agenix client
    inputs.myNvimNvf.packages.x86_64-linux.default # My nvim config
  ];

  users.users.root= {
    hashedPassword = "$y$j9T$Pb8ERrwDCIQE4HqB15PA60$ykb7An0BUxkXmQjWTYUPsqdhwaOvDmLnZTkbIL0bLU7";
    # Set ssh public keys
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBO24z1xI9hHgqMr7pHYxj9vQCjkIqnFrRvK6lcOu9h+"
    ];
  };

  time.timeZone = "America/Chicago";

  users.users.eXia = {
    isNormalUser = true;
    extraGroups = ["wheel" "video"]; # Enable ‘sudo’ for the user.
    hashedPassword = "$y$j9T$Pb8ERrwDCIQE4HqB15PA60$ykb7An0BUxkXmQjWTYUPsqdhwaOvDmLnZTkbIL0bLU7";
    # Set ssh public keys
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBO24z1xI9hHgqMr7pHYxj9vQCjkIqnFrRvK6lcOu9h+"
    ];
    packages = with pkgs; [
    ];
  };

}
