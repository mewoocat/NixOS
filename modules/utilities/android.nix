{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    android-tools
  ];
  users.users.eXia.extraGroups = [ "adbusers" ];
}
