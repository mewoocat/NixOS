{config, inputs, ...}: {
  networking = {
    firewall = {
      allowedUDPPorts = [ config.networking.wg-quick.interfaces.wg0.listenPort ];
    };
    wg-quick = {
      interfaces = {
        wg0 = {
          address = [
            "10.10.0.1/24" # The private ip for this server
          ];
          privateKeyFile = inputs.secrets + "/....age"; # Server's private key
          listenPort = "51820"; # Peers initiate connection to this server via this port
          # The devices which can connect to this server

          # This defines all the peers that can connection to this server
          peers = [
            # scythe
            {
              publicKey = ""; # Peer's public key
              allowedIps = [
                "10.10.0.2/24" # The designated private ip for this peer in the tunnel
              ];
              endpoint = null; # The server doesn't initiate connections to this peer & this peer has a dynamic ip
            }

            # obsidian
            {
              publicKey = ""; # Peer's public key
              allowedIps = [
                "10.10.0.3/24" # The designated private ip for this peer in the tunnel
              ];
              endpoint = null; # The server doesn't initiate connections to this peer & this peer has a dynamic ip
            }
          ];
        };
      };
    };
  };
}
