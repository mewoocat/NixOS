
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, inputs, ... }:
let

in{

  imports = [ 
    ../hardware/ios.nix
    ../hardware/razer.nix
    ../../nixos/gnome-calendar.nix
    ./user.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  environment = {
    sessionVariables = {
      # Environment variables go here
      NIXOS_OZONE_WL = "1";
    };
    etc = {
      # Prob need to move this to nvidia file
      "modprobe.d/nvidia.conf" = {
          text = "options nvidia NVreg_RegistryDwords=\"PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3\"";
      };
    };
  };

  nix.settings = {
    # Cachix for Hyprland
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

    experimental-features = [ "nix-command" "flakes" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  # For Nvidia 555
  #nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  environment.systemPackages = with pkgs; [
    # package names
    easyeffects
    polkit_gnome
    gparted

    qemu
    quickemu
    gnome.gnome-system-monitor
  ];


  services.udev.packages = [ 
    pkgs.openrgb
    pkgs.dolphinEmu   
  ];
  hardware.i2c.enable = true;

  # Gtklock needs this for password to work
  security.pam.services.gtklock = {};
  # https://github.com/NixOS/nixpkgs/issues/240886
  security.pam.services.gtklock.text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";

  # For AGS Screenlock
  security.pam.services.ags = {};

  # For Swaylock Screenlock
  security.pam.services.swaylock = {};

  # Needed for gparted
  security.polkit.enable = true;

  #rtkit is optional but recommended
  security.rtkit.enable = true;

  # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
  sound.enable = lib.mkDefault false;

  services.pipewire = {
    #enable = lib.mkDefault true;
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  #programs.coolercontrol.enable = true;
  #programs.coolercontrol.nvidiaSupport = true;


  ### Services ###

  # For udiskie automount to work
  services.udisks2.enable = true;

  # Required to show thumbnails in thunar
  services.tumbler.enable = true; 

  # For Vial keyboards
  services.udev.extraRules = "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{serial}==\"*vial:f64c2b3c*\", MODE=\"0660\", GROUP=\"users\", TAG+=\"uaccess\", TAG+=\"udev-acl\"";

  services.upower = {
    enable = true;
  };

  # File file manager func.
  services.gvfs.enable = true;

  services.power-profiles-daemon.enable = true;

  services.avahi.enable = true; # Needed for Moonlight / Sunshine
  services.avahi.publish.userServices = true;
 
  # This appears broken
  #services.envfs.enable = true; # Populate /usr/bin with binaries

  # For Nextcloud client
  services.gnome.gnome-keyring.enable = true;

  # Used with ags
  # This breaks the boot process
  /*
  services.greetd = {
    enable = true;
  };
  */

  ### Programs ###
 
  programs.dconf.enable = true;  # Required for gtk?
  programs.light.enable = true;
  programs.hyprland.enable = true;
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.file-roller.enable = true;  # Archive backend?

  programs.xfconf.enable = true;
  programs.noisetorch.enable = true;
  programs.gnome-disks.enable = true;
  programs.kdeconnect.enable = true;
  # add extra compatibility tools to your STEAM_EXTRA_COMPAT_TOOLS_PATHS
  programs.steam = {
    enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  # For overclocking
  programs.corectrl.enable = true;

  # Virtualization
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;


  # Fonts
  ######################################################################
  #https://nixos.wiki/wiki/Fonts for linking fonts to flatpak
  fonts.fontDir.enable = true;  
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Gohu" "Monofur" "ProggyClean" "RobotoMono" "SpaceMono"]; })
  ];

  # Required for steam to run?
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;


  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    Policy = {
      AutoEnable = "false";
    };
  };

  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
  
  # Systemd
  systemd = {
    # Autostarts gnome polkit
    # Needed for apps that require sudo permissions (i.e. gnome-disks)
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };
 
  #networking.nameservers = [ "192.168.1.64" ];
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.


  # Set your time zone.
  #time.timeZone = "America/Chicago";
  time.timeZone = "America/Denver";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eXia = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "docker" "vboxusers"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      #firefox
      #tree
    ];
  };


  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    # Open ports in the firewall.
    #networking.firewall.allowedTCPPorts = [ 3216 ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    
    # For sunshine/moonlight
    allowedTCPPorts = [ 47984 47989 47990 48010 ];
    allowedUDPPortRanges = [
      { from = 47998; to = 48000; }
    ];
};

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

