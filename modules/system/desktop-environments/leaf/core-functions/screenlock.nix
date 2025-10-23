{
  config,
  pkgs,
  inputs,
  ...
}: let
  ags-lockscreen = pkgs.writeShellApplication {
    name = "ags-lock";
    runtimeInputs = with pkgs; [  
      # Need ags 
      (inputs.ags.packages.${pkgs.system}.default.override {
        extraPackages = with pkgs;[
          gtk-session-lock
        ];
      })
      coreutils # idk if this is needed anymore
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

  qs-lockscreen = pkgs.writeShellApplication {
    name = "qs-lock";
    runtimeInputs = [   
      inputs.quickshell.packages.${pkgs.system}.default
    ];
    text = '' 
      quickshell ipc call control lockScreen
    '';
  };
in{

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

  users.users.${config.username}.packages = [
    ags-lockscreen
    qs-lockscreen
  ];

  systemd.user.services.hypridle = {
    enable = true;
    description = "hypridle service";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    unitConfig = {
      ConditionEnvironment = "WAYLAND_DISPLAY"; # Only start if WAYLAND_DISPLAY env var is set
    };
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      /*
      Environment = [
        "PATH=${lockScreen}/bin/ags-lock"
      ];
      ExecStart = ''${pkgs.hypridle}/bin/hypridle'';
      */
    };
    # Reload the service if any of these change
    reloadTriggers = [
      #ags-lockscreen
      qs-lockscreen
    ];

    # Add programs to the service's PATH env variable
    path = [
      #ags-lockscreen # For the ags-lock command
      qs-lockscreen
      config.programs.hyprland.package # For hyprctl
    ];

    # This will ExecStart this script which has access to the paths provided
    script = "${pkgs.hypridle}/bin/hypridle";
  };

  # hypridle config
  hjem.users.eXia = {
    enable = true;
    files = {
      ".config/hypr/hypridle.conf" = {
        source = ./hypridle.conf;
        clobber = true;
      };
    };
  };
}
