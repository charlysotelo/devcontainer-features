#!/usr/bin/env bash
set -eo pipefail

VERSION="${VERSION:-latest}"

echo "Installing kubectl (${VERSION})..."

if ! command -v curl &>/dev/null; then
    apt-get update -y
    apt-get install -y --no-install-recommends ca-certificates curl
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
    VERSION="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
fi

URL="https://dl.k8s.io/release/${VERSION}/bin/linux/${KARCH}/kubectl"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "Downloading ${URL}"
curl -fsSL "${URL}" -o "${TMP_DIR}/kubectl"
install -m 0755 "${TMP_DIR}/kubectl" /usr/local/bin/kubectl

echo "Done. Installed $(/usr/local/bin/kubectl version --client=true)."