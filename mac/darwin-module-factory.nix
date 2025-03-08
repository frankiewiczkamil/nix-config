{ platform, hostname }:
{
  config,
  pkgs,
  system,
  ...
}:

{
  environment.systemPackages = import ./darwin-packages.nix { pkgs = pkgs; };

  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = platform;
  networking.hostName = hostname;
  programs.zsh.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
  system = {
    stateVersion = 5;
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
