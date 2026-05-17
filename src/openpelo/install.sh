#!/usr/bin/env bash
set -eo pipefail

# Installs OpenPelo from the latest (or pinned) GitHub release.
VERSION="${VERSION:-"latest"}"
INSTALL_DIR="/opt/openpelo"

echo "Installing OpenPelo..."

# Flutter Linux desktop runtime dependencies + CA certs for curl
apt-get update -y
apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    libgtk-3-0 \
    libglib2.0-0 \
    libpango-1.0-0 \
    libcairo2 \
    libgdk-pixbuf-2.0-0 \
    libatk1.0-0 \
    libx11-6 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxtst6
update-ca-certificates

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
