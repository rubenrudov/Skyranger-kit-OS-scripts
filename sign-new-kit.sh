#!/bin/bash

# Author: Ruben Rudov
# Description: Shell script for signing SSL certificate for skyranger device

# Function for printing script usage info
usage() {
    echo "$(date) Information: Usage: $0 <skyranger_component> <rpi_ip> <rpi_directory>"
    exit 1
}

# Validate parameters, if not equal to 3 output usage() function
if [ $# -ne 3 ]; then
    usage
fi

# Argument variables
SKYRANGER_COMPONENT=$1
RPI_IP=$2
RPI_DIR=$3

# CA Directories
CA_DIR="/root/ca"
PRIVATE_KEY="$CA_DIR/private"
CERT_DIR="$CA_DIR/certs"
CSR_DIR="$CA_DIR/csr"
CA_CERT="$CA_DIR/cacert.pem"

# PC User
RPI_USER="ruby"

# 1) Genetate private key
echo "$(date) Information: Generating 2048 bits key for $SKYRANGER_COMPONENT in: $PRIVATE_KEY/$SKYRANGER_COMPONENT.key"
openssl genrsa -out "$PRIVATE_KEY/$SKYRANGER_COMPONENT.key" 2048

# 2) Generate a CSR (Certificate Signing Request)
echo "$(date) Information: Generating CSR for $SKYRANGER_COMPONENT in: $CSR_DIR/$SKYRANGER_COMPONENT"
openssl req -new -key "$PRIVATE_KEY/$SKYRANGER_COMPONENT.key" -out "$CSR_DIR/$SKYRANGER_COMPONENT.csr" -subj "/C=US/ST=Israel/L=Rishon/O=skyranger/OU=IT/CN=$SKYRANGER_COMPONENT"

# 3) Sign the CSR and grant a certificate
echo "$(date) Information: Signing $SKYRANGER_COMPONENT"
openssl ca -config "$CA_DIR/openssl.cnf" -in "$CSR_DIR/$SKYRANGER_COMPONENT.csr" -out "$CERT_DIR/$SKYRANGER_COMPONENT.crt" -days 365

# 4) SCP the certificate the Windows PC
echo "$(date) Information: Transferring files to skyranger kit RPI ($RPI_IP).."
scp "$CERT_DIR/$SKYRANGER_COMPONENT.crt" "$PRIVATE_KEY/$SKYRANGER_COMPONENT.key" "$CA_CERT" "$RPI_USER@$RPI_IP:$RPI_DIR"

# Check if SCP succeeded
if [ $? -eq 0  ]; then
    echo "$(date) Information: Files successfully transferred to $WINDOWS_IP:$WINDOWS_DIR"
else
    echo "$(date) Critical: Failed to transfer files to $WINDOWS_IP"
    exit 2
fi

echo "$(date) Information: finished signing process for: $SKYRANGER_COMPONENT"