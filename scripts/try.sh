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
TMP_CONFIG="$REPO_ROOT/.tmp-try-feature.json"

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

trap "rm -f '$TMP_CONFIG'" EXIT

# Config is written at the repo root so that the local feature path
# './src/<feature>' resolves correctly relative to this file.
cat > "$TMP_CONFIG" <<EOF
{
  "image": "${BASE_IMAGE}",
  "features": {
    "./src/${FEATURE}": {}
  }
}
EOF

echo "🚀 Feature:    ${FEATURE}"
echo "   Base image: ${BASE_IMAGE}"
echo ""

devcontainer up --workspace-folder "$REPO_ROOT" --config "$TMP_CONFIG"
devcontainer exec --workspace-folder "$REPO_ROOT" --config "$TMP_CONFIG" bash
