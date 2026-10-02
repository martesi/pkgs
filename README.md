# pkgs

Custom OCI images.

## Outputs

- `caddy/Dockerfile` — official Caddy Alpine image with Cloudflare DNS and OIDC plugins.
- `caddy/manifest.json` — Caddy image metadata; `version` is the next numeric GHCR tag to publish.
- `agentdock/Dockerfile` — official AgentDock runtime with Nix copied from the official Nix image.
- `agentdock/manifest.json` — AgentDock image metadata; `version` is the next numeric GHCR tag to publish.

## Development

```sh
docker build -t custom/caddy caddy
docker build -t custom/agentdock agentdock
```

Renovate updates Dockerfile-pinned upstream versions. CI publishes `ghcr.io/martesi/caddy:<version>` and `ghcr.io/martesi/agentdock:<version>`, then increments both manifests after a successful publish.
