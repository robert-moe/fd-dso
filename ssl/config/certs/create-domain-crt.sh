
#!/bin/sh

if [ "$#" -ne 1 ]
then
  echo "Usage: Must supply a domain"
  exit 1
fi

pass="devsecops"
DOMAIN=$1

openssl genrsa -out $DOMAIN.key 2048
openssl req -new -key $DOMAIN.key -out $DOMAIN.csr -subj "/C=US/ST=Oklahoma/L=Fort Sill/O=CECOM SEC/OU=Fires Division/CN=$DOMAIN"

cat > $DOMAIN.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $DOMAIN
EOF

openssl x509 -req -in $DOMAIN.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out $DOMAIN.crt -days 1095 -passin pass:$pass -extfile $DOMAIN.ext

# TODO: Error handling.
# Need to determine that the certificate was successfully created, no errors, before attempting to move and delete the certificate artifacts.

# Move Key and Certificate to the nginx SSL staging area
mv $DOMAIN.key ../config/nginx/ssl/$DOMAIN.key
mv $DOMAIN.crt ../config/nginx/ssl/$DOMAIN.crt

# Delete the unused .ext and csr file
rm $DOMAIN.ext
rm $DOMAIN.csr
