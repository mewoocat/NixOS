{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  system.stateVersion = "24.11";

  nix = {
    settings = {    
      # Enable flakes
      experimental-features = ["nix-command" "flakes"];
    };
  };

  # Networking
  networking = {
    hostName = "maple";
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPortRanges = [];
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    allowSFTP = false; # Not using this
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      LogLevel = "VERBOSE";
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${system}".default # Agenix client
    inputs.myNvimNvf.packages.x86_64-linux.default # My nvim config
  ];

  users.users.root= {
    hashedPassword = "$y$j9T$Pb8ERrwDCIQE4HqB15PA60$ykb7An0BUxkXmQjWTYUPsqdhwaOvDmLnZTkbIL0bLU7";
    /*
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXBdJRFkW98CfT+M+NNopY0XOHa2I/zcXA60oQXAtt8paKo+JpmNOadnZXtlHPEQflDz3XntN0Au4sIMHNOBO6KkMcg3Ti1LyVtsi0s6Hw8pB6c6hHZfqx1TxAQyiq8CsUE0eaTY7fDyIiVkL1p9ZR7M4tqrbgh+FVFRJQ0Jb24q85VApxyfzQ+93preM4Vg25gKQBe822jvc+1MW1dt90aYy2Ubz7RRKpGRmnUSvL5qTo++CDDUNvmkVNftyv89hfSikGWERdLNnwTFkbHCZ38cF41zbk8M9X4CKXOfV+DwtErcZjIFU6Xh70t5tpow461FCIWd+I2ekreBlUIDPQhvQ1oiukAvy46ZpoBcyxpBj5nZbtt9ftYzvvIBEQ042042D2PmsKhmT5io7fkPPq4c3Mh9enNdq6zc2PIa/stPDTDSeHxzSMVXpl7yfHfaFZhfRWAmRZ3l1mhuToCqeCkVvm61KgaPSBBsQEPrFsAhW7lLaaedwlR8mvRatmH4k= NixOS anywhere testing"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0/QfL5fsRr2E0JGv8aOLTU0npRl2Mj6yHCZaU+2pae eXia@scythe"
    ];
    */
  };

  time.timeZone = "America/Chicago";

  users.users.eXia = {
    isNormalUser = true;
    extraGroups = ["wheel" "video"]; # Enable ‘sudo’ for the user.
    hashedPassword = "$y$j9T$Pb8ERrwDCIQE4HqB15PA60$ykb7An0BUxkXmQjWTYUPsqdhwaOvDmLnZTkbIL0bLU7";
    # Set ssh public keys
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBO24z1xI9hHgqMr7pHYxj9vQCjkIqnFrRvK6lcOu9h+"
    ];
    packages = with pkgs; [
    ];
  };

}
