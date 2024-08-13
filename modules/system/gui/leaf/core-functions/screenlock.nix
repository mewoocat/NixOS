{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home-manager.users.${config.username} = let
    lockScreen = pkgs.writeShellApplication {
      name = "ags-lock";
      runtimeInputs = with pkgs; [
        coreutils
        sassc
      ];
      text = ''
       
        # TODO: Not sure if this is working
        # Only start lockscreen if it is not already running
        if ! busctl --user list | grep com.github.Aylur.ags.lockscreen 
        then
          ${config.home-manager.users.${config.username}.programs.ags.finalPackage}/bin/ags -b lockscreen -c ${config.home-manager.users.${config.username}.home.homeDirectory}/.config/ags/Lockscreen.js
        fi
      '';
    };
  in {
    # start as part of hyprland, not sway
    systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
    services.swayidle = {
      enable = true;
      package = pkgs.swayidle;
      events = [
        {
          event = "before-sleep";
          command = "${lockScreen}/bin/ags-lock";
        }
      ];
      timeouts = [
        {
          timeout = 60 * 10; # 10 minutes
          command = "${lockScreen}/bin/ags-lock";
        }
      ];
    };
  };
}
