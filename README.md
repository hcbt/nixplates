# nixplates

Reusable Nix flake templates. The root `flake.nix` is the catalog entrypoint.

## Available Templates

- `python`: Packaged Python CLI app template (`example_pkg`) with `nix develop`, `uv`, and `pytest`.

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

## Template Variables

Nix flake templates are static file copies. `nix flake init` does not support interactive variables (for example, app name) at initialization time.

For the Python template, rename placeholders manually right after init:

1. Update `[project].name` and `[project.scripts]` in `pyproject.toml`.
2. Rename `src/example_pkg` to your package module name.
3. Update imports/tests and your run command accordingly.

## Adding a New Template

1. Add template files under `templates/<name>`.
2. Keep only source files in the template; do not commit `.direnv/` or `.devenv/`.
3. Ensure template control files (for example, `.gitignore`, `.python-version`) remain trackable.
4. Register `templates.<name>` in the root `flake.nix` and update `templates.default` if needed.
5. Add or update tests so the template can be initialized and validated in CI.
