{ config, pkgs, ... }:
{
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    deno
  ];
  home.sessionVariables = {
      EDITOR = "vim";
  };
  programs.home-manager.enable = true;
}