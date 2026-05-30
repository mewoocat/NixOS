{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.niri.enable = true;
  programs.niri.package = inputs.niri.packages.x86_64-linux.default;
  # systemctl status --user xdg-desktop-portal-gnome
  /*
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
    config = {
      common.default = [ "kde" ];
    };
  };
  */

  environment = {
    systemPackages = with pkgs; [
      xwayland-satellite # For xwayland support in niri
    ];
  };

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
