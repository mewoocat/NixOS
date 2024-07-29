
{ config, lib, pkgs, ... }:
{
    hardware.openrazer.enable = true;
    environment.systemPackages = with pkgs; [
        # Backend
        openrazer-daemon 
  
        # Frontend
        polychromatic 
        razergenie
    ];
    users.users.eXia.extraGroups = [ "openrazer" "plugdev" ];
}
