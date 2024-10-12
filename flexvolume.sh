#!/bin/bash

# FlexVolume script for CIFS or local direct mount

# Check the command
case "$1" in
  init)
    # Initialization logic
    # Check for dependencies
    if ! command -v jq &> /dev/null; then
      echo '{"status": "Failure", "message": "jq is not installed"}'
      exit 1
    fi

    if ! command -v mount.cifs &> /dev/null; then
      echo '{"status": "Failure", "message": "mount.cifs is not installed"}'
      exit 1
    fi

    echo '{"status": "Success", "capabilities": {"attach": false}}'
    exit 0
    ;;
  mount)
    # Mount logic
    MOUNT_DIR=$2
    OPTIONS=$3

    # Read parameters from JSON
    PARAMS=$(cat "$OPTIONS")
    NAS_HOSTNAME=$(echo "$PARAMS" | jq -r '.nasHostname')
    NAS_LOCAL_PATH=$(echo "$PARAMS" | jq -r '.nasLocalPath')
    NAS_SHARE=$(echo "$PARAMS" | jq -r '.nasShare')

    # Check if running on NAS
    if [ "$(hostname)" == "$NAS_HOSTNAME" ]; then
      # Local direct mount
      ERROR_MSG=$(mount --bind "$NAS_LOCAL_PATH" "$MOUNT_DIR" 2>&1)
    else
      # CIFS mount
      ERROR_MSG=$(mount -t cifs //"$NAS_SHARE" "$MOUNT_DIR" -o "$OPTIONS" 2>&1)
    fi

    if [ "$?" -eq 0 ]; then
      echo '{"status": "Success"}'
    else
      echo "{\"status\": \"Failure\", \"message\": \"Mount failed: $(jq -R . <<< "$ERROR_MSG")\"}"
    fi
    exit 0
    ;;
  unmount)
    # Unmount logic
    MOUNT_DIR=$2
    ERROR_MSG=$(umount "$MOUNT_DIR" 2>&1)
    if [ "$?" -eq 0 ]; then
      echo '{"status": "Success"}'
    else
      echo "{\"status\": \"Failure\", \"message\": \"Unmount failed: $(jq -R . <<< "$ERROR_MSG")\"}"
    fi
    exit 0
    ;;
  *)
    echo '{"status": "Not supported"}'
    exit 1
    ;;
esac
