# NVIDIA Driver for Fedora CoreOS

[![GPU Operator][gpu-operator-badge]][gpu-operator-url]
[![OpenShift][openshift-badge]][openshift-url]
[![License][license-badge]][license-url]
[![Build Status][build-badge]][build-url]

NVIDIA driver for Fedora CoreOS packaged as a Docker image.
Compatible with NVIDIA GPU Operator.

## Disclaimer

This is an UNOFFICIAL build. Authors are not affiliated, associated, authorized,
endorsed by, or in any way officially connected neither with NVIDIA Corp. nor
with RedHat Inc, or any of their subsidiaries or their affiliates.

The binary Docker image includes proprietary NVIDIA drivers, distributed under
[License For Customer Use of NVIDIA Software][driver-license]. You must
explicitly accept the terms and conditions of in order to use this image.
Please contact your lawyer if in doubt.

## Usage

Update your `values.yaml` for [GPU Operator][gpu-operator]:

```
driver:
  repository: quay.io/kryptonite
  image: nvidia-driver-fcos
  version: "450.51.05-5.6.19-300.fc32.x86_64"
```

Please refer to [GPU Operator documentation][gpu-operator-documentation]
for additional information.

## See Also

- [NVIDIA Driver Docker Image][nvidia-driver-docker]
- [GPU Operator][gpu-operator]

[build-badge]: https://quay.io/repository/kryptonite/nvidia-driver-fcos/status
[build-url]: https://quay.io/repository/kryptonite/nvidia-driver-fcos
[license-badge]: https://img.shields.io/badge/License-Apache--2.0-green.svg?style=flat
[license-url]: LICENSE
[gpu-operator-badge]: https://img.shields.io/badge/GPU-Operator-yellow.svg?style=flat
[gpu-operator-url]: https://github.com/NVIDIA/gpu-operator
[openshift-badge]: https://img.shields.io/badge/OpenShift-4.x-orange.svg?style=flat
[openshift-url]: https://docs.nvidia.com/datacenter/kubernetes/openshift-on-gpu-install-guide/

[driver-license]: DRIVER-LICENSE
[gpu-operator]: https://github.com/NVIDIA/gpu-operator
[gpu-operator-documentation]: https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/getting-started.html
[nvidia-driver-docker]: https://gitlab.com/nvidia/container-images/driver
