{ config, pkgs, ... }:{
  # Don't forget to create and add a password for a user: `sudo smbpasswd -a <user>`
  services.samba = {
    enable = true;
    openFirewall = true;
    # See https://wiki.nixos.org/wiki/Samba for template
    # See https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html for options
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "${config.networking.hostName}-smb";
        "netbios name" = "${config.networking.hostName}-smb";
        "security" = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "192.168.0. 127.0.0.1 localhost"; # Allow connections from these ip addrs
        "hosts deny" = "0.0.0.0/0"; # Hosts that cannot access, all but hosts allow takes precedence
        "map to guest" = "Never"; # Don't allow guest access
      };
      "Storage" = {
        "path" = "/mnt/Storage/";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        #"force user" = "username";
        #"force group" = "groupname";
      };
    };
  };

  /*
  services.avahi = {
    publish.enable = true;
    publish.userServices = true;
    # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
    nssmdns4 = true;
    # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
    enable = true;
    openFirewall = true;
  };
  */

}
