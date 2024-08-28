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
    ./obs.nix
    ./firefox
    ./foot.nix
    #./librewolf.nix  # Build failure
  ];
}
