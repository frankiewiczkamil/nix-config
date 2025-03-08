{ git-config, state-version }:
{ config, pkgs, ... }:
let
  home-programs = import ../common/home/home-programs.nix { pkgs = pkgs; };
in
{
  home = {
    packages = import ../common/home/home-packages.nix { pkgs = pkgs; } ++ [ pkgs.pinentry_mac ];
    file = {
      ".gnupg/gpg-agent.conf".text = ''
        default-cache-ttl 86400 # 1 day
        default-cache-ttl-ssh 86400
        max-cache-ttl 604800 # 1 week
        max-cache-ttl-ssh 604800
        pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
      '';
      ".p10k.zsh".text = builtins.readFile ../common/home/zsh/p10k.zsh;
    };
    sessionVariables = {
      EDITOR = "vim";
    };
    stateVersion = state-version;
  };

  programs = home-programs // {
    git = git-config;
    gpg.enable = true;
  };
}
