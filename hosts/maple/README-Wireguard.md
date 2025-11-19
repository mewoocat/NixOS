# Generating key pairs
```
umask 077 # To make the files r/w only by root
wg genkey > privatekey
wg pubkey < privatekey > publickey
```

# Convert config to qr code
```
qrencode -t ansiutf8 < <wireguard.conf>
```
