# nixplates

Reusable Nix flake templates. The root `flake.nix` is the catalog entrypoint.

## Available Templates

- `go`: Production-style Go CLI app template (`example-go`) with Nix, GoReleaser, and `prek`.
- `nextjs`: Full-stack Next.js canary web app template (`example-nextjs`) with Nix, Drizzle/PostgreSQL, and Playwright.
- `python`: Packaged Python CLI app template (`example_pkg`) with `nix develop`, `uv`, and `pytest`.

## Usage

Initialize using the default template:

```bash
nix flake init -t github:hcbt/nixplates
```

Initialize using the Python template explicitly:

```bash
nix flake init -t github:hcbt/nixplates#python
```

Initialize using the Go template explicitly:

```bash
nix flake init -t github:hcbt/nixplates#go
```

Initialize using the Next.js template explicitly:

```bash
nix flake init -t github:hcbt/nixplates#nextjs
```

For local development and CI validation from this repository:

```bash
nix flake init -t "path:./#python"
nix flake init -t "path:./#go"
nix flake init -t "path:./#nextjs"
```

## Template Variables

Nix flake templates are static file copies. `nix flake init` does not support interactive variables (for example, app name) at initialization time.

For the Python template, rename placeholders manually right after init:

1. Update `[project].name` and `[project.scripts]` in `pyproject.toml`.
2. Rename `src/example_pkg` to your package module name.
3. Update imports/tests and your run command accordingly.
4. Update commands in template workflows if they reference placeholder names.

For the Go template, rename placeholders manually right after init:

1. Update module path in `go.mod`.
2. Rename `cmd/example-go` if you want a different binary name.
3. Update import paths under `internal/` and tests.
4. Update `.goreleaser.release.yml` and `.goreleaser.publish.yml` placeholders.

## CI Scope

Root CI in this repository validates only the root flake catalog (`nix flake check`).
Template runtime/build validation lives in each template's own workflows after initialization.

## Adding a New Template

1. Add template files under `templates/<name>`.
2. Keep only source files in the template; do not commit `.direnv/` or `.devenv/`.
3. Ensure template control files (for example, `.gitignore`, `.python-version`) remain trackable.
4. Register `templates.<name>` in the root `flake.nix` and update `templates.default` if needed.
5. Add or update tests so the template can be initialized and validated in CI.
