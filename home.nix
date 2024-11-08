{ config, pkgs, ... }:
{
  home.stateVersion = "24.05";

  home.packages = import ./home-packages.nix { pkgs = pkgs; };
  
  home.file = {
    ".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry-curses}/bin/pinentry
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
      initExtraBeforeCompInit = builtins.readFile ./zshrc;
    };
  };

  home.file.".p10k.zsh".text = builtins.readFile ./p10k.zsh;

}