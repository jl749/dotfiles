{
  description = "rust template";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = 
      pkgs.mkShell {
        nativeBuildInputs = [];
        buildInputs = with pkgs; [
          cargo
          rustc
        ];
        packages = [];

        shellHook = ''
          echo "Hello Rust!!"
          echo "rustc_version: $(rustc --version)"
          echo "cargo_version: $(cargo --version)"
        '';

        COLOR = "blue";
      };
  };
}
