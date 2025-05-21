ARG NVIDIA_CUDA_VERSION=11.2.0
ARG NVIDIA_CUDA_BASE_IMAGE=base-ubuntu20.04
ARG NVIDIA_CUDA_IMAGE_TAG=${NVIDIA_CUDA_VERSION}-${NVIDIA_CUDA_BASE_IMAGE}
FROM nvidia/cuda:$NVIDIA_CUDA_IMAGE_TAG

LABEL Robin Ostlund <me@robinostlund.name>

# ARG variables
ARG TREX_VERSION=0.20.3
ARG TREX_TAR_FILE=t-rex-${TREX_VERSION}-linux.tar.gz

# ENV variables (updated to match your new command)
ENV ALGO=octopus
ENV SERVER=stratum+tcp://pool.woolypooly.com:3094
ENV USERNAME=cfx:aampvm5fssukh7ajf2m2pkknu5xwehy6bapy2rdytx.rig0
ENV PASSWORD=x
ENV WORKER_NAME=rig0

# Install packages
RUN apt update \
    && apt -y install wget

# Download and install T-Rex
RUN cd /tmp \
    && wget -q https://github.com/trexminer/T-Rex/releases/download/$TREX_VERSION/$TREX_TAR_FILE \
    && tar -zxvf $TREX_TAR_FILE t-rex \
    && mv t-rex /usr/local/bin \
    && rm -rf $TREX_TAR_FILE

# Cleanup
RUN apt -y remove wget \
    && apt -y autoremove

# Fix for NVIDIA library linking
RUN ln -s /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose T-Rex HTTP API port
EXPOSE 4067
ENTRYPOINT /entrypoint.sh
