#!/bin/bash

# Check if REMOTE_IP is provided
if [ -z "$REMOTE_IP" ]; then
    echo "Error: REMOTE_IP environment variable is required"
    exit 1
fi

# Replace REMOTE_IP placeholder in nginx config
sed -i "s/REMOTE_IP/$REMOTE_IP/g" /etc/nginx/conf.d/default.conf

# Execute CMD
exec "$@"
