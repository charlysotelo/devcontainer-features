#!/usr/bin/env bash
set -eo pipefail

VERSION="${VERSION:-latest}"

echo "Installing protoc (${VERSION})..."

if ! command -v curl &>/dev/null || ! command -v unzip &>/dev/null; then
    apt-get update -y
    apt-get install -y --no-install-recommends ca-certificates curl unzip
    rm -rf /var/lib/apt/lists/*
fi

ARCH="$(dpkg --print-architecture)"
case "${ARCH}" in
    amd64) PARCH="x86_64" ;;
    arm64) PARCH="aarch_64" ;;
    *)
        echo "Unsupported architecture: ${ARCH}" >&2
        exit 1
        ;;
esac

if [ "${VERSION}" = "latest" ]; then
    VERSION="$(curl -fsSL https://api.github.com/repos/protocolbuffers/protobuf/releases/latest \
        | grep '"tag_name"' | head -1 | sed -E 's/.*"([^\"]+)".*/\1/')"
fi
VERSION_NUM="${VERSION#v}"

if [ -z "${VERSION_NUM}" ]; then
    echo "Could not determine protoc version to install." >&2
    exit 1
fi

ASSET="protoc-${VERSION_NUM}-linux-${PARCH}.zip"
URL="https://github.com/protocolbuffers/protobuf/releases/download/v${VERSION_NUM}/${ASSET}"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "Downloading ${URL}"
curl -fsSL "${URL}" -o "${TMP_DIR}/protoc.zip"
unzip -q "${TMP_DIR}/protoc.zip" -d "${TMP_DIR}/protoc"
install -m 0755 "${TMP_DIR}/protoc/bin/protoc" /usr/local/bin/protoc
mkdir -p /usr/local/include
cp -R "${TMP_DIR}/protoc/include/." /usr/local/include/

echo "Done. Installed $(/usr/local/bin/protoc --version)."