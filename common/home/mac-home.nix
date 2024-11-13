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
  programs.home-manager.enable = true;

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    gpg.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';
      initExtraBeforeCompInit = builtins.readFile ./zsh/zshrc;
    };
    git = git-config;
  };

  home.file.".p10k.zsh".text = builtins.readFile ./zsh/p10k.zsh;
}
