see: https://nixos.org/manual/nixos/stable/#sec-image-nixos-rebuild-build-image
iso-image nixos module: https://github.com/ilian/nixpkgs/blob/14839f12f2bbcc452dabf8e40d18b53af166a7c2/nixos/modules/installer/cd-dvd/iso-image.nix

There are multiple ways to generate iso images
- Using `nixos-rebuild build-image --image-variant <variant>`
    - This method is intended to merge the config from the specified variant and the nixos configuration at the `$NIX_PATH` env var's `nixos-config`` value
    - image variants: https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/image/images.nix
- Using `nix-build` and a file that imports a defined config like `nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix`
    - This is the approch used for the `build-iso.sh` script
- Using `nh os build-image`
    - Should look into this in the future

