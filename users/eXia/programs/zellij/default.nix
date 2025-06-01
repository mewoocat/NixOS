{config, pkgs, ...}: {
  
  users.users.eXia.packages = with pkgs; [
    zellij
  ];
}
