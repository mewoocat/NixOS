{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {

  systemd.services = {
    suspend-delay = {
      enable = true;
      description = "Adds a delay for starting the suspend.  Useful for making suspend wait for lockscreen to fully init";
      wantedBy = [ "sleep.target" ];
      before = [ "sleep.target" ]; 
      serviceConfig = {
        Type = "simple";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 3"; 
        ExecStart = "${pkgs.coreutils}/bin/true"; # Do nothing
      };
    };
  };





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

    /*
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
    */

    
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "${lockScreen}/bin/ags-lock";
          #lock_cmd = "swaylock";
          before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 300; # 5 mins
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 540; # 9 mins
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    }; 

  };
}
