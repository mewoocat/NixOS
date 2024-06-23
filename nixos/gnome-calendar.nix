
{config, pkgs, lib, ...}:
{
    environment.systemPackages = with pkgs; [ gnome.gnome-calendar ];
    programs.dconf.enable = true;
    services.gnome.evolution-data-server.enable = true;
    # optional to use google/nextcloud calendar
    services.gnome.gnome-online-accounts.enable = true;
    # optional to use google/nextcloud calendar
    services.gnome.gnome-keyring.enable = true;

}
