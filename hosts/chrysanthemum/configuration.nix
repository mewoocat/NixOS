{
  config,
  lib,
  pkgs,
  ...
}: {

  imports = [
    ./hardware-configuration.nix
    ../../common/servers/home-assistant
    ../../common/servers/minecraft
  ];

  nix = {
    settings = {    
      # Enable flakes and the nix command
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["eXia"]; # Needed to allow eXia to rebuild remotely
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = true;

  # This is a BIOS host so we are using grub
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
 
  # Disable action on laptop lid close
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
  };

  users.users.eXia = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
    ]; 
    hashedPassword = "$y$j9T$Pb8ERrwDCIQE4HqB15PA60$ykb7An0BUxkXmQjWTYUPsqdhwaOvDmLnZTkbIL0bLU7";
    openssh.authorizedKeys.keys = [
      #"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL4NXTpvhSTTtinjDzyCuPQmcAzuMES/gMtLvLp93xMA"
      # PGP Auth
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDeX8NlT5LeZIFXNCORH4oGp/++NA6FLlfUxjdq/UQe63Q4/BNT2Yr6CJLF9EEYUaUO1+iEfQMTEnWyYHfoEQvCaXjHOMf2w/GCEZRME9vR3EujVDUNcBKbytPO0bnccG96u4dvRP8/E0lrln1kkMmukhwawaLR/TkF0YYxwR21ExRQpDac6tr7qDHf+R0JW+evzrz1geuE5m3vMYMulwL6d7lfw5zqyJw53ef8FdjJS0shSjRwOaGYBTIywneCORvJeyXo1ZhbArhdcrqM+oMsPuciwcjnkbvI8+yTG+e8FyD1i0sLFKCZOnPFrH2y7z/04gZTtZfHmWJo90j8utEl"
    ];
    packages = with pkgs; [
      git
      vim
      btop
      zellij
    ];
  };

 # Networking
  networking = {
    hostName = "chrysanthemum";
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    #networkmanager.logLevel = "DEBUG";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPortRanges = [];
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      LogLevel = "VERBOSE";
    };
  };

  # Basic http server
  services.caddy = {
    enable = false;
    openFirewall = true;
    # See for valid addresses: https://caddyserver.com/docs/caddyfile/concepts#addresses
    #
    # This will accept requests for any address on https and port 80
    # However if the host portion of specified for the site, then only requests with the 
    # HTTP Host header matching the site address will be accepted.
    virtualHosts."http://".extraConfig = ''
      respond "minecraft soon?!"

      # host static html webpage
      #root * /var/www
      #file_server
    '';
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
