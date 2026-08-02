# devcontainer-features

Personal collection of [Dev Container Features](https://containers.dev/implementors/features/).

## Features

| Feature | Description |
|---------|-------------|
| [openpelo](src/openpelo) | Installs [OpenPelo](https://github.com/doudar/Openpelo), an Android device manager for workout machines |
| [talosctl](src/talosctl) | Installs [talosctl](https://talos.dev), the CLI for managing Talos Linux Kubernetes clusters |
| [bitwarden-cli](src/bitwarden-cli) | Installs the [Bitwarden CLI](https://bitwarden.com/help/cli/) (`bw`), fetching the latest release from GitHub |
| [atuin](src/atuin) | Installs [Atuin](https://atuin.sh), a magical shell history replacement backed by SQLite |
| [helmfile](src/helmfile) | Installs [Helmfile](https://helmfile.readthedocs.io), a declarative spec for deploying Helm charts as infrastructure-as-code |
| [apt-packages](src/apt-packages) | Installs comma-delimited apt packages on Debian/Ubuntu-based dev containers |
| [kubectl](src/kubectl) | Installs [kubectl](https://kubernetes.io/docs/reference/kubectl/), the Kubernetes command-line tool |
| [kustomize](src/kustomize) | Installs [Kustomize](https://kubectl.docs.kubernetes.io/references/kustomize/) |
| [minikube](src/minikube) | Installs [minikube](https://minikube.sigs.k8s.io/docs/) for local Kubernetes clusters |
| [protoc](src/protoc) | Installs [protoc](https://protobuf.dev/), the Protocol Buffers compiler |
| [go-install](src/go-install) | Installs comma-delimited Go command packages using `go install` |
| [just](src/just) | Installs [just](https://just.systems), a handy command runner for saving and running project-specific commands |

## Usage

```json
{
    "features": {
        "ghcr.io/charlysotelo/devcontainer-features/copilot:1": {}
    }
}
```
