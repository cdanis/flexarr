# flexarr: FlexVolume for heterogeneous homelab environments

## Overview

flexarr is a Kubernetes FlexVolume driver designed for heterogeneous homelab environments. It mounts a share over CIFS from a NAS device, but if the pod is running on the NAS device itself, it uses a local direct mount instead.

## Installation

### Prerequisites

- Kubernetes cluster
- `jq` and `cifs-utils` packages installed on all nodes

### Manual Installation

1. Install the required packages on all nodes:
   ```bash
   sudo apt update && sudo apt install -y jq cifs-utils
   ```

2. Copy the `flexarr` script to your FlexVolume directory:
   ```bash
   sudo mkdir -p /usr/libexec/kubernetes/kubelet-plugins/volume/exec/ninefives.online~flexarr/
   sudo cp flexarr /usr/libexec/kubernetes/kubelet-plugins/volume/exec/ninefives.online~flexarr/
   sudo chmod +x /usr/libexec/kubernetes/kubelet-plugins/volume/exec/ninefives.online~flexarr/flexarr
   ```

### DaemonSet Installation (Recommended)

1. Apply the DaemonSet configuration:
   ```bash
   kubectl apply -k k8s/
   ```

2. Verify the DaemonSet is running:
   ```bash
   kubectl get pods -n kube-system -l name=flexarr-installer
   ```

## Usage

1. Create a secret for CIFS credentials:
   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: cifs-secret
   type: kubernetes.io/cifs
   stringData:
     username: your-username
     password: your-password
   ```

2. Create a PersistentVolume (PV):
   ```yaml
   apiVersion: v1
   kind: PersistentVolume
   metadata:
     name: flexarr-pv
   spec:
     capacity:
       storage: 1Gi
     accessModes:
       - ReadWriteMany
     flexVolume:
       driver: "ninefives.online/flexarr"
       fsType: "cifs"
       secretRef:
         name: cifs-secret
       options:
         nasHostname: "nas.example.com"
         nasLocalPath: "/local/path"
         nasNetworkPath: "//nas.example.com/share"
   ```

3. Create a PersistentVolumeClaim (PVC):
   ```yaml
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
     name: flexarr-pvc
   spec:
     accessModes:
       - ReadWriteMany
     resources:
       requests:
         storage: 1Gi
     volumeName: flexarr-pv
   ```

4. Use the PVC in your Pod:
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: flexarr-test
   spec:
     containers:
     - name: test-container
       image: busybox
       volumeMounts:
       - name: flexarr-storage
         mountPath: /mnt/flexarr
     volumes:
     - name: flexarr-storage
       persistentVolumeClaim:
         claimName: flexarr-pvc
   ```

## Troubleshooting

- Check the logs of the flexarr-installer DaemonSet pods:
  ```bash
  kubectl logs -n kube-system -l name=flexarr-installer
  ```
- Verify the flexarr script is present on all nodes:
  ```bash
  ls /usr/libexec/kubernetes/kubelet-plugins/volume/exec/ninefives.online~flexarr/flexarr
  ```
- Check the Kubernetes events for mount-related issues:
  ```bash
  kubectl get events --sort-by='.lastTimestamp'
  ```

## Security Considerations

- The flexarr script handles sensitive information (CIFS credentials). Ensure that the script file has appropriate permissions and is only accessible by the necessary system users.
- Use Kubernetes Secrets to manage CIFS credentials, and avoid hardcoding them in PV definitions or pod specs.
- Regularly rotate the CIFS credentials used by flexarr.

## License

This project is licensed under the [AGPL](https://www.gnu.org/licenses/agpl-3.0.html) License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
