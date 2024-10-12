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

    echo '{"status": "Success"}'
    exit 0
    ;;
  mount)
    # Mount logic
    MOUNT_DIR=$2
    OPTIONS=$3

    # Read parameters from JSON
    PARAMS=$(cat $OPTIONS)
    NAS_HOSTNAME=$(echo $PARAMS | jq -r '.nasHostname')
    NAS_LOCAL_PATH=$(echo $PARAMS | jq -r '.nasLocalPath')
    NAS_SHARE=$(echo $PARAMS | jq -r '.nasShare')

    # Check if running on NAS
    if [ "$(hostname)" == "$NAS_HOSTNAME" ]; then
      # Local direct mount
      mount --bind $NAS_LOCAL_PATH $MOUNT_DIR
    else
      # CIFS mount
      mount -t cifs //$NAS_SHARE $MOUNT_DIR -o $OPTIONS
    fi

    if [ $? -eq 0 ]; then
      echo '{"status": "Success"}'
    else
      echo '{"status": "Failure", "message": "Mount failed"}'
    fi
    exit 0
    ;;
  unmount)
    # Unmount logic
    MOUNT_DIR=$2
    umount $MOUNT_DIR
    if [ $? -eq 0 ]; then
      echo '{"status": "Success"}'
    else
      echo '{"status": "Failure", "message": "Unmount failed"}'
    fi
    exit 0
    ;;
  *)
    echo '{"status": "Not supported"}'
    exit 1
    ;;
esac
