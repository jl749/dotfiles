{
  description = "Nixos config flake";

  # Package sources. `nixpkgs` is the stable base for the whole system;
  # `nixpkgs-unstable` exists only to cherry-pick newer packages (see overlay).
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";

      # Expose the rolling channel as `pkgs.unstable.<name>`, so a single
      # package can track unstable while everything else stays on stable.
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      # gthumb 3.12.10 segfaults fix (Clutter 1.26 has been unmaintained since 2020)
      overlay-gthumb = final: prev: {
        gthumb = prev.gthumb.overrideAttrs (old: {
          mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dclutter=false" ];
        });
      };

      # Stable package set, available for any custom flake outputs added later.
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # Build a host with: sudo nixos-rebuild switch --flake /etc/nixos#<name>
      nixosConfigurations = {
        # Primary machine. Gets the unstable overlay for cherry-picked packages.
        default = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ overlay-unstable overlay-gthumb ]; }
            ./hosts/default/configuration.nix
          ];
        };

        # Scratch/testing host. Pure stable — no unstable overlay.
        playground = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [ ./hosts/playground/configuration.nix ];
        };
      };
    };
}
