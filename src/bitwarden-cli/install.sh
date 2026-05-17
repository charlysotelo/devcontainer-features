#!/usr/bin/env bash
set -eo pipefail

apt-get update -y
apt-get install -y --no-install-recommends curl ca-certificates unzip

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
    x86_64)  ARCH_SUFFIX="" ;;
    aarch64) ARCH_SUFFIX="-arm64" ;;
    *)
        echo "Unsupported architecture: $ARCH" >&2
        exit 1
        ;;
esac

# Find the latest cli-v* release
LATEST_TAG=$(curl -fsSL "https://api.github.com/repos/bitwarden/clients/releases?per_page=50" \
    | grep '"tag_name"' \
    | grep '"cli-v' \
    | head -1 \
    | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')

if [ -z "$LATEST_TAG" ]; then
    echo "Failed to determine latest Bitwarden CLI release" >&2
    exit 1
fi

VERSION="${LATEST_TAG#cli-v}"
echo "Installing Bitwarden CLI ${VERSION} (${ARCH})..."

DOWNLOAD_URL="https://github.com/bitwarden/clients/releases/download/${LATEST_TAG}/bw-linux${ARCH_SUFFIX}-${VERSION}.zip"

TMP_DIR=$(mktemp -d)
trap "rm -rf '$TMP_DIR'" EXIT

curl -fsSL "$DOWNLOAD_URL" -o "$TMP_DIR/bw.zip"
unzip -q "$TMP_DIR/bw.zip" -d "$TMP_DIR"
install -m 0755 "$TMP_DIR/bw" /usr/local/bin/bw

echo "Bitwarden CLI $(bw --version) installed at $(command -v bw)"
