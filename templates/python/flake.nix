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
      pythonGitHooks = {
        check-merge-conflicts.enable = true;
        check-yaml.enable = true;
        end-of-file-fixer.enable = true;
        trim-trailing-whitespace.enable = true;
        ruff.enable = true;
        ruff-format.enable = true;
      };
    in
    {
      packages = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            pythonPackage = pkgs.python314Packages.buildPythonApplication {
              pname = "example-pkg";
              version = "0.1.0";
              pyproject = true;
              src = ./.;

              nativeBuildInputs = with pkgs.python314Packages; [ hatchling ];
              nativeCheckInputs = with pkgs.python314Packages; [ pytestCheckHook ];

              pythonImportsCheck = [ "example_pkg" ];
              pytestFlagsArray = [ "tests" ];
            };
          in
          {
            default = pythonPackage;
            example-pkg = pythonPackage;
          });

      checks = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            package = self.packages.${system}.default;
            preCommitCheck = git-hooks.lib.${system}.run {
              src = ./.;
              package = pkgs.prek;
              hooks = pythonGitHooks;
            };
          in
          {
            default = package;
            example-pkg = package;
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
              program = "${package}/bin/example-pkg";
            };
            example-pkg = {
              type = "app";
              program = "${package}/bin/example-pkg";
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
                ({ config, lib, ... }: {
                  languages.python.enable = true;
                  languages.python.package = pkgs.python314;
                  languages.python.uv.enable = true;
                  languages.python.uv.sync.enable = true;

                  git-hooks.package = pkgs.prek;
                  git-hooks.hooks = pythonGitHooks;
                  tasks."devenv:git-hooks:install".exec = lib.mkForce ''
                    if ! ${lib.getExe config.git-hooks.gitPackage} rev-parse --git-dir &> /dev/null; then
                      echo 1>&2 "WARNING: git-hooks.nix: .git not found; skipping hook installation."
                      exit 0
                    fi

                    git_toplevel="$(${lib.getExe config.git-hooks.gitPackage} rev-parse --show-toplevel)"
                    if [ "$PWD" != "$git_toplevel" ]; then
                      echo "git-hooks.nix: skipping hook installation outside git toplevel ($git_toplevel)"
                      exit 0
                    fi

                    # Work around repo-level hook collisions: only install when at repo top-level.
                    if [ "$(${lib.getExe config.git-hooks.gitPackage} config --get core.hooksPath 2>/dev/null)" = ".git/hooks" ]; then
                      ${lib.getExe config.git-hooks.gitPackage} config --unset core.hooksPath
                    fi

                    if [ -z "${lib.concatStringsSep " " config.git-hooks.installStages}" ]; then
                      ${lib.getExe config.git-hooks.package} install -c ${config.git-hooks.configPath}
                    else
                      for stage in ${lib.concatStringsSep " " config.git-hooks.installStages}; do
                        case "$stage" in
                          manual)
                            ;;
                          commit|merge-commit|push)
                            ${lib.getExe config.git-hooks.package} install -c ${config.git-hooks.configPath} -t "pre-$stage"
                            ;;
                          *)
                            ${lib.getExe config.git-hooks.package} install -c ${config.git-hooks.configPath} -t "$stage"
                            ;;
                        esac
                      done
                    fi
                  '';
                })
              ];
            };
          });
    };
}
