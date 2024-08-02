{
  config,
  pkgs,
  ...
}: {

  imports = [
    ./btop
    ./zellij
  ];
}
