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

## Run Pre-commit Hooks

```bash
uv run pre-commit run --all-files
```

## Run Tests

```bash
uv run python -m pytest
```

## Run the App

```bash
uv run example-pkg
```

## Nix Flake Outputs

Run as a flake app:

```bash
nix run
# or
nix run .#example-pkg
```

Install into a profile:

```bash
nix profile add .#example-pkg
```

Use from another flake input:

```nix
{
  inputs.example-pkg.url = "path:./path/to/this/template";

  outputs = { self, nixpkgs, example-pkg, ... }:
    let
      system = "x86_64-linux";
    in
    {
      packages.${system}.default = example-pkg.packages.${system}.default;
    };
}
```

## Renaming the Placeholder App

`nix flake init` copies static template files. It does not support interactive variables (for example, app name) during initialization.

After initialization, rename placeholders manually:

1. Update `[project].name` and `[project.scripts]` in `pyproject.toml`.
2. Rename `src/example_pkg` to your package module name.
3. Update imports in tests and any run commands that reference `example-pkg` or `example_pkg`.
4. Update workflow commands in `.github/workflows/test.yml` and `.github/workflows/release.yml` if they still reference `example-pkg` or `example_pkg`.
