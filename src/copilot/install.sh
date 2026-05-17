#!/usr/bin/env bash
set -eo pipefail

echo "Installing GitHub Copilot CLI..."

if ! command -v curl &>/dev/null; then
    apt-get update -y
    apt-get install -y curl
fi

curl -fsSL https://gh.io/copilot-install | bash

echo "Done. Run 'copilot --help' to get started."
