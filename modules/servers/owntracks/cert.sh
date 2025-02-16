#!/bin/sh

# Usage
################################################################
# ./cert.sh <install_dir> <CA_Common_Name> <Server_Common_Name> <Server_Domain_Name> <Client_Common_Name>

# Args
################################################################
sslDir=$1
caCommonName=$2
serverCommonName=$3
serverDomainName=$4
clientCommonName=$5

# Globals
################################################################
numbits=4096
days=365

# Create the dir if it doesn't exist
mkdir -p "$sslDir"

# Certificate Authority (CA)
################################################################
# Only generates ca.key and ca.crt if either doesn't exist
if test ! -f "$sslDir/ca.key" || test ! -f "$sslDir/ca.crt"; then 
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
fi

# Server
################################################################
# Only generates server.key and server.crt if either doesn't exist
if test ! -f "$sslDir/server.key" || test ! -f "$sslDir/server.crt"; then 
    # Generate server key (Without encryption!)
    openssl genrsa \
        -out "$sslDir/server.key" \
        $numbits

    # Generate certificate signing request
    openssl req \
        -out "$sslDir/server.csr" \
        -key "$sslDir/server.key" \
        -subj "/CN=$serverCommonName" \
        -addext "subjectAltName = DNS:$serverDomainName" \
        -new

    # Sign the certificate using the previously created CA
    # Note that "-copy_extensions copy" is needed to copy the 
    # subject alt name from the csr
    openssl x509 \
        -req \
        -in "$sslDir/server.csr" \
        -CA "$sslDir/ca.crt" \
        -CAkey "$sslDir/ca.key" \
        -CAcreateserial \
        -out "$sslDir/server.crt" \
        -copy_extensions copy \
        -days "$days"
fi

# Client
################################################################
# Only generates client.key and client.crt if either doesn't exist
if test ! -f "$sslDir/client.key" || test ! -f "$sslDir/client.crt"; then 
    # Generate client key
    openssl genrsa \
        -out "$sslDir/client.key" \
        $numbits

    # Generate certificate signing request
    openssl req \
        -out "$sslDir/client.csr" \
        -key "$sslDir/client.key" \
        -subj "/CN=$clientCommonName" \
        -new

    # Sign the certificate using the previously created CA
    openssl x509 \
        -req \
        -in "$sslDir/client.csr" \
        -CA "$sslDir/ca.crt" \
        -CAkey "$sslDir/ca.key" \
        -CAcreateserial \
        -out "$sslDir/client.crt" \
        -days $days
fi
