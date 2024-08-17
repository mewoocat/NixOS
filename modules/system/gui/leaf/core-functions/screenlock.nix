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
        # This conditional check is not needed since attempting to run another ags process with same bus name fails
        # Only start lockscreen if it is not already running
        #if ! busctl --user list | grep com.github.Aylur.ags.lockscreen 
        #then
          ${config.home-manager.users.${config.username}.programs.ags.finalPackage}/bin/ags -b lockscreen -c ${config.home-manager.users.${config.username}.home.homeDirectory}/.config/ags/Lockscreen.js
        #fi
      '';
    };
  in {
  
    home.packages = [
      lockScreen
    ];

    # start as part of hyprland, not sway
    systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
    services.swayidle = {
      enable = true;
      extraArgs = [ "-w" ]; # Does this fix multiple calls to lock?
      package = pkgs.swayidle;
      events = [
        {
          event = "before-sleep";
          command = "${lockScreen}/bin/ags-lock";
        }
      ];
      timeouts = [
        {
          timeout = 60 * 15; # 15 minutes
          command = "${lockScreen}/bin/ags-lock";
        }
      ];
    };
  };
}
