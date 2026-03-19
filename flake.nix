{
  description = "nixplates template catalog";

  outputs = { self }:
    let
      go = {
        path = ./templates/go;
        description = "Production-style Go CLI app template with Nix + GoReleaser + prek";
        welcomeText = ''
          Quick start:
            nix develop

          Then run:
            go test ./...
            go run ./cmd/example-go
        '';
      };
      python = {
        path = ./templates/python;
        description = "Packaged Python CLI app template with Nix + uv + pytest";
        welcomeText = ''
          Quick start:
            nix develop

          Then run:
            uv sync --frozen
            uv run python -m pytest
            uv run example-pkg
        '';
      };
      nextjs = {
        path = ./templates/nextjs;
        description = "Full-stack Next.js canary web app template with Nix + Drizzle + Playwright";
        welcomeText = ''
          Quick start:
            nix develop

          Then run:
            pnpm install --frozen-lockfile
            devenv up -d
            pnpm dev
        '';
      };
    in
    {
      templates = {
        inherit go;
        inherit python;
        inherit nextjs;
        default = python;
      };
    };
}
