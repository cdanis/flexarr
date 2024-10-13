# flexarr: FlexVolume for heterogeneous homelab environments

## Overview

This is a Kubernetes FlexVolume driver that mounts a share over CIFS from a NAS device. If the pod is running on the NAS device itself, it will use a local direct mount instead.

## Installation

### Prerequisites

1. **`jq`:**  Required for parsing JSON parameters.
2. **`cifs-utils`:** Required for CIFS mounting.

### General Steps

1. **Install Prerequisites:** Ensure `jq` and `cifs-utils` are installed on your system.  On most distributions, you want the `jq` and `cifs-utils` packages.
2. **Copy the `flexarr` script:** Copy the `flexarr` script to the appropriate FlexVolume directory.  This is typically `/usr/libexec/kubernetes/kubelet-plugins/volume/exec/ninefives.online~flexarr/`.  Create this directory if it doesn't exist.
3. **Ensure Executability:** Make sure the `flexarr` script is executable (`chmod +x /path/to/flexarr`).

## Usage

To use the `flexarr` FlexVolume plugin, follow these steps:

1. **Create a PersistentVolume (PV):** Define a PersistentVolume in your Kubernetes cluster that uses the `ninefives.online/flexarr` driver.  Crucially, specify the necessary `flexVolume.options` including `nasHostname`, `nasLocalPath`, `nasNetworkPath`, and any additional `mountOptions`.  You can use the `example-persistentvolume.yaml` as a template.  **Important:**  Ensure the `secretRef` in your PV correctly references a secret containing the CIFS username and password.

2. **Create a PersistentVolumeClaim (PVC):** Create a matching PersistentVolumeClaim.

3. **Mount the Volume in a Pod:** Use the PVC in your Pod specification to mount the volume. Ensure that the Pod is scheduled on a node that can access the NAS device.

4. **Verify the Mount:** Once the Pod is running, verify that the volume is mounted correctly by checking the mount path inside the Pod.

## Troubleshooting

* **Error: `jq: error ...`:**  Ensure `jq` is installed and in your PATH.
* **Error: `mount.cifs: ...`:**  Ensure `cifs-utils` is installed and in your PATH.
* **Error mounting:** Double-check the `nasHostname`, `nasLocalPath`, `nasNetworkPath`, and the CIFS credentials.

## License

This project is licensed under the [AGPL](https://www.gnu.org/licenses/agpl-3.0.html) License.


## Example PersistentVolume (PV)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: example-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  flexVolume:
    driver: ninefives.online/flexarr
    fsType: "cifs"
    options:
      nasHostname: "nas.example.com"
      nasLocalPath: "/local/path"
      nasNetworkPath: "//nas/path"
      mountOptions: "vers=3.0,sec=ntlm" # Example mount options
    secretRef:
      name: cifs-secret
```

## Example PersistentVolumeClaim (PVC)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
spec:
  storageClassName: ""
  volumeName: example-pv
```


