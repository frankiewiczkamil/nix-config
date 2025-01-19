git-config:
{ config, pkgs, ... }:
let
  home-programs = import ./home-programs.nix { pkgs = pkgs; };
in
{
  home.stateVersion = "24.05";

  home.packages = import ./home-packages.nix { pkgs = pkgs; } ++ [ pkgs.pinentry_mac ];

  home.file = {
    ".gnupg/gpg-agent.conf".text = ''
      default-cache-ttl 86400 # 1 day
      default-cache-ttl-ssh 86400
      max-cache-ttl 604800 # 1 week
      max-cache-ttl-ssh 604800
      pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
    '';
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs = home-programs // {
    git = git-config;
    gpg.enable = true;
  };

  home.file.".p10k.zsh".text = builtins.readFile ./zsh/p10k.zsh;
}
