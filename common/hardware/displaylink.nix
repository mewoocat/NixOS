# Note this requires some pre setup instructions https://wiki.nixos.org/wiki/Displaylink

{config, pkgs, ...}:{
  # Display Link setup
  environment.systemPackages = with pkgs; [
    displaylink
  ];
  services.xserver.videoDrivers = ["displaylink" "modesetting"]; # also applys for wayland
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.evdi ];
    initrd = {
      # List of modules that are always loaded by the initrd.
      kernelModules = [
        "evdi"
      ];
    };
  };
}
