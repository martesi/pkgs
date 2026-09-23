# pkgs

Custom OCI images.

## Outputs

- `caddy/Dockerfile` — official Caddy Alpine image with Cloudflare DNS and OIDC plugins.
- `caddy/manifest.json` — image metadata; `version` is the next numeric GHCR tag to publish.

## Development

```sh
docker build -t custom/caddy caddy
```

Renovate updates the Caddy and plugin versions in `caddy/Dockerfile`. CI publishes `ghcr.io/martesi/caddy:<version>` from `caddy/manifest.json`, then increments `version` after a successful publish.
