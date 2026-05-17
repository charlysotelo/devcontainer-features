#!/usr/bin/env bash
set -eo pipefail

echo "Installing talosctl..."

if ! command -v curl &>/dev/null; then
    apt-get update -y
    apt-get install -y curl
fi

curl -sL https://talos.dev/install | sh

echo "Done. Run 'talosctl --help' to get started."
