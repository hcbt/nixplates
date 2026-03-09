# nixplates

Reusable Nix flake templates. The root `flake.nix` is the catalog entrypoint.

## Available Templates

- `python`: Python project template with `nix develop`, `uv`, and `pytest`.

## Usage

Initialize using the default template:

```bash
nix flake init -t github:<org>/nixplates
```

Initialize using the Python template explicitly:

```bash
nix flake init -t github:<org>/nixplates#python
```

For local development and CI validation from this repository:

```bash
nix flake init -t "path:${PWD}#python"
```

## Adding a New Template

1. Add template files under `templates/<name>`.
2. Keep only source files in the template; do not commit `.direnv/` or `.devenv/`.
3. Register `templates.<name>` in the root `flake.nix` and update `templates.default` if needed.
4. Add or update tests so the template can be initialized and validated in CI.
