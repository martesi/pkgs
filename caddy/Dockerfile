# renovate: datasource=docker depName=caddy versioning=docker
ARG CADDY_VERSION=2.11.4

FROM docker.io/library/caddy:${CADDY_VERSION}-builder-alpine AS builder

# renovate: datasource=github-tags depName=caddy-dns/cloudflare extractVersion=^v(?<version>.*)$
ARG CLOUDFLARE_VERSION=0.2.4
# renovate: datasource=github-tags depName=relvacode/caddy-oidc extractVersion=^v(?<version>.*)$
ARG OIDC_VERSION=0.4.2

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare@v${CLOUDFLARE_VERSION} \
    --with github.com/relvacode/caddy-oidc@v${OIDC_VERSION}

FROM docker.io/library/caddy:${CADDY_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
