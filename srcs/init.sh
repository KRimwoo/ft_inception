#!/bin/sh
# set -x

ENV_FILE="srcs/.env"

if [ "$(uname)" == "Darwin" ]; then
    # macOS
    BASE_DIR="/Users/$USER/wpdata"
else
    # Linux
    BASE_DIR="/home/$USER/wpdata"
fi

if [ -f "$ENV_FILE" ]; then
    sed -i '' '/^BASE_DIR=/d' "$ENV_FILE"
else
    echo ".env file not found."
fi

echo "BASE_DIR=$BASE_DIR" >> $ENV_FILE

if [ ! -d "$BASE_DIR" ]; then
    echo "Creating $BASE_DIR"
    mkdir -p $BASE_DIR/wordpress
    mkdir -p $BASE_DIR/mariadb
    chown -R $USER:$USER $BASE_DIR
    chmod -R 777 $BASE_DIR
fi
