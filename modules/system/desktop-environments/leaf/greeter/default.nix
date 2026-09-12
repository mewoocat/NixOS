{ config, pkgs, ... }: {

  services.greetd = {
    enable = true;
    settings = {
      default_session = let
        niri-config = pkgs.writeText "greeter-niri-config" ''
          spawn-sh-at-startup "qs -p ${../quickshell/config/Windows/Greeter/Shell.qml}"
        '';
        in {
        #command = "${pkgs.cage}/bin/cage -s -- qs -p ${./quickshell/config/Windows/Greeter/Shell.qml}";
        command = "${config.programs.niri.package}/bin/niri -c ${niri-config}";
        #user = "eXia"; # Set user to auto login
        user = "greeter";
      };
    };
  };

}
