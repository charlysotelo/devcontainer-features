#!/usr/bin/env bash
set -e

echo "Installing GitHub Copilot CLI..."

curl -fsSL https://gh.io/copilot-install | bash

echo "Done. Run 'gh copilot --help' to get started."
