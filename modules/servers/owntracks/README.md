# OwnTracks Config

## Description

My personal OwnTracks server config.  I need to make this into a generic module.

## Usage

### Server Setup

When rebuilding, the file `/var/spool/owntracks/recorder/store/ghash/data.mdb` will be checked for existence.  If it doesn't exist then the owntracks-recorder database will be initialized.

This server uses port 8883 for MQTT connection of TLS.  It needs to be port forwarded.

Other than that, everything should be read to go regarding the server setup.

### Client Setup

The TLS certificates used are self-signed so the Certificate Authority certificate (ca.crt) will need to be installed on any clients. Also, this configuration requires a client certifcate to be able to authorize a connection in addition to the username and password.

These certificates are generated at `/etc/ssl/certs/owntracks` by default.

#### Installing CA Certificate

Copy the ca.crt file to the client device and install it.

**iOS Note** The certifcate will be untrusted by default so it should be manually marked as trusted from within Settings > General > About > Certificate Trust Settings

#### Installing Client Certificate

To install the client certificate an extra step is needed to prepare the cert and key.  The OwnTracks client requires the client certificate to be in this password protected format.

#### Location Mode

See the (OwnTracks Guide)[https://owntracks.org/booklet/features/location/] for location mode information

Note that the *Significant* location mode will only update if the device traveled 500m in 5min (iOS) or every 15 min (Android).  For real-time constant updates, use the move mode and make sure the `locatorInterval` and `locatorDisplacement` client options are configured as desired.

```sh
openssl pkcs12 -legacy -export -in client.crt -inkey client.key -name "Owntracks Client Certificate" -out client.p12
```

To install, copy the outputted `client.p12` to the client device and install it.  It should then be available to use within the OwnTracks client.

*iOS Note* The `client.p12` file will need to have it's extension renamed to `.otrp` in order iOS to recognize it as a OwnTracks app config.

## Credits

- https://owntracks.org/booklet/features/tlscert/
- https://github.com/owntracks/recorder
- https://github.com/owntracks/quicksetup
- https://github.com/owntracks/tools/blob/master/TLS/generate-CA.sh
- http://www.steves-internet-guide.com/creating-and-using-client-certificates-with-mqtt-and-mosquitto/
- https://github.com/RyanGibb/nixos/blob/a5cf3192e5d2d47049e111804fbe8f7d0ac22b33/hosts/elephant/owntracks.nix
