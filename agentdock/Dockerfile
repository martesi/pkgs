# renovate: datasource=docker depName=nixos/nix versioning=docker
ARG NIX_VERSION=2.35.2
FROM docker.io/nixos/nix:${NIX_VERSION} AS nix

# renovate: datasource=docker depName=ghcr.io/uvwt/agentdock versioning=docker
ARG AGENTDOCK_VERSION=v0.9.1
FROM ghcr.io/uvwt/agentdock:${AGENTDOCK_VERSION}

USER root
COPY --from=nix /nix /nix
RUN nix_bin="$(find /nix/store -path '*/bin/nix' -type f -print -quit)" \
    && test -n "$nix_bin" \
    && ln -s "$nix_bin" /usr/local/bin/nix \
    && /usr/local/bin/nix --version
USER agentdock:agentdock
