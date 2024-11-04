{
    description = "Nix Configurations";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";

        nix-darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, nix-darwin, home-manager, ... }:
        let
            configuration = ./darwin-configuration.nix;
            configurationRevision = self.rev or self.dirtyRev or null;
        in { 
            darwinConfigurations = {
                kamil = nix-darwin.lib.darwinSystem {
                    modules = [ 
                        configuration
                        home-manager.darwinModules.home-manager  {
                            users.users.kamil.home = "/Users/kamil";
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;
                            home-manager.verbose = true;
                            home-manager.users.kamil = import ./home.nix;
                        }
                    ];
                };
            };
        };
    }
