{pkgs, ...}: {
  programs.git = {
    enable = true;
    config = {
      # Use gnome's libsecret credential manager
      #credential.helper = "${pkgs.git.override {withLibsecret = true;}}/bin/git-credential-libsecret"; # WARNING: this will build git from source

      credential.helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      credential.credentialStore = "none";
    };
  };

  users.users.eXia.packages = with pkgs; [
    pass # password manager/store to store git secrets
  ];
}
