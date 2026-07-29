# Overview

My NixOS system conigurations.

![](./assets/powered-by-nixos.gif)

![Example](https://github.com/mewoocat/NixOS/blob/main/assets/desktop-4.png)

# Installation

1. Follow the [NixOS manual](https://nixos.org/manual/nixos/stable/) to get the
   Minimal NixOS base system installed onto the desired machine.
2. Clone this repo onto the machine and note it's path

```
git clone https://github.com/mewoocat/NixOS.git
```

3. Create a host configuration in `NixOS/hosts/`

- This usually involves copying the `hardware-configuration.nix` that was
  generated automatically by NixOS during the initial install

4. Add a nixos system as an attribute to the set returned by `./default.nix`
```nix
  <hostname> = makeNixosSystem ./host/<hostname>/configuration.nix;
```

5. Rebuild & Reboot
Install nix helper into the active shell
```sh
nix-shell -p nh
```

Rebuild the system
```
nh os switch -f <Path/to/NixOS> <hostname>
reboot
```

# Usage

## Updating inputs
Use the `tack` command to manage inputs or manually modify entries within the `./.tack/pins.toml` config file

## Rebuilding
```
nh os switch -f <Path/to/NixOS> <hostname>
```

# Credits
- home-manager: for showing me how to do home management without home manager
- raf: for answering my stupid questions

### Honorable mentions
- nixpkgs src
