{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, ... } @ inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
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
            package = self.packages.${system}.default;
          in
          {
            default = package;
            example-pkg = package;
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
                {
                  languages.python.enable = true;
                  languages.python.package = pkgs.python314;
                  languages.python.uv.enable = true;
                  languages.python.uv.sync.enable = true;
                }
              ];
            };
          });
    };
}
