{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./gui
    ./tui
  ];
}
