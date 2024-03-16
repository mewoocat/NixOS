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

##### NeoVim config
`nix run github:mewoocat/NixOS#nvim`
or 
`nix run github:mewoocat/NixOS#nvim --refresh` to refresh the cache




##### Update
`nix flake update ~/NixOS`

##### Rebuild NixOS
`sudo nixos-rebuild switch --flake /home/eXia/NixOS#scythe`
`sudo nixos-rebuild switch --flake /home/eXia/NixOS#obsidian`

##### Rebuild HomeManager
`home-manager switch --flake ~/NixOS#eXia@scythe`
`home-manager switch --flake ~/NixOS#eXia@obsidian`

### Screenshots
![Example](https://github.com/mewoocat/NixOS/blob/main/desktop.png)
