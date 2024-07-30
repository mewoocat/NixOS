
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: 
{
  imports = [ 
    ./razer.nix
    ./ios.nix
    ./vial-keyboards.nix
    ./drawing-tablet.nix
    ./rgb.nix
    ./bluetooth.nix
  ];
}
