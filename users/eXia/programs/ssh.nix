{...}: {
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

        Host redwood_initrd
          HostName 192.168.0.105
          User eXia
          IdentityFile ~/.ssh/maple-yubikey-pgp.pub

        Host maple
          HostName mapletreeway.cloud
          user eXia
          # Use the public key instead to tell the gpg-agent which private key to use
          IdentityFile ~/.ssh/maple-yubikey-pgp.pub
          IdentitiesOnly yes

        Host chrysanthemum
            HostName 192.168.0.110
            user eXia

        Host obsidian
          HostName 192.168.0.113
          user eXia
      '';
    };
  };
}
