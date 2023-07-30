{ pkgs }:

pkgs.writeShellScriptBin "lockScreen2" ''
    echo "what";
    ${pkgs.gtklock}/bin/gtklock;
''
