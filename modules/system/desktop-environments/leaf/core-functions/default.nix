{
  pkgs,
  ...
}: {
  imports = [
    ./sound.nix
    ./screenlock.nix
    ./startup.nix
  ];

  environment.systemPackages = with pkgs; [

  ];
}
