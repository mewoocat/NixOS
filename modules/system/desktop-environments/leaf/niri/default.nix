{
  config,
  pkgs,
  ...
}: {
  programs.niri.enable = true;

  hjem.users.eXia = {
    enable = true;
    files = {
      ".config/niri" = {
        #source = ./config;
        source = "/home/eXia/NixOS/modules/system/desktop-environments/leaf/niri/config/"; # For development
        clobber = true;
      };
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "eXia";
      };
    };
  };
}
