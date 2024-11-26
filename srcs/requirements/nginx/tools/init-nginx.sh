#!/bin/sh
# set -x

SSL_DIR="/etc/nginx/ssl"
DOMAIN="$DOMAIN"

echo "DOMAIN is set to: $DOMAIN"
echo "SSL_DIR is set to: $SSL_DIR"

# SSL 인증서 생성
if [ ! -f "$SSL_DIR/$DOMAIN.crt" ] || [ ! -f "$SSL_DIR/$DOMAIN.key" ]; then
    mkdir -p $SSL_DIR

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout $SSL_DIR/$DOMAIN.key \
        -out $SSL_DIR/$DOMAIN.crt \
        -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Cadet/CN=$DOMAIN"

    chmod 600 $SSL_DIR/$DOMAIN.key $SSL_DIR/$DOMAIN.crt
    echo "SSL certificate generated."
else
    echo "SSL certificate already exists."
fi

ls -lR $SSL_DIR


# Nginx 시작
echo "Starting Nginx..."
nginx -g "daemon off;"