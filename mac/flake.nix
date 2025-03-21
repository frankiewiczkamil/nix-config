{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nix-darwin,
      home-manager,
      ...
    }:
    let
      nix-version = "24.11"; # can't use this variable with `rec` keyword inside inputs object, for other args, unfortunately
      darwin-module-factory = import ./darwin-module-factory.nix;
      home-manager-module-factory = import ./darwin-home-manager-module-factory.nix;
      home-config-factory = import ./darwin-home-config-factory.nix;
      with-linux-builder = import ./linux-builder.nix;
      priv-git-config = import ../priv/git-config.nix;

      create-home-config =
        { git-config }:
        home-config-factory {
          inherit git-config;
          state-version = nix-version;
        };

      config-factory =
        {
          home-manager-module,
          darwin-module,
        }:
        nix-darwin.lib.darwinSystem {
          modules = [
            darwin-module
            home-manager.darwinModules.home-manager
            home-manager-module
          ];
        };
    in
    {
      darwinConfigurations = {
        spaceship = config-factory {
          darwin-module = darwin-module-factory {
            platform = "aarch64-darwin";
            hostname = "spaceship";
          };
          home-manager-module = home-manager-module-factory {
            user-name = "kamil";
            home-config = create-home-config {
              git-config = priv-git-config;
            };
          };
        };
        chariot = config-factory {
          darwin-module = darwin-module-factory {
            platform = "x86_64-darwin";
            hostname = "chariot";
          };
          home-manager-module = home-manager-module-factory {
            user-name = "kamil";
            home-config = create-home-config {
              git-config = priv-git-config;
            };
          };
        };
        linux-builder = config-factory {
          darwin-module = with-linux-builder (darwin-module-factory {
            platform = "aarch64-darwin";
            hostname = "linux-builder";
          });
          home-manager-module = home-manager-module-factory {
            user-name = "kamil";
            home-config = create-home-config {
              git-config = priv-git-config;
            };
          };
        };
      };
    };
}
