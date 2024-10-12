#!/bin/bash

# FlexVolume script for CIFS or local direct mount

# Check the command
case "$1" in
  init)
    # Initialization logic
    echo '{"status": "Success"}'
    exit 0
    ;;
  mount)
    # Mount logic
    NAS_HOSTNAME=$2
    LOCAL_PATH=$3
    NAS_SHARE=$4
    MOUNT_DIR=$5
    OPTIONS=$6

    # Check if running on NAS
    if [ "$(hostname)" == "$NAS_HOSTNAME" ]; then
      # Local direct mount
      mount --bind $LOCAL_PATH $MOUNT_DIR
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
