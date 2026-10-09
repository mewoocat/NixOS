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

  # User config
  hjem.users.eXia.files = {
    ".ssh/config" = {
      #clobber = true;
      text = ''
        Host orchid
          HostName 192.168.0.111
          User eXia
          IdentityFile /run/media/eXia/starfish.private/ssh/orchid
          IdentitiesOnly yes

        Host redwood
          HostName 192.168.0.105
          User root

        Host maple
          HostName mapletreeway.cloud
          user eXia
          # Use the public key instead to tell the gpg-agent which private key to use
          IdentityFile ~/.ssh/maple-yubikey-pgp.pub
          IdentitiesOnly yes

        Host chrysanthemum
            HostName 192.168.0.110
            user eXia
      '';
    };
  };
}
