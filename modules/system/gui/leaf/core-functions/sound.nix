{
  config,
  pkgs,
  lib,
  ...
}: {
  # Deprecated...
  # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
  # sound.enable = lib.mkDefault false;

  services.pipewire = {
    #enable = lib.mkDefault true;
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  programs.noisetorch.enable = true;
  environment.systemPackages = with pkgs; [
    easyeffects
  ];
}
