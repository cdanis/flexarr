# flexarr: FlexVolume for heterogeneous homelab environments

## Overview

This is a Kubernetes FlexVolume driver that mounts a share over CIFS from a NAS device. Except, if the pod is running on the NAS device itself, it will use a local direct mount instead.

## Installation

### General Steps

1. Ensure `jq` and `mount.cifs` are installed on your system.
   On most distributions, you want the `jq` and `cifs-utils` packages.
2. Copy the `flexarr` script to your FlexVolume directory.

After installing the dependencies, ensure the `flexarr` script is executable and placed in the appropriate directory for your Kubernetes setup. Typically, this directory is `/usr/libexec/kubernetes/kubelet-plugins/volume/exec/ninefives.online~flexarr/`. You may need to create this directory if it does not exist.



## Further Reading

For more detailed information on FlexVolume, please refer to the [Kubernetes FlexVolume Documentation](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-storage/flexvolume.md#readme) and the [OpenShift FlexVolume Documentation](https://docs.openshift.com/container-platform/3.11/install_config/persistent_storage/persistent_storage_flex_volume.html).

## License

This project is licensed under the AGPL License.
