# pkgs

Custom Nix packages and OCI images.

## Outputs

- `packages.x86_64-linux.caddy` — Caddy OCI image with Cloudflare DNS and OIDC plugins.
- `packages.x86_64-linux.tunnel-client` — pinned OpenAI tunnel-client runtime.

## Development

```sh
direnv allow
nix flake check
./scripts/update.sh
```

The scheduled GitHub Actions workflow refreshes release pins, verifies both outputs, commits changed pins, and publishes Caddy to `ghcr.io/martesi/caddy:latest`.
