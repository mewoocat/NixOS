
{ config, lib, pkgs, ... }:

{
    # Open Razer
    hardware.openrazer.enable = true;
    environment.systemPackages = with pkgs; [
        openrazer-daemon # Backend
        polychromatic # Frontend
    ];
    users.users.eXia.extraGroups = [ "openrazer" "plugdev" ];
}
