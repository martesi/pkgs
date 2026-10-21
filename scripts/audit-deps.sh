#!/usr/bin/env bash
set -euo pipefail
# Recursive OSV analysis of direct and transitive dependencies.
# Usage: scripts/audit-deps.sh [checkout ...]
# No arguments: inventory and scan owned martesi GitHub repositories.
scanner="${OSV_SCANNER:-osv-scanner}"
command -v "$scanner" >/dev/null || { echo "Install osv-scanner v2 first" >&2; exit 2; }
workdir="${AUDIT_WORKDIR:-$(mktemp -d)}"
mkdir -p "$workdir/reports" "$workdir/repos"
failed=0
if (( $# )); then
  repos=("$@")
else
  command -v gh >/dev/null || { echo "gh CLI required" >&2; exit 2; }
  mapfile -t names < <(gh repo list martesi --limit 250 --json nameWithOwner --jq '.[].nameWithOwner')
  repos=()
  for name in "${names[@]}"; do
    case "$name" in Mirror/*|XTSpace/*) continue ;; esac
    path="$workdir/repos/${name##*/}"
    if ! gh repo clone "$name" "$path" -- --depth=1 >&2; then
      echo "UNSCANNED: $name (clone failed)" >&2
      failed=1
      continue
    fi
    repos+=("$path")
  done
fi
for dir in "${repos[@]}"; do
  dir="$(realpath "$dir")"
  name="$(basename "$dir")"
  echo "Scanning $name: $dir"
  if "$scanner" scan source --recursive --format json --all-packages --output-file "$workdir/reports/$name.json" "$dir"; then
    echo "Report: $workdir/reports/$name.json"
  else
    rc=$?
    echo "CHECK: $name (scanner exit $rc); $workdir/reports/$name.json" >&2
    failed=1
  fi
done
echo "Reports: $workdir/reports"
exit "$failed"
