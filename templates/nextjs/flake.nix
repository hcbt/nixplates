{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.url = "github:cachix/git-hooks.nix";
    devenv.inputs.git-hooks.follows = "git-hooks";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, git-hooks, ... } @ inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = nixpkgs.lib.genAttrs supportedSystems;

      mkWebGitHooks = pkgs: {
        check-merge-conflicts.enable = true;
        check-yaml.enable = true;
        end-of-file-fixer.enable = true;
        trim-trailing-whitespace.enable = true;
        biome = {
          enable = true;
          name = "biome";
          entry = "${pkgs.biome}/bin/biome check .";
          language = "system";
          pass_filenames = false;
        };
      };
    in
    {
      packages = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            nextjsPackage = pkgs.writeShellApplication {
              name = "example-nextjs";
              runtimeInputs = [
                pkgs.nodejs_24
                pkgs.pnpm
              ];
              text = ''
                if [ ! -f package.json ]; then
                  echo "Run this command from the repository root containing package.json." >&2
                  exit 1
                fi

                exec pnpm start "$@"
              '';
            };
          in
          {
            default = nextjsPackage;
            example-nextjs = nextjsPackage;
          });

      checks = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            package = self.packages.${system}.default;
            preCommitCheck = git-hooks.lib.${system}.run {
              src = ./.;
              package = pkgs.prek;
              hooks = mkWebGitHooks pkgs;
            };
          in
          {
            default = package;
            example-nextjs = package;
            pre-commit-check = preCommitCheck;
          });

      apps = forEachSystem
        (system:
          let
            package = self.packages.${system}.default;
          in
          {
            default = {
              type = "app";
              program = "${package}/bin/example-nextjs";
            };
            example-nextjs = {
              type = "app";
              program = "${package}/bin/example-nextjs";
            };
          });

      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                ({ ... }: {
                  languages.javascript.enable = true;
                  languages.javascript.package = pkgs.nodejs_24;
                  languages.javascript.pnpm.enable = true;

                  env.DATABASE_URL = "postgresql://postgres:postgres@127.0.0.1:5432/nextjs_template";

                  services.postgres = {
                    enable = true;
                    listen_addresses = "127.0.0.1";
                    port = 5432;
                    initialDatabases = [
                      {
                        name = "nextjs_template";
                        user = "postgres";
                        pass = "postgres";
                      }
                    ];
                  };

                  packages = with pkgs; [
                    biome
                  ];

                  git-hooks.package = pkgs.prek;
                  git-hooks.hooks = mkWebGitHooks pkgs;
                  git-hooks.install.enable = false;
                  tasks."devenv:git-hooks:install".status = "exit 0";
                })
              ];
            };
          });
    };
}
