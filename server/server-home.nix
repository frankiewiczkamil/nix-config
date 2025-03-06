{ config, pkgs, ... }:
{
  home.stateVersion = "24.11";

  home.packages = import ../common/home/home-packages.nix { pkgs = pkgs; } ++ [ ];

  home.sessionVariables = {
    EDITOR = "vim";
  };
  programs = import ../common/home/home-programs.nix { pkgs = pkgs; };

  home.file.".p10k.zsh".text = builtins.readFile ../common/home/zsh/p10k.zsh;
}
