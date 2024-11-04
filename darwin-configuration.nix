{ config, pkgs, system, ... }:

{
  networking.hostName = "kamil";
  environment.systemPackages = import ./system-packages.nix { pkgs = pkgs; };


  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;

  system.stateVersion = 5;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  security.pam.enableSudoTouchIdAuth = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  # User account settings
  # users.users.kamil = {
  #   name = "kamil";
  #   # isNormalUser = true;
  #   # extraGroups = [ "wheel" "audio" "video" ];
  # };
}