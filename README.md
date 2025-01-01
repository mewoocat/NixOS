# Overview
My personal NixOS system flake.  

![](./assets/powered-by-nixos.gif)

![Example](https://github.com/mewoocat/NixOS/blob/main/assets/desktop-4.png)
|   |   |
| - | - |
| Window Manager | Hyprland
| Shell | AGS
| Editor | nvim-nvf
| Terminal | Foot

# Installation
*Warning* These instructions are somewhat incomplete
1. Follow the [NixOS manual](https://nixos.org/manual/nixos/stable/) to get the Minimal NixOS base system installed. 
2. Clone this repo to ~/
```
git clone https://github.com/mewoocat/NixOS.git
```
3. Create a host configuration in `~/NixOS/hosts/`
- This usually involves copying the `hardware-configuration.nix` that was generated automatically by NixOS during the initial install

4. Rebuild & Reboot
```
nixos-rebuild --use-remote-sudo switch --flake ~/NixOS#$(hostname)
reboot
```

# Usage
## Updating
#### All inputs
```
nix flake update ~/NixOS`
```
#### A particular input
```
nix flake update <input_name>
```

## Rebuild NixOS configuration
```
nixos-rebuild --use-remote-sudo switch --flake ~/NixOS#$(hostname)
```
or use the bash alias
```
rebuild
```

# Credits
- home-manager: for showing me how to do home management without home manager 
- raf: for answering my stupid questions
### Honorable mentions
- nixpkgs src

