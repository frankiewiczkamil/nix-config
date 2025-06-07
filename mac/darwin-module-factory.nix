{ platform, hostname }:
{
  config,
  pkgs,
  pkgs-unstable,
  system,
  ...
}:

{
  environment.systemPackages = import ./darwin-packages.nix { inherit pkgs pkgs-unstable; };
  home-manager.extraSpecialArgs = { inherit pkgs-unstable; };
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = platform;
  networking.hostName = hostname;
  programs.zsh.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;
  system = {
    stateVersion = 5;
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
