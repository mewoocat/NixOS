let
  sources = import ./npins
  nixpkgs = sources.nixpkgs
  nixosSystem = import "${nixpkgs}/nixos/lib/eval-config.nix" # Same thing as flake nixpkgs.lib.nixosSystem
in {
  scythe = import nixpkgs +
}
