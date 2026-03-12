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
      mkGoGitHooks = pkgs: {
        check-merge-conflicts.enable = true;
        check-yaml.enable = true;
        end-of-file-fixer.enable = true;
        trim-trailing-whitespace.enable = true;
        gofmt.enable = true;
        govet.enable = true;
        golangci-lint = {
          enable = true;
          package = pkgs.writeShellScriptBin "golangci-lint" ''
            export PATH=${pkgs.go}/bin:$PATH
            exec ${pkgs.golangci-lint}/bin/golangci-lint "$@"
          '';
        };
        gotest = {
          enable = true;
          stages = [ "pre-push" ];
        };
      };
    in
    {
      packages = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            goPackage = pkgs.buildGoModule {
              pname = "example-go";
              version = "0.1.0";
              src = builtins.path {
                path = ./.;
                name = "example-go-src";
              };
              vendorHash = null;
              subPackages = [ "cmd/example-go" ];
              ldflags = [
                "-s"
                "-w"
                "-X github.com/hcbt/example-go/internal/version.Version=0.1.0"
              ];
            };
          in
          {
            default = goPackage;
            example-go = goPackage;
          });

      checks = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            package = self.packages.${system}.default;
            preCommitCheck = git-hooks.lib.${system}.run {
              src = ./.;
              package = pkgs.prek;
              hooks = mkGoGitHooks pkgs;
            };
          in
          {
            default = package;
            example-go = package;
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
              program = "${package}/bin/example-go";
            };
            example-go = {
              type = "app";
              program = "${package}/bin/example-go";
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
                  languages.go.enable = true;

                  packages = with pkgs; [
                    goreleaser
                    golangci-lint
                  ];

                  git-hooks.package = pkgs.prek;
                  git-hooks.hooks = mkGoGitHooks pkgs;
                  git-hooks.install.enable = false;
                  tasks."devenv:git-hooks:install".status = "exit 0";
                })
              ];
            };
          });
    };
}
