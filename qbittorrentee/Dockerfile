# renovate: datasource=docker depName=alpine versioning=docker
ARG ALPINE_VERSION=3.22
# renovate: datasource=github-releases depName=c0re100/qBittorrent-Enhanced-Edition extractVersion=^release-(?<version>.*)$
ARG QBITTORRENT_VERSION=5.2.4.10

FROM alpine:${ALPINE_VERSION} AS builder
ARG QBITTORRENT_VERSION
ARG TARGETARCH

RUN apk add --no-cache ca-certificates curl jq unzip

RUN case "$TARGETARCH" in \
      amd64) arch=x86_64 ;; \
      arm64) arch=aarch64 ;; \
      *) echo "Unsupported architecture: $TARGETARCH" >&2; exit 1 ;; \
    esac \
    && asset="qbittorrent-enhanced-nox_${arch}-linux-musl_static.zip" \
    && release="release-${QBITTORRENT_VERSION}" \
    && curl -fL --retry 3 \
         -o /tmp/qbittorrent.zip \
         "https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases/download/${release}/${asset}" \
    && digest="$(curl -fsSL \
         "https://api.github.com/repos/c0re100/qBittorrent-Enhanced-Edition/releases/tags/${release}" \
         | jq -r --arg asset "$asset" '.assets[] | select(.name == $asset) | .digest' \
         | sed 's/^sha256://')" \
    && test -n "$digest" \
    && test "$digest" != "null" \
    && echo "$digest  /tmp/qbittorrent.zip" | sha256sum -c - \
    && unzip -q /tmp/qbittorrent.zip -d /tmp/qbittorrent \
    && binary="$(find /tmp/qbittorrent -type f -name qbittorrent-nox -print -quit)" \
    && test -n "$binary" \
    && install -Dm755 "$binary" /out/qbittorrent-nox

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache ca-certificates python3

COPY --from=builder /out/qbittorrent-nox /usr/local/bin/qbittorrent-nox

ENV HOME=/config

VOLUME ["/config", "/downloads"]
EXPOSE 8080 6881 6881/udp

ENTRYPOINT ["qbittorrent-nox"]
CMD ["--profile=/config", "--webui-port=8080"]
