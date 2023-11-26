
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }:
let
  #home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #(import "${home-manager}/nixos")
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set kernel parameters
  boot.kernelParams = ["quiet" "button.lid_init_state=open" "intel_idle.max_cstate=1"];

 environment.sessionVariables = {
    # Environment variables go here
    NIXOS_OZONE_WL = "1";
};

  environment.etc = {
    # Example (not sure if this works for disabling touchscreen)
    #"modprobe.d/ELAN_Touchscreen.conf" = {
    #    text = "blacklist \"ELAN Touchscreen UNKNOWN\"";
    #};
  };

  # Disable device
  # idVendor and idProduct can be found by `cat /proc/bus/input/devices`
  # Disable touchscreen
  services.udev.extraRules = "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"04f3\", ATTRS{idProduct}==\"223c\", ATTR{authorized}=\"0\"";


  # Cachix for Hyprland
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };


  # Doesn't work?
  #environment.variables.EDITOR = "neovim";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];	
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
  # vscodium
  ];


  # Gtklock needs this for password to work
  security.pam.services.gtklock = {};
  # https://github.com/NixOS/nixpkgs/issues/240886
  security.pam.services.gtklock.text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";

  # For udiskie automount to work
  services.udisks2.enable = true;

  # Required to show thumbnails in thunar
  services.tumbler.enable = true; 

  # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
  sound.enable = false;

  # Needed for gparted
  security.polkit.enable = true;

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  #xdg.portal = {
  #  enable = true;
  #  extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  #  # pkgs.xdg-desktop-portal-gtk
  #};

  #services.openssh.enable = true;


  # File file manager func.
  services.gvfs.enable = true;
 
  # Required for steam to run?
  hardware.opengl.driSupport32Bit = true;


  # Programs
 
  programs.dconf.enable = true;  # Required for gtk?
  programs.light.enable = true;
  programs.hyprland.enable = true;
  programs.thunar.enable = true;

  programs.file-roller.enable = true;  # Archive backend?
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.xfconf.enable = true;



  #https://nixos.wiki/wiki/Fonts for linking fonts to flatpak
  fonts.fontDir.enable = true;  

  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    Policy = {
      AutoEnable = "false";
    };
  };
  
  fonts.fonts = with pkgs; [
    nerdfonts
  ];
 
  networking.hostName = "scythe"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
#  networking.wireless.networks = {
#    "Google Wi-Fi" = {
#      psk = "9w8aay37";
#    };
#  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

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


  

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.exia = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "docker" "vboxusers"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      #firefox
      #tree
    ];
  };


  #virtualisation.docker.enable = true;
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.guest.enable = true;

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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

