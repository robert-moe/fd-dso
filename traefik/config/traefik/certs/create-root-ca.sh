#!/bin/bash

pass="devsecops"

# Create rootCA certificate
echo "================ Generating CA Key ================"
openssl genrsa -des3 -out ca.key -passout pass:$pass 4096
echo "================ Generating CA Certificate Request ================"
openssl req -x509 -new -nodes -key ca.key -sha256 -days 1825 -passin pass:$pass -out ca.crt -subj "/C=US/ST=Oklahoma/L=Fort Sill/O=CECOM SEC/OU=Fires Division/CN=Fires Division DevSecOps Root CA"