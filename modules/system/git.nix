{
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.${config.username} = {
    programs.git = {
      enable = true;
      extraConfig = {
        credential.helper = "${
          pkgs.git.override {withLibsecret = true;}
        }/bin/git-credential-libsecret";
      };
    };
  };
}
