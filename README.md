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

## Usage

```json
{
    "features": {
        "ghcr.io/charlysotelo/devcontainer-features/copilot:1": {}
    }
}
```
