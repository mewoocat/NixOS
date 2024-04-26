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
All inputs
`nix flake update ~/NixOS`
A particular input
`nix flake lock --update-input input_name`

##### Rebuild NixOS
`sudo nixos-rebuild switch --flake /home/eXia/NixOS#$(hostname)`

### Screenshots
![Example](https://github.com/mewoocat/NixOS/blob/main/desktop-2.png)
