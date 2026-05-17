#!/usr/bin/env bash
set -eo pipefail

VERSION="${VERSION:-"latest"}"
INSTALL_DIR="/opt/openpelo"

echo "Installing OpenPelo..."

if ! command -v curl &>/dev/null; then
    apt-get update -y
    apt-get install -y curl
fi

if [ "${VERSION}" = "latest" ]; then
    VERSION=$(curl -fsSL "https://api.github.com/repos/doudar/Openpelo/releases/latest" \
        | grep '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')
    echo "Resolved latest version: ${VERSION}"
fi

DOWNLOAD_URL="https://github.com/doudar/Openpelo/releases/download/${VERSION}/OpenPelo-Linux.tar.gz"
TMP_DIR=$(mktemp -d)

echo "Downloading ${DOWNLOAD_URL}..."
curl -fsSL "${DOWNLOAD_URL}" -o "${TMP_DIR}/OpenPelo-Linux.tar.gz"

mkdir -p "${INSTALL_DIR}"
tar -xzf "${TMP_DIR}/OpenPelo-Linux.tar.gz" -C "${INSTALL_DIR}"
rm -rf "${TMP_DIR}"

chmod +x "${INSTALL_DIR}/openpelo"
ln -sf "${INSTALL_DIR}/openpelo" /usr/local/bin/openpelo

echo "OpenPelo ${VERSION} installed. Run 'openpelo' to start."
