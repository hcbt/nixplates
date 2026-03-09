# Python Template

Packaged Python CLI app template using Nix flakes and `uv`.

## Prerequisites

- Nix with flakes enabled

## Development Shell

```bash
nix develop
```

## Install Dependencies

```bash
uv sync --frozen
```

## Run Tests

```bash
uv run python -m pytest
```

## Run the App

```bash
uv run example-pkg
```

## Renaming the Placeholder App

`nix flake init` copies static template files. It does not support interactive variables (for example, app name) during initialization.

After initialization, rename placeholders manually:

1. Update `[project].name` and `[project.scripts]` in `pyproject.toml`.
2. Rename `src/example_pkg` to your package module name.
3. Update imports in tests and any run commands that reference `example-pkg` or `example_pkg`.
