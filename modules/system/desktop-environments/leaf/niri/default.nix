{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.niri.enable = true;
  programs.niri.package = inputs.niri.packages.x86_64-linux.default;

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
    enable = false;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "eXia";
      };
    };
  };
}
