{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [gnome-calendar];
  programs.dconf.enable = true;
  services = {
    gnome = {
      evolution-data-server.enable = true; # optional to use google/nextcloud calendar
      gnome-online-accounts.enable = true; # optional to use google/nextcloud calendar
      gnome-keyring.enable = true;
    };
  };
}
