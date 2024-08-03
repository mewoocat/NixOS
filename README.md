# NixOS

My personal NixOS system

# Overview

![Example](https://github.com/mewoocat/NixOS/blob/main/assets/desktop-3.png)
|   |   |
| - | - |
| Window Manager | Hyprland
| Widgets | AGS
| Editor | nvim
| Terminal | Foot

# Installation
i forgor

# Usage
### Updating
##### All inputs
```
nix flake update ~/NixOS`
```
##### A particular input
```
nix flake lock --update-input <input_name>
```
or
```
nix flake update <input_name>
```

### Rebuild NixOS configuration
```
nixos-rebuild --use-remote-sudo switch --flake ~/NixOS#$(hostname)
```
or use the bash alias
```
rebuild
```

