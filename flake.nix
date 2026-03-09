{
  description = "nixplates template catalog";

  outputs = { self }:
    let
      python = {
        path = ./templates/python;
        description = "Packaged Python CLI app template with Nix + uv + pytest";
        welcomeText = ''
          Quick start:
            direnv allow
            # or: nix develop

          Then run:
            uv sync --frozen
            uv run python -m pytest
            uv run example-pkg
        '';
      };
    in
    {
      templates = {
        inherit python;
        default = python;
      };
    };
}
