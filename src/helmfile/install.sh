#!/usr/bin/env bash
set -eo pipefail

VERSION="${VERSION:-latest}"

echo "Installing Helmfile (${VERSION})..."

# Base Ubuntu images are minimal — make sure our download tools exist.
if ! command -v curl &>/dev/null || ! command -v tar &>/dev/null; then
    apt-get update -y
    apt-get install -y curl tar
fi

# Map dpkg architecture to the names used in Helmfile release assets.
ARCH="$(dpkg --print-architecture)"
case "${ARCH}" in
    amd64) ASSET_ARCH="amd64" ;;
    arm64) ASSET_ARCH="arm64" ;;
    386)   ASSET_ARCH="386" ;;
    *)
        echo "Unsupported architecture: ${ARCH}" >&2
        exit 1
        ;;
esac

# Resolve "latest" to a concrete release tag, then normalize to a bare version
# number (release tags are 'vX.Y.Z' but the asset filenames drop the 'v').
if [ "${VERSION}" = "latest" ]; then
    VERSION="$(curl -fsSL https://api.github.com/repos/helmfile/helmfile/releases/latest \
        | grep '"tag_name"' | head -1 | sed -E 's/.*"([^"]+)".*/\1/')"
fi
VERSION_NUM="${VERSION#v}"

if [ -z "${VERSION_NUM}" ]; then
    echo "Could not determine Helmfile version to install." >&2
    exit 1
fi

ASSET="helmfile_${VERSION_NUM}_linux_${ASSET_ARCH}.tar.gz"
URL="https://github.com/helmfile/helmfile/releases/download/v${VERSION_NUM}/${ASSET}"

echo "Downloading ${URL}"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

curl -fsSL "${URL}" -o "${TMP_DIR}/helmfile.tar.gz"
tar -xzf "${TMP_DIR}/helmfile.tar.gz" -C "${TMP_DIR}" helmfile
install -m 0755 "${TMP_DIR}/helmfile" /usr/local/bin/helmfile

echo "Done. Installed $(/usr/local/bin/helmfile --version)."
echo "If Helm is available, run 'helmfile init' to install required plugins (e.g. helm-diff)."
