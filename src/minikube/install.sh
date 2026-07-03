#!/usr/bin/env bash
set -eo pipefail

VERSION="${VERSION:-latest}"

echo "Installing minikube (${VERSION})..."

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

if [ "${VERSION}" != "latest" ] && [[ "${VERSION}" != v* ]]; then
    VERSION="v${VERSION}"
fi

URL="https://storage.googleapis.com/minikube/releases/${VERSION}/minikube-linux-${KARCH}"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "Downloading ${URL}"
curl -fsSL "${URL}" -o "${TMP_DIR}/minikube"
install -m 0755 "${TMP_DIR}/minikube" /usr/local/bin/minikube

echo "Done. Installed $(/usr/local/bin/minikube version --short)."