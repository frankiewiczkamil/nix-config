platform: {
  config,
  pkgs,
  system,
  ...
}:

{
  networking.hostName = "kamil";
  environment.systemPackages = import ./darwin-packages.nix { pkgs = pkgs; };

  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;

  system.stateVersion = 5;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  security.pam.enableSudoTouchIdAuth = true;

  nixpkgs.hostPlatform = platform;

  # User account settings
  # users.users.kamil = {
  #   name = "kamil";
  #   # isNormalUser = true;
  #   # extraGroups = [ "wheel" "audio" "video" ];
  # };
}
