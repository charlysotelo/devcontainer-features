# Contributing

## Commit Messages

This repo uses [Conventional Commits](https://www.conventionalcommits.org/). Every commit to `main` must follow the format:

```
<type>(<optional scope>): <description>

[optional body]

[optional footer]
```

### Types

| Type | When to use | Version bump |
|------|-------------|--------------|
| `fix` | Bug fix in a feature's install or behavior | Patch (`1.0.x`) |
| `feat` | New capability added to a feature | Minor (`1.x.0`) |
| `feat!` / `BREAKING CHANGE:` | Incompatible change (e.g. renamed binary, removed option) | Major (`x.0.0`) |
| `chore` | Maintenance, CI, docs, tooling | None |
| `refactor` | Code restructuring with no behavior change | None |

### Scopes

Use the feature name as the scope to make it clear which component a commit affects:

```
fix(openpelo): install curl before downloading release
feat(copilot): add version option to pin a specific release
chore: update CI matrix base images
```

The scope is optional but encouraged. Release-please determines which packages to version based on which **files changed**, not the scope — but scopes keep the changelog readable.

## How Releases Work

Releases are fully automated via [release-please](https://github.com/googleapis/release-please).

1. **Push conventional commits to `main`** — release-please opens a Release PR with bumped versions and a generated changelog.
2. **Review and merge the Release PR** — release-please creates the GitHub release and tag.

Each feature (`src/copilot`, `src/openpelo`) versions independently. A commit that only touches `src/openpelo/` will only bump the `openpelo` version. The root repo version bumps whenever any releasable commit lands.

Version files updated automatically on release:
- `version.txt` — primary version file per package
- `src/<feature>/devcontainer-feature.json` — kept in sync via release-please `extra-files`

You should **never manually edit** `version.txt`, `devcontainer-feature.json` versions, or `.release-please-manifest.json`.

## Adding a New Feature

See the checklist in [`.github/copilot-instructions.md`](.github/copilot-instructions.md).

## Testing

```bash
npm install -g @devcontainers/cli

# Test a single feature
devcontainer features test --skip-scenarios -f <feature-name> -i ubuntu:24.04 .
```

CI runs automatically on pull requests for any feature whose files changed.
