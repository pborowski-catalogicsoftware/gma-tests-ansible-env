#!/bin/bash

OS="linux"
TARGET_IP="192.168.129.209"
TARGET_PORT=7321
GMA_SERVICE_NAME="Catalogic.GuardMode.Agent.service"

# Get gma service status
GMA_SERVICE_STATUS=$(systemctl is-active $GMA_SERVICE_NAME)

if [[ $GMA_SERVICE_STATUS == inactive ]]; then
    # Set fallback service status
    GMA_SERVICE_STATUS="absent"
fi

# Get hostname
HOSTNAME=$(hostname)

# UDP string
UDP_STRING="$HOSTNAME $OS $GMA_SERVICE_STATUS"

# Send through UDP
echo -n "$UDP_STRING" > /dev/udp/$TARGET_IP/$TARGET_PORT
