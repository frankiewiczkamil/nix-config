{ user-name, home-config }:
{
  users.users.${user-name}.home = "/Users/${user-name}";
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user-name} = home-config;
  };
}
