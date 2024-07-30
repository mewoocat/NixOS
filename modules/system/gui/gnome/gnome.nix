{
  config,
  pkgs,
  lib,
  ...
}: {
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Fix audio conflict with main system
  sound.enable = lib.mkForce false;

  # Disable pulseaudio which gets enabled by gnome
  hardware.pulseaudio.enable = lib.mkForce false;

  # Enable pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = lib.mkForce true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Fix web browser crashes?
  environment.sessionVariables."NIXOS_OZONE_WL" = "1";
}