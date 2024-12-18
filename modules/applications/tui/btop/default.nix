{
  config,
  pkgs,
  ...
}: {

  users.users.${config.username}.packages = with pkgs; [
    btop
  ];

  systemd.user.tmpfiles.users.eXia.rules = [
    "L+ /home/${config.username}/.config/btop/btop.conf - - - - ${./btop.conf}"
  ];

}
