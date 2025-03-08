config:
config
// {
  nix = config.nix // {
    linux-builder.enable = true;
    settings = config.nix.settings // {
      trusted-users = [ "@admin" ];
    };
  };
}
