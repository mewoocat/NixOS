
# Tools
```
nix-shell -p wireguard-tools
```

# Generating key pairs
```sh
umask 077 # To make the files r/w only by root
wg genkey > privatekey # Generate private key
wg pubkey < privatekey > publickey # Generate public key from private key
```

# Convert config to qr code
```sh
qrencode -t ansiutf8 < <wireguard.conf>
```
