#!/bin/bash

# Check network connection
if ping -c 1 8.8.8.8 &> /dev/null
then
    echo "System Network Connectivity = connected"
else
    echo "System Network Connectivity = disconnected"
fi

# Verify certificate
CERT_PATH="/{HOME_PATH}/certificates/skyranger_kit_1.crt"
CA_PATH="/{HOME_PATH}/certificates/cacert.pem"

openssl verify -CAfile "$CA_PATH" "$CERT_PATH" &> /dev/null
if [ $? -eq 0 ]; then
    echo "System Certificate Status = OK"
else
    echo "System Certificate Status = Not OK"
    exit 1
fi

# Check USB connections
USB_COUNT=$(lsusb | grep -v "Linux Foundation" | grep -v "VIA Labs" | wc -l)
if [ $USB_COUNT -eq 2 ]; then
    echo "System USB Devices = 2 out of 2 connected"
else
    echo "System USB Devices = $USB_COUNT out of 2 connected"
fi

# Check if eth0 interface is up or down
ETH0_STATUS=$(cat /sys/class/net/eth0/operstate 2>/dev/null)
if [ "$ETH0_STATUS" = "up" ]; then
    echo "System Tech Interface = up"
else
    echo "System Tech Interface = down"
fi
