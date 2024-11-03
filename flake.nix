{
    description = "Nix Configurations";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
        nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;

        nix-darwin.url = "github:LnL7/nix-darwin";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

        # home-manager.url = "github:nix-community/home-manager";
        # home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    outputs = inputs@{ self, nix-darwin, ... }:
        let
            configuration = ./darwin-configuration.nix;
            configurationRevision = self.rev or self.dirtyRev or null;
        in { 
            darwinConfigurations = {
                kamil = nix-darwin.lib.darwinSystem {
                    modules = [ configuration ];
                };
            };
        };
    }
