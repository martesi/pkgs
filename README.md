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

Each image has its own CI workflow. Caddy and AgentDock use numeric GHCR tags and advance their manifests after a successful publish.

## Dependency updates

Enable the Renovate GitHub app for this repository and select Interactive mode
in the Mend Developer Portal; Silent mode only looks up updates. `renovate.json`
enables a Dependency Dashboard. Renovate merges PRs after their checks
pass; failed update PRs are assigned to `martesi`. Merging a Dockerfile or image
workflow update to `main` triggers the corresponding image build and publish.

If updates stop, check the Dependency Dashboard and the
[Renovate job logs](https://developer.mend.io/).

## Martesi Scoop bucket

Scoop manifests for portable Windows tools used by the Martesi Helldivers 2
tooling workflow, plus Argus.

## Install

```powershell
scoop bucket add martesi https://github.com/martesi/pkgs
scoop install martesi/argus
scoop install martesi/hd2-mod-quick-deploy
scoop install martesi/hd2-mod-setting-gui
scoop install martesi/hd2-mod-migrator
scoop install martesi/hd2-audio-modder
```

The bucket's scheduled Excavator workflow checks upstream GitHub releases every
four hours and commits manifest updates when versions or asset hashes change.
