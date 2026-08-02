#!/usr/bin/env bash
set -eo pipefail

VERSION="${VERSION:-latest}"

echo "Installing just (${VERSION})..."

if ! command -v curl &>/dev/null; then
    apt-get update -y
    apt-get install -y --no-install-recommends ca-certificates curl
    rm -rf /var/lib/apt/lists/*
fi

if [ "${VERSION}" = "latest" ]; then
    VERSION="$(curl -fsSL https://api.github.com/repos/casey/just/releases/latest \
        | grep '"tag_name"' | head -1 | sed -E 's/.*"([^\"]+)".*/\1/')"
fi

if [ -z "${VERSION}" ]; then
    echo "Could not determine just version to install." >&2
    exit 1
fi

ARCH="$(dpkg --print-architecture)"
case "${ARCH}" in
    amd64) JUST_ARCH="x86_64-unknown-linux-musl" ;;
    arm64) JUST_ARCH="aarch64-unknown-linux-musl" ;;
    *)
        echo "Unsupported architecture for just: ${ARCH}" >&2
        exit 1
        ;;
esac

URL="https://github.com/casey/just/releases/download/${VERSION}/just-${VERSION}-${JUST_ARCH}.tar.gz"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "Downloading ${URL}"
curl -fsSL "${URL}" -o "${TMP_DIR}/just.tar.gz"
tar -xzf "${TMP_DIR}/just.tar.gz" -C "${TMP_DIR}" just
install -m 0755 "${TMP_DIR}/just" /usr/local/bin/just

echo "Done. Installed $(just --version)."
