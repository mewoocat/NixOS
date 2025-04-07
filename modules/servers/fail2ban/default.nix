{pkgs, ...}:{
  # Setup fail2ban which bans IPs that repeatedly fail to login
  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "30m";
    bantime-increment = {
      enable = true;
    };
  };
}
