# devcontainer-features

Personal collection of [Dev Container Features](https://containers.dev/implementors/features/).

## Features

| Feature | Description |
|---------|-------------|
| [copilot](src/copilot) | Installs the GitHub Copilot CLI via the official install script |
| [openpelo](src/openpelo) | Installs [OpenPelo](https://github.com/doudar/Openpelo), an Android device manager for workout machines |
| [talosctl](src/talosctl) | Installs [talosctl](https://talos.dev), the CLI for managing Talos Linux Kubernetes clusters |
| [bitwarden-cli](src/bitwarden-cli) | Installs the [Bitwarden CLI](https://bitwarden.com/help/cli/) (`bw`), fetching the latest release from GitHub |
| [atuin](src/atuin) | Installs [Atuin](https://atuin.sh), a magical shell history replacement backed by SQLite |

## Usage

```json
{
    "features": {
        "ghcr.io/charlysotelo/devcontainer-features/copilot:1": {}
    }
}
```
