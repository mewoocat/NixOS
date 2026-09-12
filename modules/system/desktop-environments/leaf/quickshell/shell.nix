let
  # Use nixpkgs from NIX_PATH env var
  pkgs = import <nixpkgs> {};
in pkgs.mkShell {

  # Packages available in shell
  packages = with pkgs; [
    lolcat
  ];

  # Startup script hook
  shellHook = ''
    echo "Entering quickshell dev shell..." 2>&1 # idk why this doesn't output
    touch ./config/.qmlls.ini
  '';
}
