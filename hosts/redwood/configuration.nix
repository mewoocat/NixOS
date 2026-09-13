# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Modules
      inputs.agenix.nixosModules.default
    ];

  networking.hostId = "dddb96d2";
  networking.hostName = "redwood"; # Define your hostname.

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };


  # Set this to false to force the nixos password config to overwrite any existing config
  users.mutableUsers = false;
  users.users.root = {
    hashedPassword = "$y$j9T$56oM.CwwWoTl4t7TI/FDL.$fZX6Xy1DlOnqGv/jUHRioL9LuQ5stIftBYXujorzsl/";
    # Set ssh public keys
    openssh.authorizedKeys.keys = [
      #"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBO24z1xI9hHgqMr7pHYxj9vQCjkIqnFrRvK6lcOu9h+"
    ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessionse
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
    /*
    extraConfig = ''
      HostKey /etc/ssh/ssh_host_ed25519_key_redwood
    '';
    */
    /*
    hostKeys = [
      "/etc/ssh/ssh_host_ed25519_key_redwood"
    ];
    */
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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

  # Setup for decrypting zfs zpool remotely
  #
  # See: https://wiki.nixos.org/wiki/ZFS
  #
  nix.settings.experimental-features = [
    "nix-command" # needed for agenix?
  ];
  age = {
    identityPaths = [
      "/etc/ssh/redwood"
    ];
    secrets = {
      recwood-ssh-host-key = {
        file = inputs.secrets + "/redwood-ssh-host-key.age";
      };
    };
  };
  #
  # The network card may not work in initrd unless it's kernel module is manually loaded
  # Use `lspci -v` to find the network card and reference it's "Kernel Modules" property
  boot.initrd.availableKernelModules = [ "e1000e" ]; # This might just be one of the ethernet cards
  boot = {
    initrd.network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2222;
        hostKeys = [
          config.age.secrets.recwood-ssh-host-key.path
        ];
        authorizedKeys = [
          # eXia PGP Auth
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDeX8NlT5LeZIFXNCORH4oGp/++NA6FLlfUxjdq/UQe63Q4/BNT2Yr6CJLF9EEYUaUO1+iEfQMTEnWyYHfoEQvCaXjHOMf2w/GCEZRME9vR3EujVDUNcBKbytPO0bnccG96u4dvRP8/E0lrln1kkMmukhwawaLR/TkF0YYxwR21ExRQpDac6tr7qDHf+R0JW+evzrz1geuE5m3vMYMulwL6d7lfw5zqyJw53ef8FdjJS0shSjRwOaGYBTIywneCORvJeyXo1ZhbArhdcrqM+oMsPuciwcjnkbvI8+yTG+e8FyD1i0sLFKCZOnPFrH2y7z/04gZTtZfHmWJo90j8utEl"
        ];
      };
    };
  };
  #
  #In order to use DHCP in initrd, networking.useDHCP must be true and network
  networking.useDHCP = true;
  networking.networkmanager.enable = false;

}

