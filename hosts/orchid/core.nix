{
  inputs,
  pkgs,
  ...
}: {

  networking.hostName = "orchid";

  nix = {
    settings = {    
      # Enable flakes (not needed?)
      #experimental-features = ["nix-command" "flakes"];
      trusted-users = ["eXia"]; # Needed to allow eXia to rebuild remotely
    };
  };

  virtualisation.docker.enable = true;

  services.openssh = {
    enable = true;
    allowSFTP = false; # Not using this
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "yes";
      LogLevel = "VERBOSE";
    };
  };

  users.users.eXia = {
    isNormalUser = true;  
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
      "docker"
    ];
    hashedPassword = "$y$j9T$Pb8ERrwDCIQE4HqB15PA60$ykb7An0BUxkXmQjWTYUPsqdhwaOvDmLnZTkbIL0bLU7";
    # Set ssh public keys
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC20jrdK1MUQ9OoV0/AhZSiWsYTx2lFI3j5V5Wb5zR5q"
    ];
    packages = with pkgs; [
      microfetch
      inputs.myNvimNvf.packages.x86_64-linux.default
    ];
  };

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
  system.stateVersion = "25.05"; # Did you read the comment?

}
