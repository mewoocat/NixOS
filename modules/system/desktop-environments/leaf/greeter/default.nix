{ config, pkgs, ... }: {

  services.greetd = {
    enable = true;
    settings = {
      default_session = let
        niri-config = pkgs.writeText "greeter-niri-config" ''
          spawn-sh-at-startup "qs -p ${../quickshell/config/Windows/Greeter/Shell.qml} && pkill niri"
          hotkey-overlay {
              skip-at-startup
          }
        '';
        in {
        #command = "${pkgs.cage}/bin/cage -s -- qs -p ${./quickshell/config/Windows/Greeter/Shell.qml}";
        command = "niri -c ${niri-config}";
        user = "greeter"; # User to run command as
      };
    };
  };

}
