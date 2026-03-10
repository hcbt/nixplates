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
                ({ lib, ... }: {
                  languages.python.enable = true;
                  languages.python.package = pkgs.python314;
                  languages.python.uv.enable = true;
                  languages.python.uv.sync.enable = true;

                  git-hooks.package = pkgs.prek;
                  git-hooks.hooks = pythonGitHooks;
                  git-hooks.install.enable = false;

                  # devenv's git-hooks integration still installs hooks by default.
                  # Keep hook definitions/config, but require explicit `prek install`.
                  tasks."devenv:git-hooks:install".exec = lib.mkForce ''
                    echo "git-hooks.nix: automatic installation disabled; run 'prek install --hook-type pre-commit --hook-type pre-push'"
                  '';
                })
              ];
            };
          });
    };
}
