{
  config,
  pkgs,
  ...
}: {

  imports = [
    ./obsidian.nix
    ./moonlight.nix
    ./nextcloud.nix
    ./thunar.nix
    ./firefox
  ];
}
