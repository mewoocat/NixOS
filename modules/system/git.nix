{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    config = {
      credential.helper = "${pkgs.git.override {withLibsecret = true;} }/bin/git-credential-libsecret"; 
    };
  };
}
