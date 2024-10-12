# FlexVolume Driver for Kubernetes

## Overview

This is a Kubernetes FlexVolume driver that mounts a share over CIFS from a NAS device. If the pod is running on the NAS device itself, it will use a local direct mount instead.

## Features

- **CIFS Mounting**: Mounts network shares using the CIFS protocol.
- **Local Direct Mount**: If the pod is on the NAS, it uses a direct mount for efficiency.
- **JSON Configuration**: Uses JSON for configuration, making it easy to integrate with Kubernetes.

## Prerequisites

- `jq` must be installed for JSON parsing.
- `mount.cifs` must be installed for CIFS mounting.

## Installation

### General Steps

1. Ensure `jq` and `mount.cifs` are installed on your system.
2. Copy the `flexvolume.sh` script to your FlexVolume directory.

### Distribution-Specific Instructions

#### Ubuntu/Debian

```bash
sudo apt update
sudo apt install -y jq cifs-utils
```

#### CentOS/RHEL

```bash
sudo yum install -y epel-release
sudo yum install -y jq cifs-utils
```

#### Fedora

```bash
sudo dnf install -y jq cifs-utils
```

#### Arch Linux

```bash
sudo pacman -Syu jq cifs-utils
```

#### openSUSE

```bash
sudo zypper refresh
sudo zypper install -y jq cifs-utils
```

After installing the dependencies, ensure the `flexvolume.sh` script is executable and placed in the appropriate directory for your Kubernetes setup.

## Usage

The script supports the following commands:

- `init`: Initializes the driver and checks for dependencies.
- `mount`: Mounts the specified share or local path.
- `unmount`: Unmounts the specified directory.

### Example

To mount a share, use the following command:

```bash
./flexvolume.sh mount <mount_dir> <options_file>
```

## Troubleshooting

- **Dependency Errors**: Ensure `jq` and `mount.cifs` are installed and accessible in your PATH.
- **Mount Errors**: Check `mount_error.log` for detailed error messages.
- **Unmount Errors**: Check `umount_error.log` for detailed error messages.

## License

This project is licensed under the AGPL License.
