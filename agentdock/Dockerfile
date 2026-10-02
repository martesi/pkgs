# renovate: datasource=docker depName=nixos/nix versioning=docker
ARG NIX_VERSION=2.35.2
FROM docker.io/nixos/nix:${NIX_VERSION} AS nix

# renovate: datasource=docker depName=ghcr.io/uvwt/agentdock versioning=docker
ARG AGENTDOCK_VERSION=v0.9.1
FROM ghcr.io/uvwt/agentdock:${AGENTDOCK_VERSION}

USER root
COPY --from=nix /nix /opt/nix-bootstrap
RUN nix_bin="$(find /opt/nix-bootstrap/store -path '*/bin/nix' -type f -print -quit)" \
    && test -n "$nix_bin" \
    && nix_target="/nix${nix_bin#/opt/nix-bootstrap}" \
    && ln -s "$nix_target" /usr/local/bin/nix \
    && ln -s /opt/nix-bootstrap /nix \
    && /usr/local/bin/nix --version \
    && rm /nix
USER agentdock:agentdock
