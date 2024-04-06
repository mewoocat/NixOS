# NixOS

### Installation
### Info
- OS: NixOS
- WM: Hyprland
- Widgets: AGS
- Shell: Bash
- Editor: nvim + VSCode
- Theme: pywal + matugen


### Usage

##### Run NeoVim config

Install nix
`sh <(curl -L https://nixos.org/nix/install) --daemon`
`export NIX_CONFIG="experimental-features = nix-command flakes"`

`nix run github:mewoocat/NixOS#nvim`

`nix profile install github:mewoocat/NixOS#nvim`

##### Update
`nix flake update ~/NixOS`

##### Rebuild NixOS
`sudo nixos-rebuild switch --flake /home/eXia/NixOS#scythe`
`sudo nixos-rebuild switch --flake /home/eXia/NixOS#obsidian`

### Screenshots
![Example](https://github.com/mewoocat/NixOS/blob/main/desktop.png)
