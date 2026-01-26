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
              # The designated private ip for this peer in the tunnel.
              # /32 indicates that the ip is single node rather than indicating multiple nodes under a subnet.
              # For our purpose it needs to be /32 since we *only* want traffic for this peer to go to/from this 
              # single IP (point-to-point hub and spoke topology)
              # See: 
              # - https://forum.mikrotik.com/t/only-one-wireguard-peer-working-at-a-time/167740/6
              # - https://github.com/pirate/wireguard-docs#quickstart step 4.
              allowedIPs = [
                "10.10.0.2/32"
              ];
              endpoint = null; # The server doesn't initiate connections to this peer & this peer has a dynamic ip
            }
            # strawberry
            {
              publicKey = "NGxgL+ma7BuPWf7hMnPL6CIqBZ0dbbNRtPVlrhgXQ3M="; # Peer's public key
              allowedIPs = [
                "10.10.0.3/32" # The designated private ip for this peer in the tunnel
              ];
              endpoint = null; # The server doesn't initiate connections to this peer & this peer has a dynamic ip
            }

            # marshmello
            {
              publicKey = "Afdhae3lrlCsOMmevu594p6MCRt9yreU3FlsRzk12Sw="; # Peer's public key
              allowedIPs = [
                "10.10.0.4/32" # The designated private ip for this peer in the tunnel
              ];
              endpoint = null; # The server doesn't initiate connections to this peer & this peer has a dynamic ip
            }

            # obsidian
            {
              publicKey = "oy+U9lTUFKrjdlRtOBrdJkmxbJYMh4sqVx+7DuqosiU="; # Peer's public key
              allowedIPs = [
                "10.10.0.5/32" # The designated private ip for this peer in the tunnel
              ];
              endpoint = null; # The server doesn't initiate connections to this peer & this peer has a dynamic ip
            }

            # slate
            {
              publicKey = "m7DjsJCdl8K6oGMFbJofRDLoYPNWeaYGitdiukzTNE0="; # Peer's public key
              allowedIPs = [
                "10.10.0.6/32" # The designated private ip for this peer in the tunnel
              ];
              endpoint = null; # The server doesn't initiate connections to this peer & this peer has a dynamic ip
            }
          ];
        };
      };
    };
  };
}
