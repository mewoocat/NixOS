{
  config,
  inputs,
  ...
}: {
  age.secrets = {
    wireguard-maple.file = inputs.secrets + "/wireguard-maple.age";
  };

  # Setup in a hub and spoke topology
  networking = {
    firewall = {
      allowedUDPPorts = [config.networking.wg-quick.interfaces.wg0.listenPort];
    };
    wg-quick = {
      interfaces = {
        # Keep in mind that a "server" in a wireguard network is just a peer like any other machines in the network.
        wg0 = {
          # This defines the specific ip address of this server in the VPN and the CIDR suffix describes the structure
          # of the subnet.  This determines the routing behavior when this peer recieves traffic destined for a different
          # peer in the subnet.  If /32 (single ip address) is used, then this peer won't forward any traffic.
          # Otherwise it will route traffic to other peers within the specified ip address range.
          #
          # Note that meaning of the CIDR suffix is different for the `allowedIPs` option.  In this case it refers
          # to all the possible ip addresses that it will accept traffic for given the public key.  Use /32 for allowedIPs
          # if that connecting peer is configured to only use a single ip address.
          #
          # See: https://github.com/pirate/wireguard-docs/issues/73
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

            # redwood
            {
              publicKey = "95fo14bvMXDjB0ZgJSGv3R6n3cCYK/aQ0f2QNcmLEGE=";
              allowedIPs = [
                "10.10.0.7/32"
              ];
              endpoint = null;
            }
          ];
        };
      };
    };
  };
}
