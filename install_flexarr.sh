#!/bin/bash

# Update package list
sudo apt update

# Install prerequisites
sudo apt install -y jq cifs-utils

# Define the FlexVolume directory for k3s
FLEXVOLUME_DIR="/usr/libexec/kubernetes/kubelet-plugins/volume/exec/ninefives.online~flexarr"

# Create the directory if it doesn't exist
sudo mkdir -p "$FLEXVOLUME_DIR"

# Copy the flexarr script to the FlexVolume directory
sudo cp flexarr "$FLEXVOLUME_DIR/"

# Ensure the script has execute permissions
sudo chmod +x "$FLEXVOLUME_DIR/flexarr"

echo "Flexarr driver installed successfully."
