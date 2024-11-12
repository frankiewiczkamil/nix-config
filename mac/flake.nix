{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.05";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      darwin-configuration = ../common/darwin/darwin-configuration.nix;
      darwinHomeConfigFactory = import ../common/home/mac-home.nix;

      darwinConfigFactory =
        { user-name, git-config }:
        nix-darwin.lib.darwinSystem {
          modules = [
            darwin-configuration
            home-manager.darwinModules.home-manager
            {
              users.users.kamil.home = "/Users/${user-name}";
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                verbose = true;
                users.kamil = darwinHomeConfigFactory git-config;
              };
            }
          ];
        };
    in
    {
      darwinConfigurations.mac1 = darwinConfigFactory {
        user-name = "kamil";
        git-config = import ../priv/git-config.nix;
      };
      darwinConfigurations.mac2 = darwinConfigFactory {
        user-name = "kamil.frankiewicz";
        git-config = import ../priv/git-config.nix; # todo add custom git config
      };
    };
}
