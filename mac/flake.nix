{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
      nixpkgs,
      nixpkgs-unstable,
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
          system,
        }:
        let
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            darwin-module
            home-manager.darwinModules.home-manager
            home-manager-module
          ];
          specialArgs = { inherit pkgs-unstable; };
        };
    in
    {
      darwinConfigurations = {
        spaceship = config-factory rec {
          system = "aarch64-darwin";
          darwin-module = darwin-module-factory {
            platform = system;
            hostname = "spaceship";
          };
          home-manager-module = home-manager-module-factory {
            user-name = "kamil";
            home-config = create-home-config {
              git-config = priv-git-config;
            };
          };
        };
        chariot = config-factory rec {
          system = "x86_64-darwin";
          darwin-module = darwin-module-factory {
            platform = system;
            hostname = "chariot";
          };
          home-manager-module = home-manager-module-factory {
            user-name = "kamil";
            home-config = create-home-config {
              git-config = priv-git-config;
            };
          };
        };
        linux-builder = config-factory rec {
          system = "aarch64-darwin";
          create-darwin-module = with-linux-builder (darwin-module-factory {
            platform = system;
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
