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

  services.hypridle = {
    enable = true;
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
