# flexarr: FlexVolume for heterogeneous homelab environments

## Overview

flexarr is a Kubernetes FlexVolume driver designed for heterogeneous homelab environments. It mounts a share over CIFS from a NAS device, but if the pod is running on the NAS device itself, it uses a local direct mount instead.

## Installation

### Prerequisites

- Kubernetes cluster
- `jq`, `cifs-utils`, and `util-linux` packages installed on all nodes

### Manual Installation

1. Install the required packages on all nodes.  On Debian:
   ```bash
   sudo apt update && sudo apt install -y jq cifs-utils util-linux
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
   kubectl apply -k .
   ```

2. Verify the DaemonSet is running:
   ```bash
   kubectl get pods -n kube-system -l name=flexarr-installer -o wide
   ```

## Usage

1. Create a secret for CIFS credentials:
   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: flexarr-cifs-secret
   type: ninefives.online/flexarr
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
       fsType: "cifs"  # required
       secretRef:
         name: flexarr-cifs-secret
       options:
         nasHostname: "nas.example.com"
         nasLocalPath: "/local/path"
         nasNetworkPath: "//nas.example.com/share"
   ```

   Note: Currently, only 'cifs' is supported as the fsType. Future versions may support additional network filesystems.

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
   You might also wish to add a `nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution` preference
   on the hostname of your NAS.  In the future we may ship a mutating webhook to add this automatically.

## Troubleshooting

- Check the logs of the flexarr-installer DaemonSet pods:
  ```bash
  kubectl logs -n kube-system -l name=flexarr-installer
  ```
- Verify the flexarr script is present and executable on all nodes:
  ```bash
  ls -l /usr/libexec/kubernetes/kubelet-plugins/volume/exec/ninefives.online~flexarr/flexarr
  ```
- Check the Kubernetes events for mount-related issues:
  ```bash
  kubectl get events --sort-by='.lastTimestamp'
  ```

## Security Considerations

- The flexarr script handles sensitive information (CIFS credentials). Ensure that the script file has appropriate permissions and is only writable by the necessary system users.
- Use Kubernetes Secrets to manage CIFS credentials.
- Bind mounts are spooky. Use with caution.
- Any mount errors **will** log your credentials to the local system journal.  k8s itself logs the full argv of the volume plugin on any error, which includes your secrets.

## Further Reading

For more detailed information on FlexVolume, please refer to the [Kubernetes FlexVolume Documentation](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-storage/flexvolume.md#readme) and the [OpenShift FlexVolume Documentation](https://docs.openshift.com/container-platform/3.11/install_config/persistent_storage/persistent_storage_flex_volume.html).

## License

⚠️ WARNING! ⚠️  
☢️ 😱 DO NOT USE THIS PROGRAM. 😱 ☢️  
This program is not a program of honor.

No highly esteemed function is executed here.

What is here is dangerous and repulsive to us.

The danger is still present, in your time, as it was in ours,  
without even the implied warranty of MERCHANTABILITY or  
FITNESS FOR A PARTICULAR PURPOSE.

This program is best shunned and left unused (but it is free software,  
and you are welcome to redistribute it under certain conditions).  
😱 ☢️ DO NOT USE THIS PROGRAM. ☢️ 😱

This program is licensed under the Sandia Message Public License,
sublicense GNU Affero General Public License version 3.0 (sandia-AGPL-3.0).  
You may obtain a copy of the License(s) at
https://github.com/cdanis/sandia-public-license and
https://www.gnu.org/licenses/agpl-3.0.html

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
