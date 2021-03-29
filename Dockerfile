FROM registry.fedoraproject.org/fedora:33

ARG KERNEL_VERSION=5.10.12-200.fc33.x86_64
ENV KERNEL_VERSION=$KERNEL_VERSION
ARG DRIVER_VERSION=460.32.03
ENV DRIVER_VERSION=$DRIVER_VERSION

RUN dnf install -y \
        ca-certificates \
        curl \
        gcc \
        glibc.i686 \
        make \
        cpio \
        kmod \
        curl \
        koji \
        elfutils-libelf-devel && \
        koji download-build --rpm --arch=x86_64 kernel-core-${KERNEL_VERSION} && \
        koji download-build --rpm --arch=x86_64 kernel-devel-${KERNEL_VERSION} && \
        koji download-build --rpm --arch=x86_64 kernel-modules-${KERNEL_VERSION} && \
        dnf install kernel-core-${KERNEL_VERSION}.rpm \
        kernel-devel-${KERNEL_VERSION}.rpm \
        kernel-modules-${KERNEL_VERSION}.rpm -y && \
    rm -rf /var/cache/yum/*

RUN curl -fsSL -o /usr/local/bin/donkey https://github.com/3XX0/donkey/releases/download/v1.1.0/donkey && \
    curl -fsSL -o /usr/local/bin/extract-vmlinux https://raw.githubusercontent.com/torvalds/linux/master/scripts/extract-vmlinux && \
    chmod +x /usr/local/bin/donkey /usr/local/bin/extract-vmlinux

#ARG BASE_URL=http://us.download.nvidia.com/XFree86/Linux-x86_64
ARG BASE_URL=https://us.download.nvidia.com/tesla
ENV IGNORE_CC_MISMATCH=1

RUN ln -s /sbin/ldconfig /sbin/ldconfig.real
# Install the userspace components and copy the kernel module sources.
RUN cd /tmp && \
    curl -fSsl -O $BASE_URL/$DRIVER_VERSION/NVIDIA-Linux-x86_64-$DRIVER_VERSION.run && \
    sh NVIDIA-Linux-x86_64-$DRIVER_VERSION.run -x && \
    cd NVIDIA-Linux-x86_64-$DRIVER_VERSION && \
    ./nvidia-installer --silent \
                       --no-kernel-module \
                       --install-compat32-libs \
                       --no-nouveau-check \
                       --no-nvidia-modprobe \
                       --no-cc-version-check \
                       --no-rpms \
                       --no-backup \
                       --no-check-for-alternate-installs \
                       --no-libglx-indirect \
                       --no-install-libglvnd \
                       --x-prefix=/tmp/null \
                       --x-module-path=/tmp/null \
                       --x-library-path=/tmp/null \
                       --x-sysconfig-path=/tmp/null && \
    mkdir -p /usr/src/nvidia-$DRIVER_VERSION && \
    mv LICENSE mkprecompiled kernel /usr/src/nvidia-$DRIVER_VERSION && \
    sed '9,${/^\(kernel\|LICENSE\)/!d}' .manifest > /usr/src/nvidia-$DRIVER_VERSION/.manifest && \
    rm -rf /tmp/*

COPY nvidia-driver /usr/local/bin

WORKDIR /usr/src/nvidia-$DRIVER_VERSION

ARG PUBLIC_KEY=empty
COPY ${PUBLIC_KEY} kernel/pubkey.x509

ARG PRIVATE_KEY

LABEL io.k8s.display-name="NVIDIA Driver Container"
LABEL name="NVIDIA Driver Container"
LABEL vendor="https://github.com/Kryptonite-RU/nvidia-driver-fcos"
LABEL version="${DRIVER_VERSION}"
LABEL release="N/A"
LABEL summary="Provision the NVIDIA driver through containers"
LABEL description="See summary"

COPY LICENSE /licenses/LICENSE
COPY DRIVER-LICENSE /licenses/DRIVER-LICENSE

RUN chmod +x /usr/local/bin/nvidia-driver

ENTRYPOINT ["nvidia-driver", "init"]