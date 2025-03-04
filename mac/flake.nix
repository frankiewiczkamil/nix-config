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
    inputs@{
      self,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      darwinConfigurationFactory = import ../common/darwin/darwin-configuration-factory.nix;
      darwinHomeConfigFactory = import ../common/home/mac-home.nix;
      withLinuxBuilder = import ../common/darwin/linux-builder.nix;

      configFactory =
        {
          user-name,
          git-config,
          platform,
        }:
        let
          darwin-configuration = darwinConfigurationFactory platform;
        in
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
      darwinConfigurations.linux-builder = withLinuxBuilder (configFactory {
        user-name = "kamil";
        git-config = import ../priv/git-config.nix;
        platform = "aarch64-darwin";
      });
      darwinConfigurations.mac1 = configFactory {
        user-name = "kamil";
        git-config = import ../priv/git-config.nix;
        platform = "aarch64-darwin";
      };
      darwinConfigurations.mac2 = configFactory {
        user-name = "kamil.frankiewicz";
        git-config = import ../priv/git-config.nix; # todo add custom git config
        platform = "aarch64-darwin";
      };
      darwinConfigurations.mac3 = configFactory {
        user-name = "kamil";
        git-config = import ../priv/git-config.nix;
        platform = "x86_64-darwin";
      };
    };
}
