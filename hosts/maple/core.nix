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

  # zfs
  boot.supportedFilesystems = [ "zfs" ]; # also enabled boot.zfs
  boot.zfs.forceImportRoot = false; # enabling this helps with compatibility but limits safeguards zfs uses
  networking.hostId = "d01ce9f7"; # ensure when using ZFS that a pool isn’t imported accidentally on a wrong machine

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
      allowedTCPPorts = [ 22 5201 ];
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

  environment.systemPackages = [
    inputs.agenix.packages."${pkgs.stdenv.hostPlatform.system}".default # Agenix client
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
      # OpenPGP based converted to ssh public key via openpgp2ssh
      #"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6YWncCg4Y5kiJGz4dj23Da7dScXqX32Oydt741HCKMeCTpjD5eSSgzCfWFo6+z3F+HGzY6Aitqbh3Wr1T1F2T+IWwNVWjD2S+6H59zWOldlcsQAPYdRa583REUZaHHZzvYw3CLF/LEbLDGl0xI5ZBuExgUpxXNXGw3Sh1ZU+tdDHDIGO+c8eixDCF+UlWSsPD6E5EM6MSZPuseHKD3+JhuUkPI6oq97OSp5sn/QLDoHFfP1T3+uYfuZ2haeQ13ZMEqMLuk/tbaS9srRdtP6OGP+T6h5MaPOQCnjWV0qXPHcTuocIFAzQ/HoiHd7qZhgWQcQsK9LKaa4oPK437z6B/"
      # Public key for PIV based authentication key pair generated on yubikey
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDViEUaGrU5qis+UKvnna+qsxcy5mm61XHVeWLI77roIOFe9xpROFzLIkakVJvTPxg8hnJtZePSXo05La8Wvrn+opXXcBT/OXWr7oevq9Zb5s61K/7b0qwHLdrDdsy9mWcOeI+s/v+0gJGNmpYVK71kP4ZSyTTZm60BSzf/ip5QE6v8t8S706uRBv5ZN9IYYZ6EsgCK00Ad9QmFaVOpZzg99xsqsBPnQCaDBPRuthxWbL8Fh/mN0qCbzmwVaBUoYSRLTGehklpbF6H7m1PRch5SLufjpYaNHXFMMcLHk4xG0O21uK6gyKiHtKDIzpd2qi4+G1kqRPWYeaPptbg5h8ib"
    ];
    packages = with pkgs; [
      microfetch
      btop
    ];
  };

}
