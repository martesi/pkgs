#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
pins="$root/pins.json"
system="x86_64-linux"

latest_version() {
  local repo="$1"
  local current="$2"
  local release

  release="$(
    curl -fsSL \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "https://api.github.com/repos/$repo/releases/latest" 2>/dev/null |
      jq -r '.tag_name // empty' 2>/dev/null || true
  )"

  if [[ -n "$release" ]]; then
    printf '%s\n' "${release#v}"
    return
  fi

  {
    printf '%s\n' "$current"
    curl -fsSL \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "https://api.github.com/repos/$repo/tags?per_page=100" |
      jq -r '.[].name | sub("^v"; "")'
  } | sort -V | tail -1
}

set_pin() {
  local filter="$1"
  local value="$2"
  local tmp
  tmp="$(mktemp)"
  jq --arg value "$value" "$filter = \$value" "$pins" > "$tmp"
  mv "$tmp" "$pins"
}

for plugin in cloudflare oidc; do
  repo="$(jq -r ".caddy.plugins.$plugin.repo" "$pins")"
  current="$(jq -r ".caddy.plugins.$plugin.version" "$pins")"
  version="$(latest_version "$repo" "$current")"
  set_pin ".caddy.plugins.$plugin.version" "$version"
done

repo="$(jq -r '.tunnelClient.repo' "$pins")"
current="$(jq -r '.tunnelClient.version' "$pins")"
version="$(latest_version "$repo" "$current")"
set_pin '.tunnelClient.version' "$version"

url="https://github.com/$repo/releases/download/v$version/tunnel-client-runtime-v$version-linux-amd64.zip"
hash="$(nix store prefetch-file --json "$url" | jq -er '.hash')"
set_pin '.tunnelClient.hash' "$hash"

fake="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
set +e
output="$(
  nix build --no-link --impure --expr "
    let flake = builtins.getFlake \"path:$root\";
    in flake.packages.$system.caddy.override { hash = \"$fake\"; }
  " 2>&1
)"
status=$?
set -e

caddy_hash="$(printf '%s\n' "$output" | sed -n 's/.*got: *\(sha256-[A-Za-z0-9+\/=]*\).*/\1/p' | tail -1)"
if [[ -z "$caddy_hash" ]]; then
  if [[ $status -eq 0 ]]; then
    echo "Caddy unexpectedly accepted the fake hash" >&2
  else
    printf '%s\n' "$output" >&2
  fi
  exit 1
fi

set_pin '.caddy.hash' "$caddy_hash"
jq --indent 2 . "$pins" > "$pins.tmp"
mv "$pins.tmp" "$pins"
