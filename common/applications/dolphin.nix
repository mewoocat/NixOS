{
  config,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.dolphin-overlay.overlays.default # Provides "open with" fix
  ];

  users.users.${config.username} = {
    packages = with pkgs; [
      kdePackages.dolphin
      kdePackages.ark # File archiver (compression)
      kdePackages.qtsvg # Needed for icons to work in dolphin
      #kdePackages.plasma-workspace # Has the SolidUiServer i think but not sure how to start it
      kdePackages.kio # Needed for password prompt inside dolphin
      kdePackages.kio-fuse #to mount remote filesystems via FUSE
      kdePackages.kio-extras #extra protocols support (sftp, fish and more)
    ];
  };
}
