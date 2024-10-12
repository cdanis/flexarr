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

After installing the dependencies, ensure the `flexvolume.sh` script is executable and placed in the appropriate directory for your Kubernetes setup. Typically, this directory is `/usr/libexec/kubernetes/kubelet-plugins/volume/exec/ninefives.online~flexarr/`. You may need to create this directory if it does not exist. Ensure the script has execute permissions:

```bash
chmod +x /path/to/flexvolume.sh
```

## Troubleshooting

- **Dependency Errors**: Ensure `jq` and `mount.cifs` are installed and accessible in your PATH.
- **Mount Errors**: Check `mount_error.log` for detailed error messages.
- **Unmount Errors**: Check `umount_error.log` for detailed error messages.

## Further Reading

For more detailed information on FlexVolume, please refer to the [Kubernetes FlexVolume Documentation](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-storage/flexvolume.md#readme) and the [OpenShift FlexVolume Documentation](https://docs.openshift.com/container-platform/3.11/install_config/persistent_storage/persistent_storage_flex_volume.html).

## License

This project is licensed under the AGPL License.
