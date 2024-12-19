{
  config,
  pkgs,
  ...
}: {

  users.users.${config.username}.packages = with pkgs; [
    btop
  ];

  home-manager.users.${config.username} = {
    systemd.user.tmpfiles.rules = [
      "L /home/${config.username}/.config/btop/btop.conf - - - - ${./btop.conf}"
    ];
  };

  # This has issues
  /*
  systemd.user.tmpfiles.users.${config.username}.rules = [
    "L+ /home/${config.username}/.config/btop/btop.conf - - - - ${./btop.conf}"
  ];
  */

}
