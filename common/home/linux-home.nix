git-config:
{ config, pkgs, ... }:
let
  home-programs = import ./home-programs.nix { pkgs = pkgs; };
in
{
  home.stateVersion = "24.05";

  home.packages = import ./home-packages.nix { pkgs = pkgs; } ++ [ pkgs.pinentry-curses ];

  home.file = {
    ".gnupg/gpg-agent.conf".text = ''
      default-cache-ttl 36000
      default-cache-ttl-ssh 36000
      max-cache-ttl 72000
      max-cache-ttl-ssh 72000
      pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-curses
    '';
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };
  programs = home-programs // {
    git = git-config;
    gpg = {
      enable = true;
      settings.no-symkey-cache = true;
    };
  };

  home.file.".p10k.zsh".text = builtins.readFile ./zsh/p10k.zsh;
}
