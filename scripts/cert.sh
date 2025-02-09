#!/bin/sh

# Globals
################################################################
sslDir=/tmp/ssl
numbits=4096
days=365
caCommonName="MyCA"
serverCommonName="owntracks.plantbox-zgmf-x42s.xyz"
clientCommonName="exia"

mkdir -p $sslDir

# Certificate Authority (CA)
################################################################
# Create CA certificate and associated key
openssl req \
    -new \
    -x509 \
    -days $days \
    -extensions v3_ca \
    -keyout ca.key \
    -out ca.crt \
    -nodes \
    -subj "/CN=$caCommonName"

# Server
################################################################
# Generate server key (Without encryption!)
openssl genrsa \
    -out $sslDir/server.key \
    $numbits

# Generate certificate signing request
openssl req \
    -out $sslDir/server.csr \
    -key $sslDir/server.key \
    -subj "/CN=$serverCommonName" \
    -new

# Sign the certificate using the previously created CA
openssl x509 \
    -req \
    -in $sslDir/server.csr \
    -CA $sslDir/ca.crt \
    -CAkey $sslDir/ca.key \
    -CAcreateserial \
    -out $sslDir/server.crt \
    -days $days

# Client
################################################################
# Generate client key
openssl genrsa \
    -out $sslDir/client.key \
    $numbits

# Generate certificate signing request
openssl req \
    -out $sslDir/client.csr \
    -key $sslDir/client.key \
    -subj "/CN=$clientCommonName" \
    -new

# Sign the certificate using the previously created CA
openssl x509 \
    -req \
    -in $sslDir/client.csr \
    -CA $sslDir/ca.crt \
    -CAkey $sslDir/ca.key \
    -CAcreateserial \
    -out $sslDir/client.crt \
    -days $days

