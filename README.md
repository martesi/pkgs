# pkgs

Custom OCI images.

## Outputs

- `caddy/Dockerfile` — official Caddy Alpine image with Cloudflare DNS and OIDC plugins.

## Development

```sh
docker build -t custom/caddy caddy
```

Renovate updates the Caddy and plugin versions in `caddy/Dockerfile`.
