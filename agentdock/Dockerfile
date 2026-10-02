# renovate: datasource=docker depName=nixos/nix versioning=docker
ARG NIX_VERSION=2.35.2
# renovate: datasource=docker depName=ghcr.io/uvwt/agentdock versioning=docker
ARG AGENTDOCK_VERSION=v0.9.1

FROM docker.io/nixos/nix:${NIX_VERSION} AS nix
FROM ghcr.io/uvwt/agentdock:${AGENTDOCK_VERSION}
ARG NIXPKGS_REV=f45c6f04c2f013f004bf94e284e95d72898d9393

USER root
COPY --chown=agentdock:agentdock --from=nix /nix /nix
RUN nix_bin="$(find /nix/store -path '*/bin/nix' -type f -print -quit)" \
    && test -n "$nix_bin" \
    && for command in \
         nix nix-build nix-channel nix-collect-garbage nix-copy-closure nix-daemon \
         nix-env nix-hash nix-instantiate nix-prefetch-url nix-shell nix-store; do \
         ln -s "$nix_bin" "/usr/local/bin/$command"; \
         test "$(readlink "/usr/local/bin/$command")" = "$nix_bin"; \
       done \
    && NIX_CONFIG="experimental-features = nix-command flakes" nix profile add --profile /nix/var/nix/profiles/agentdock \
         "tarball+https://github.com/NixOS/nixpkgs/archive/${NIXPKGS_REV}.tar.gz#jujutsu" \
         "tarball+https://github.com/NixOS/nixpkgs/archive/${NIXPKGS_REV}.tar.gz#bun" \
    && for command in jj bun; do \
         ln -sf "/nix/var/nix/profiles/agentdock/bin/$command" "/usr/local/bin/$command"; \
       done \
    && nix --version \
    && nix-shell --version \
    && nix-env --version \
    && jj --version \
    && bun --version
ENV NIX_CONFIG="experimental-features = nix-command flakes"
USER agentdock:agentdock
