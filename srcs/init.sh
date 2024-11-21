#!/bin/bash
set -x
ENV_FILE="srcs/.env"

if [ "$(uname)" == "Darwin" ]; then
    # macOS
    BASE_DIR="/Users/$USER/wpdata"
else
    # Linux
    BASE_DIR="/home/$USER/wpdata"
fi

echo "BASE_DIR=$BASE_DIR" >> $ENV_FILE

# 볼륨 삭제 처리
if [ "$2" == "--delete" ]; then
    echo "Deleting volumes..."
    rm -rf "$BASE_DIR"
    echo "Delete COMPLETE"

    if [ -f "$ENV_FILE" ]; then
        sed -i '' '/^DATA_PATH=/d' "$ENV_FILE"
    else
        echo ".env file not found. Skipping DATA_PATH removal."
    fi
    exit 0
fi

if [ ! -d "$BASE_DIR" ]; then
    echo "Creating $BASE_DIR"
    mkdir -p $BASE_DIR/wordpress
    mkdir -p $BASE_DIR/mariadb
    chown -R $USER:$USER $BASE_DIR
    chmod -R 777 $BASE_DIR
fi

if [ -f "$ENV_FILE" ]; then
    sed -i '' '/^DATA_PATH=/d' "$ENV_FILE"
else
    echo ".env file not found."
fi

if ! grep -q "DATA_PATH=" "$ENV_FILE"; then
    if [ -s "$ENV_FILE" ] && [ "$(tail -c 1 "$ENV_FILE" | wc -l)" -eq 0 ]; then
        echo "" >> $ENV_FILE
    fi
    echo "DATA_PATH=$BASE_DIR" >> "$ENV_FILE"
fi