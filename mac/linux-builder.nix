# passed darwin module (config-module-fn) is actually a function, not an object
config-module-fn:
args@{
  pkgs,
  config,
  system,
  ...
}:
let
  result-config = config-module-fn args;

in
result-config
// {
  nix = result-config.nix // {
    linux-builder.enable = true;
    settings = result-config.nix.settings // {
      trusted-users = [ "@admin" ];
    };
  };
}
