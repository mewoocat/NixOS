sudo nixos-rebuild switch --flake ~/myNixOSConfig#scythe
systemctl --user restart udiskie
systemctl --user restart swayidle

