# flexarr: FlexVolume for heterogeneous homelab environments

## Overview

This is a Kubernetes FlexVolume driver that mounts a share over CIFS from a NAS device. Except, if the pod is running on the NAS device itself, it will use a local direct mount instead.

## Installation

### General Steps

1. Ensure `jq` and `mount.cifs` are installed on your system.
   On most distributions, you want the `jq` and `cifs-utils` packages.
2. Copy the `flexarr` script to your FlexVolume directory.

After installing the dependencies, ensure the `flexarr` script is executable and placed in the appropriate directory for your Kubernetes setup. Typically, this directory is `/usr/libexec/kubernetes/kubelet-plugins/volume/exec/ninefives.online~flexarr/`. You may need to create this directory if it does not exist.



## Usage

To use the `flexarr` FlexVolume plugin, follow these steps:

1. **Create a PersistentVolume (PV):** Define a PersistentVolume in your Kubernetes cluster that uses the `flexarr` driver. You can use the `example-persistentvolume.yaml` as a template.

2. **Create a PersistentVolumeClaim (PVC):** Create a matching PersistentVolumeClaim:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
spec:
  storageClassName: ""
  volumeName: name-of-your-pv
```

3. **Mount the Volume in a Pod:** Use the PVC in your Pod specification to mount the volume. Ensure that the Pod is scheduled on a node that can access the NAS device.

4. **Verify the Mount:** Once the Pod is running, verify that the volume is mounted correctly by checking the mount path inside the Pod.

For more detailed examples, refer to the Kubernetes documentation on Persistent Volumes and Persistent Volume Claims.

For more detailed information on FlexVolume, please refer to the [Kubernetes FlexVolume Documentation](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-storage/flexvolume.md#readme) and the [OpenShift FlexVolume Documentation](https://docs.openshift.com/container-platform/3.11/install_config/persistent_storage/persistent_storage_flex_volume.html).

## License

This project is licensed under the AGPL License.
