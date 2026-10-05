# pkgs

Custom OCI images.

## Outputs

- `caddy/Dockerfile` — official Caddy Alpine image with Cloudflare DNS and OIDC plugins.
- `caddy/manifest.json` — Caddy image metadata; `version` is the next numeric GHCR tag to publish.
- `agentdock/Dockerfile` — official AgentDock runtime with Nix copied from the official Nix image.
- `agentdock/manifest.json` — AgentDock image metadata; `version` is the next numeric GHCR tag to publish.
- `qbittorrentee/Dockerfile` — Alpine image containing the upstream qBittorrent Enhanced Edition static `qbittorrent-nox` release.

## Development

```sh
docker build -t custom/caddy caddy
docker build -t custom/agentdock agentdock
docker build -t custom/qbittorrentee qbittorrentee
```

Each image has its own CI workflow. Caddy and AgentDock use numeric GHCR tags and advance their manifests after a successful publish.

qBittorrent Enhanced Edition tracks the upstream GitHub release directly. Renovate updates and automerges its version after CI passes; CI publishes `ghcr.io/martesi/qbittorrentee:<upstream-version>` and `latest`.
