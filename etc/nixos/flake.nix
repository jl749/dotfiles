{
  description = "Nixos config flake";

  inputs = {
    # https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual/release-notes
    # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-configuration-explained
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nvf.url = "github:notashelf/nvf"; # nvf flake input for playground
  };

  outputs = { self, nixpkgs, nvf, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};
      # pkgs = import nixpkgs { 
      #   inherit system;
      #   config.allowUnfree = true;
      # };
    in
    {
      # packages = ...
      # devShells = ...
      # checks = ...
      # nixosModules = ...
      # nixosConfigurations = ...
      # packages.${system}.firefox = pkgs.firefox;
      # devShells.${system}.default = pkgs.mkShell {};
      # checks.${system}.unitTest = pkgs.runCommand {} ''
      #   make test
      # '';
      # nixModules.zsh = { programs.zsh.enable = true; };

      # add nvf configuration into a standalone package
      # nix run .#neovim
      packages.${system}.neovim = 
        (nvf.lib.neovimConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./nvf-configuration.nix ];
        }).neovim;

      nixosConfigurations = {
          default = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/default/configuration.nix
            ];
        };
        
        # e.g. example custom config
	      #   `sudo nixos-rebuild switch --flake /etc/nixos/#playground`
        playground = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [
            ./hosts/playground/configuration.nix
            nvf.nixosModules.default # add nvf module to configuration.nix
            ({ pkgs, ... }: {
              environment.systemPackages = [self.packages.${pkgs.stdenv.system}.neovim];
              programs.neovim.defaultEditor = true;
            })
          ];
        };
      };
    };
}
