sudo nixos-rebuild switch --flake ~/myNixOSConfig#nixos
systemctl --user restart udiskie
systemctl --user restart swayidle

