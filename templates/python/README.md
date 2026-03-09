# Python Template

Minimal Python project template using Nix flakes and `uv`.

## Prerequisites

- Nix with flakes enabled
- Optional: `direnv`

## Development Shell

```bash
direnv allow
# or
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
uv run python main.py
```
