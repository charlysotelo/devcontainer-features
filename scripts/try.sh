#!/usr/bin/env bash
# Spin up a throw-away container with a local feature applied.
#
# Usage:
#   ./scripts/try.sh <feature-name> [base-image]
#
# Examples:
#   ./scripts/try.sh talosctl
#   ./scripts/try.sh copilot ubuntu:22.04

set -eo pipefail

FEATURE="${1:?Usage: $(basename "$0") <feature-name> [base-image]}"
BASE_IMAGE="${2:-ubuntu:24.04}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [ ! -d "$REPO_ROOT/src/$FEATURE" ]; then
    echo "Error: feature '$FEATURE' not found under src/." >&2
    echo "Available: $(ls "$REPO_ROOT/src/" | tr '\n' ' ')" >&2
    exit 1
fi

if ! command -v devcontainer &>/dev/null; then
    echo "Error: devcontainer CLI not found." >&2
    echo "Install with: npm install -g @devcontainers/cli" >&2
    exit 1
fi

# The devcontainer CLI requires local feature paths to be children of the
# .devcontainer/ folder. We create a temp workspace with that layout.
TMP_WORKSPACE=$(mktemp -d)
trap "rm -rf '$TMP_WORKSPACE'" EXIT

mkdir -p "$TMP_WORKSPACE/.devcontainer/$FEATURE"
cp -r "$REPO_ROOT/src/$FEATURE/." "$TMP_WORKSPACE/.devcontainer/$FEATURE/"

cat > "$TMP_WORKSPACE/.devcontainer/devcontainer.json" <<EOF
{
  "image": "${BASE_IMAGE}",
  "features": {
    "./${FEATURE}": {}
  }
}
EOF

echo "🚀 Feature:    ${FEATURE}"
echo "   Base image: ${BASE_IMAGE}"
echo ""

devcontainer up --workspace-folder "$TMP_WORKSPACE"
devcontainer exec --workspace-folder "$TMP_WORKSPACE" bash
