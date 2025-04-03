{ pkgs, ... }:
{
  home-manager.enable = true;
  direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
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
}
