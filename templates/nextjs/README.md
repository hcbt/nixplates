# Next.js Template

Full-stack Next.js canary template using Nix flakes + `devenv`, Drizzle ORM, PostgreSQL, Biome, Vitest, and Playwright.

## Prerequisites

- Nix with flakes enabled

## Development Shell

```bash
nix develop
```

## Install Dependencies

```bash
pnpm install --frozen-lockfile
```

## Start Local Services

```bash
devenv up -d
```

## Run the App

```bash
pnpm dev
```

## Health Endpoint

```bash
curl http://127.0.0.1:3000/api/health
```

## Database Tasks

```bash
pnpm db:generate
pnpm db:migrate
pnpm db:studio
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

## Run Tests

```bash
pnpm test
pnpm test:e2e
```

## Build

```bash
pnpm build
```

## Build/Run via Nix

```bash
nix build .#example-nextjs
nix run .#example-nextjs
```

## Docker

```bash
docker build -t example-nextjs .
```

## Renaming the Placeholder App

`nix flake init` copies static template files. It does not support interactive variables.

After initialization, rename placeholders manually:

1. Update `name` in `package.json`.
2. Update `title` metadata in `src/app/layout.tsx`.
3. Update workflow commands if they still reference `example-nextjs`.
4. Update `flake.nix` package/app names if you want a different Nix app id.
