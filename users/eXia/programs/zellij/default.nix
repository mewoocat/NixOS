{config, pkgs, ...}: {
  
  users.users.eXia.packages = with pkgs; [
    zellij
  ];   
  hjem.users.eXia = {
    enable = true;
    files = {
      ".config/zellij" = {
        source = ./config;
        clobber = true;
      };
    };
  };
}
