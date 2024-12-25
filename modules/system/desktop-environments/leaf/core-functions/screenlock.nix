{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  lockScreen = pkgs.writeShellApplication {
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
    lockScreen
  ];

  systemd.user.services.hypridle = {
    enable = true;
    after = [ "graphical.target" ];
    wantedBy = [ "graphical.target" ];
    description = "hypridle service";
    # Add programs to the service's PATH env variable
    path = [
      pkgs.coreutils
      lockScreen # For the ags-lock command
    ];
    /*
    serviceConfig = {
        Type = "simple";
        ExecStart = ''echo $PATH; ${pkgs.hypridle}/bin/hypridle'';
    };
    */

    # This will ExecStart this script which has access to the paths provided
    script = "${pkgs.hypridle}/bin/hypridle";
  };

  # hypridle config
  homes.eXia = {
    enable = true;
    files = {
      ".config/hypr/hypridle.conf" = {
        source = ./hypridle.conf;
        clobber = true;
      };
    };
  };
}
