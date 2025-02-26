#
# keepalived Dockerfile
#
# https://github.com/shawly/docker-keepalived
#

# Set alpine image version
ARG ALPINE_VERSION="3.21"

# Set vars for s6 overlay
ARG S6_OVERLAY_VERSION="v3.2.0.2"
ARG S6_OVERLAY_BASE_URL="https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}"
ARG S6_OVERLAY_NOARCH="${S6_OVERLAY_BASE_URL}/s6-overlay-noarch.tar.xz"

# Set base images with s6 overlay download variable (necessary for multi-arch building via GitHub workflows)
FROM alpine:${ALPINE_VERSION} as alpine-amd64

ARG S6_OVERLAY_VERSION
ARG S6_OVERLAY_BASE_URL
ARG S6_OVERLAY_NOARCH
ENV S6_OVERLAY_RELEASE="${S6_OVERLAY_BASE_URL}/s6-overlay-x86_64.tar.xz"

FROM alpine:${ALPINE_VERSION} as alpine-armv6

ARG S6_OVERLAY_VERSION
ARG S6_OVERLAY_BASE_URL
ARG S6_OVERLAY_NOARCH
ENV S6_OVERLAY_RELEASE="${S6_OVERLAY_BASE_URL}/s6-overlay-armhf.tar.xz"

FROM alpine:${ALPINE_VERSION} as alpine-armv7

ARG S6_OVERLAY_VERSION
ARG S6_OVERLAY_BASE_URL
ARG S6_OVERLAY_NOARCH
ENV S6_OVERLAY_RELEASE="${S6_OVERLAY_BASE_URL}/s6-overlay-arm.tar.xz"

FROM alpine:${ALPINE_VERSION} as alpine-arm64

ARG S6_OVERLAY_VERSION
ARG S6_OVERLAY_BASE_URL
ARG S6_OVERLAY_NOARCH
ENV S6_OVERLAY_RELEASE="${S6_OVERLAY_BASE_URL}/s6-overlay-aarch64.tar.xz"

# Build keepalived container
FROM alpine-${TARGETARCH:-amd64}${TARGETVARIANT}

# Transfer build args
ARG S6_OVERLAY_RELEASE
ARG S6_OVERLAY_NOARCH

# Download S6 Overlay
ADD "${S6_OVERLAY_RELEASE}" /tmp/s6-overlay.tar.xz
ADD "${S6_OVERLAY_NOARCH}" /tmp/s6-overlay-noarch.tar.xz

WORKDIR /tmp

# Install deps
RUN \
  set -ex && \
  echo "Installing dependencies..." && \
    apk add --update --no-cache \
      bash \
      ca-certificates \
      curl \
      grep \
      iproute2 \
      ipset \
      ipcalc \
      keepalived \
      sed \
      tcpdump \
      tzdata && \
  echo "Extracting s6 overlay..." && \
    tar -C / -Jxpf /tmp/s6-overlay.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
  echo "Cleaning up directories..." && \
    rm -rf /tmp/*

ENV TZ="Etc/UTC" \
    KEEPALIVED_VIRTUAL_IP="" \
    KEEPALIVED_VIRTUAL_MASK="" \
    KEEPALIVED_CHECK_IP="any" \
    KEEPALIVED_CHECK_PORT="" \
    KEEPALIVED_VRID="" \
    KEEPALIVED_INTERFACE="auto" \
    KEEPALIVED_CHECK_SCRIPT="" \
    KEEPALIVED_CUSTOM_CONFIG=""

# Add files
COPY rootfs/ /

# Start s6
ENTRYPOINT ["/init"]
