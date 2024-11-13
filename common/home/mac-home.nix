git-config:
{ config, pkgs, ... }:
{
  home.stateVersion = "24.05";

  home.packages = import ./home-packages.nix { pkgs = pkgs; } ++ [ pkgs.pinentry_mac ];

  home.file = {
    ".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
    '';
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs = import ./home-programs.nix {
    pkgs = pkgs;
    git-config = git-config;
    gpg-config = {
      enable = true;
    };
  };

  home.file.".p10k.zsh".text = builtins.readFile ./zsh/p10k.zsh;
}
