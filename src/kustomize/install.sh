#!/usr/bin/env bash
set -eo pipefail

VERSION="${VERSION:-latest}"

echo "Installing kustomize (${VERSION})..."

if ! command -v curl &>/dev/null || ! command -v tar &>/dev/null; then
    apt-get update -y
    apt-get install -y --no-install-recommends ca-certificates curl tar gzip
    rm -rf /var/lib/apt/lists/*
fi

ARCH="$(dpkg --print-architecture)"
case "${ARCH}" in
    amd64) KARCH="amd64" ;;
    arm64) KARCH="arm64" ;;
    *)
        echo "Unsupported architecture: ${ARCH}" >&2
        exit 1
        ;;
esac

if [ "${VERSION}" = "latest" ]; then
    VERSION="$(curl -fsSL https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest \
        | grep '"tag_name"' | head -1 | sed -E 's/.*"([^\"]+)".*/\1/')"
fi

if [ -z "${VERSION}" ]; then
    echo "Could not determine kustomize version to install." >&2
    exit 1
fi

ASSET="kustomize_${VERSION}_linux_${KARCH}.tar.gz"
URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${VERSION}/${ASSET}"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "Downloading ${URL}"
curl -fsSL "${URL}" -o "${TMP_DIR}/kustomize.tar.gz"
tar -xzf "${TMP_DIR}/kustomize.tar.gz" -C "${TMP_DIR}" kustomize
install -m 0755 "${TMP_DIR}/kustomize" /usr/local/bin/kustomize

echo "Done. Installed $(/usr/local/bin/kustomize version)."