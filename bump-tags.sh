#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./bump-tags.sh --<tag>

Example:
  ./bump-tags.sh --v0.0.1

Behavior:
  - Updates wrapper workflows to use the provided shared tag.
  - Commits and pushes the workflow changes.
EOF
}

log() {
  printf '%s\n' "$*"
}

run() {
  log "+ $*"
  "$@"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -ne 1 || "${1:0:2}" != "--" ]]; then
  usage >&2
  exit 2
fi

TAG="${1#--}"
if [[ -z "$TAG" ]]; then
  echo "Error: tag is required." >&2
  exit 2
fi

if [[ ! "$TAG" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
  echo "Error: invalid tag '${TAG}'." >&2
  exit 2
fi

ROOT="$(git rev-parse --show-toplevel)"
if [[ "$(basename "$ROOT")" != "gh-actions-xf-secops" ]]; then
  echo "Error: must run from gh-actions-xf-secops repo." >&2
  exit 1
fi

if [[ -n "$(git -C "$ROOT" status --porcelain)" ]]; then
  echo "Error: working tree is not clean. Commit or stash first." >&2
  exit 1
fi

BRANCH="$(git -C "$ROOT" branch --show-current)"
if [[ "$BRANCH" != "main" ]]; then
  echo "Error: current branch is '${BRANCH}', expected 'main'." >&2
  exit 1
fi

if sed --version >/dev/null 2>&1; then
  SED_INPLACE=(-i)
else
  SED_INPLACE=(-i '')
fi

WORKFLOWS_DIR="${ROOT}/.github/workflows"
if [[ ! -d "$WORKFLOWS_DIR" ]]; then
  echo "Error: workflows directory not found." >&2
  exit 1
fi

mapfile -d '' FILES < <(find "$WORKFLOWS_DIR" -maxdepth 1 -type f -name '*.yml' -print0)
if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "Error: no workflow files found." >&2
  exit 1
fi

log "Updating wrapper workflows to tag '${TAG}'"
log "Files to update:"
for file in "${FILES[@]}"; do
  log " - ${file}"
done
for file in "${FILES[@]}"; do
  log "Processing ${file}"
  run sed "${SED_INPLACE[@]}" -E \
    -e "s|(shared-common/gh-actions-shared/\\.github/workflows/[^@[:space:]]+)@[^[:space:]]+|\\1@${TAG}|g" \
    -e "s|(shared-ref: )[[:graph:]]+|\\1${TAG}|g" \
    "$file"
done

if git -C "$ROOT" diff --quiet -- "$WORKFLOWS_DIR"; then
  echo "Error: no workflow changes detected; nothing to commit." >&2
  exit 1
fi

log "Workflow changes:"
run git -C "$ROOT" diff --stat -- "$WORKFLOWS_DIR"
run git -C "$ROOT" add "$WORKFLOWS_DIR"
run git -C "$ROOT" commit -m "chore: bump shared workflows to ${TAG}"
run git -C "$ROOT" push origin main
