#!/usr/bin/env bash
set -eo pipefail

apt-get update -y
apt-get install -y --no-install-recommends curl ca-certificates

echo "Installing Atuin..."

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive

# The installer places the binary in $HOME/.atuin/bin/atuin (i.e. /root/.atuin/bin/atuin
# when running as root). Symlink it to a system-wide location so all users have it on PATH.
install -m 0755 /root/.atuin/bin/atuin /usr/local/bin/atuin

echo "Atuin $(atuin --version) installed at $(command -v atuin)"
