{pkgs, ...}: {
  # System wide
  programs.git = {
    enable = true;
    config = {
      # Use gnome's libsecret credential manager
      #credential.helper = "${pkgs.git.override {withLibsecret = true;}}/bin/git-credential-libsecret"; # WARNING: this will build git from source

      credential.helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      credential.credentialStore = "cache"; # Using git's built-in credential store. See https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/credstores.md
      credential.cacheOptions = "--timeout 86400";
    };
  };
}
