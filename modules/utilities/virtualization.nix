{
  config,
  pkgs,
  lib,
  ...
}: {
  # Virtualization
  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [
      virtiofsd # For sharing directories between host and guest
    ];
  };
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
    quickemu
    guestfs-tools
    libvirt-glib
    virtiofsd
  ];
}
