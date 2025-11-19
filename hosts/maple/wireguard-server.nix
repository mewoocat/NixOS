{config, inputs, ...}: {
  age.secrets = {
    wireguard-maple.file = inputs.secrets + "/wireguard-maple.age";
  };

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
          privateKeyFile = config.age.secrets.wireguard-maple.path; # Server's private key
          listenPort = 51820; # Peers initiate connection to this server via this port
          # The devices which can connect to this server

          # This defines all the peers that can connection to this server
          peers = [
            # scythe
            {
              publicKey = "S3pdgCs5SSZlWb9mYfW0HZ/8CGl/0GMOebGGzLSNOA4="; # Peer's public key
              allowedIPs = [
                "10.10.0.2/24" # The designated private ip for this peer in the tunnel
              ];
              endpoint = null; # The server doesn't initiate connections to this peer & this peer has a dynamic ip
            }

            # obsidian
            /*
            {
              publicKey = ""; # Peer's public key
              allowedIPs = [
                "10.10.0.3/24" # The designated private ip for this peer in the tunnel
              ];
              endpoint = null; # The server doesn't initiate connections to this peer & this peer has a dynamic ip
            }
            */

            # strawberry
            {
              publicKey = "NGxgL+ma7BuPWf7hMnPL6CIqBZ0dbbNRtPVlrhgXQ3M="; # Peer's public key
              allowedIPs = [
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
