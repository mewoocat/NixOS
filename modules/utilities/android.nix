{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.adb.enable = true;
  users.users.eXia.extraGroups = [ "adbusers" ];
}
