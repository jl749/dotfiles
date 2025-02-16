{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      # pkgs = import nixpkgs { 
      #   inherit system;
      #   config.allowUnfree = true;
      # };
      pkgs = nixpkgs.legacyPackages.${system};
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

      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [
            ./hosts/default/configuration.nix
            # ({ pkgs, ... }: {
            #   programs.vim.defaultEditor = true;
            # })
          ];
        };
        
        # e.g. example custom config
	      #   `sudo nixos-rebuild switch --flake /etc/nixos/#gaming`
        gaming = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/gaming/configuration.nix
          ];
        };

      };

      homeConfigurations = {
        default = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/default/home.nix ];
        };
      };

    };
}
