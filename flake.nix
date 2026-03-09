{
  description = "nixplates template catalog";

  outputs = { self }: {
    templates.python = {
      path = ./templates/python;
      description = "Python template with Nix + uv + pytest";
      welcomeText = ''
        # nixplates Python template

        Quick start:
          direnv allow
          # or: nix develop

        Then run:
          uv sync --frozen
          uv run python -m pytest
          uv run python main.py
      '';
    };

    templates.default = self.templates.python;
  };
}
