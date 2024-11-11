{ config, pkgs, ... }:
{
  home.stateVersion = "24.05";

  home.packages = import ./mac-home-packages.nix { pkgs = pkgs; };

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
    git = {
      enable = true;
      userName = "kamil";
      userEmail = "frankiewiczkamil@gmail.com";
      signing = {
        key = "0x12A95E73B631A6FF";
        signByDefault = true;
      };
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };
  };

  home.file.".p10k.zsh".text = builtins.readFile ./zsh/p10k.zsh;
}
