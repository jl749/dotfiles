{
  description = "rust template";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  outputs = { self, nixpkgs, rust-overlay }:
  let
    system = "x86_64-linux";
    
    overlays = [ (import rust-overlay) ];
    pkgs = import nixpkgs { inherit system overlays; };
    rustToolchain = pkgs.rust-bin.nightly.latest.default.override {
      extensions = [ "rust-src" "rust-analyzer" ];
    };
    dependencies = with pkgs; [
      # default pkgs
      rustToolchain
      pkg-config
      
      # additional pkgs
    ];
  in {
    devShells.${system}.default = 
      pkgs.mkShell {
        buildInputs = dependencies;
        shellHook = ''
          echo "Hello Rust!!"
          echo "rustc_version: $(rustc --version)"
          echo "cargo_version: $(cargo --version)"
        '';
        EDITOR="nvim"
        VISUAL="nvim"
      };
  };
}
