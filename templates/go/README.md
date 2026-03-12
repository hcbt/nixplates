# Go Template

Production-style Go CLI app template using Nix flakes, GoReleaser, and `prek` hooks.

## Prerequisites

- Nix with flakes enabled

## Development Shell

```bash
nix develop
```

## Run Tests

```bash
go test ./...
```

## Run the App

```bash
go run ./cmd/example-go
```

## Build with Nix

```bash
nix build .#example-go
# or
nix run .#example-go
```

## Install Git Hooks

One-time setup per generated repository:

```bash
prek install --hook-type pre-commit --hook-type pre-push
```

## Run Git Hooks

```bash
prek run --all-files
```

## GoReleaser

Validate release config:

```bash
goreleaser check --config .goreleaser.release.yml
```

Create a local snapshot build:

```bash
goreleaser release --snapshot --clean --config .goreleaser.release.yml
```

## Renaming the Placeholder App

`nix flake init` copies static template files. It does not support interactive variables.

After initialization, rename placeholders manually:

1. Update module path in `go.mod`.
2. Rename `cmd/example-go` if you want a different binary name.
3. Update import paths under `internal/` and tests.
4. Update `project_name`, image names, and import paths in `.goreleaser.release.yml` and `.goreleaser.publish.yml`.
5. Update workflow commands if they still reference `example-go`.
