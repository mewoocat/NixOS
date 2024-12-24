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
          ags -b lockscreen -c ~/.config/ags/Lockscreen.js
        #fi
      '';
    };
  in {
  
    home.packages = [
      lockScreen
    ];
    
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
