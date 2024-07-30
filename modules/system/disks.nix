{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:{
  # Drive management
  programs.gnome-disks.enable = true;
  # Needed for gparted
  security.polkit.enable = true;
  # For udiskie automount to work
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    gparted
  ];
}
