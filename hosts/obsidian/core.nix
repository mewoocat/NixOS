{
  config,
  lib,
  pkgs,
  ...
}: {

  # Android emulation
  virtualisation.waydroid.enable = true;

  /* ZFS config
  boot.supportedFilesystems = [ "zfs" ]; # also enables boot.zfs
  boot.zfs.forceImportRoot = false; # enabling this helps with compatibility but limits safeguards zfs uses
  networking.hostId = "a839e912"; # ensure when using ZFS that a pool isn’t imported accidentally on a wrong machine
  */

  virtualisation.docker.enable = true;

  networking.firewall.allowedUDPPorts = [ 53 67 ];
  networking.firewall.allowedTCPPorts = [ 80 443 1883 6669 ];
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
