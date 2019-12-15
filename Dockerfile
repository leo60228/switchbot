FROM ubuntu:16.04

COPY docker/common.sh /
RUN /common.sh

COPY docker/xargo.sh /
RUN /xargo.sh

COPY docker/cmake.sh /
RUN apt-get purge --auto-remove -y cmake && \
    /cmake.sh

RUN apt-get install -y --no-install-recommends \
    g++-aarch64-linux-gnu \
    libc6-dev-arm64-cross

COPY docker/qemu.sh /
RUN /qemu.sh aarch64 softmmu

COPY docker/dropbear.sh /
RUN /dropbear.sh

COPY docker/linux-image.sh /
RUN /linux-image.sh aarch64

COPY docker/linux-runner /

COPY docker/ubuntu-ports.sh /
RUN /ubuntu-ports.sh /etc/apt/sources.list

ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc \
    CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_RUNNER="/linux-runner aarch64" \
    CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc \
    CXX_aarch64_unknown_linux_gnu=aarch64-linux-gnu-g++ \
    QEMU_LD_PREFIX=/usr/aarch64-linux-gnu \
    RUST_TEST_THREADS=1
RUN dpkg --add-architecture arm64 && apt-get update
RUN apt-get install -y curl
RUN mkdir -m777 /opt/rust /opt/cargo
ENV RUSTUP_HOME=/opt/rust CARGO_HOME=/opt/cargo PATH=/opt/cargo/bin:$PATH
RUN curl https://sh.rustup.rs -sSf | sh -s -- --profile minimal --default-toolchain nightly-2019-12-15 -y
RUN rustup target add aarch64-unknown-linux-gnu
RUN printf '#!/bin/sh\nexport CARGO_HOME=/opt/cargo\nexec /bin/sh "$@"\n' >/usr/local/bin/sh
RUN chmod +x /usr/local/bin/sh
RUN apt-get install -y libv4l-dev:arm64 libjpeg-dev:arm64
