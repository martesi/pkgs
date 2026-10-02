# renovate: datasource=docker depName=nixos/nix versioning=docker
ARG NIX_VERSION=2.35.2
# renovate: datasource=docker depName=ghcr.io/uvwt/agentdock versioning=docker
ARG AGENTDOCK_VERSION=v0.9.1

FROM docker.io/nixos/nix:${NIX_VERSION} AS nix
FROM ghcr.io/uvwt/agentdock:${AGENTDOCK_VERSION}

USER root
COPY --from=nix /nix /opt/nix-bootstrap
RUN nix_bin="$(find /opt/nix-bootstrap/store -path '*/bin/nix' -type f -print -quit)" \
    && test -n "$nix_bin" \
    && nix_target="/nix${nix_bin#/opt/nix-bootstrap}" \
    && for command in \
         nix nix-build nix-channel nix-collect-garbage nix-copy-closure nix-daemon \
         nix-env nix-hash nix-instantiate nix-prefetch-url nix-shell nix-store; do \
         ln -s "$nix_target" "/usr/local/bin/$command"; \
       done \
    && ln -s /opt/nix-bootstrap /nix \
    && nix --version \
    && nix-shell --version \
    && nix-env --version \
    && nix-store --version \
    && rm /nix
USER agentdock:agentdock
