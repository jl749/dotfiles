{
  description = "Nixos config flake";

  inputs = {
    # https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual/release-notes
    # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-configuration-explained
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }@inputs:
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

      nixosConfigurations = {
        # e.g. `sudo nixos-rebuild switch --flake /etc/nixos/#default`
        default = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/default/configuration.nix ];
        };
        
	      # e.g. `sudo nixos-rebuild switch --flake /etc/nixos/#playground`
        playground = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [ ./hosts/playground/configuration.nix ];
        };
      };
    };
}
