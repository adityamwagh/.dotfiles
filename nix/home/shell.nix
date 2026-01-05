{ config, pkgs, ... }:

let
  dotfilesPath = "${config.home.homeDirectory}/.dotfiles";
in
{
  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 5000;
      save = 5000;
      path = "${config.home.homeDirectory}/.zsh_history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

    initExtra = ''
      # Source environment variables
      [ -f "${dotfilesPath}/shells/envvars.sh" ] && . "${dotfilesPath}/shells/envvars.sh"

      # Source aliases
      [ -f "${dotfilesPath}/shells/aliases.sh" ] && . "${dotfilesPath}/shells/aliases.sh"

      # Source tools initialization
      [ -f "${dotfilesPath}/shells/tools.sh" ] && . "${dotfilesPath}/shells/tools.sh"

      # Source zsh syntax highlighting
      [ -f "${dotfilesPath}/shells/zsh/zsh-syntax.sh" ] && . "${dotfilesPath}/shells/zsh/zsh-syntax.sh"

      # Key bindings (Emacs bindings)
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey -e

      # Additional zsh options
      setopt appendhistory
      setopt sharehistory
      setopt hist_ignore_space
      setopt hist_ignore_all_dups
      setopt hist_save_no_dups
      setopt hist_ignore_dups
      setopt hist_find_no_dups

      # Load and initialize completion system
      fpath+=~/.zfunc
      autoload -Uz compinit && compinit
    '';
  };

  # Bash configuration
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = [ "ignoreboth" "erasedups" ];
    historyIgnore = [ "ls" "la" "ll" "cd" "cd -" "pwd" "exit" "clear" ];
    historySize = 5000;
    historyFileSize = 5000;

    initExtra = ''
      # Source environment variables
      [ -f "${dotfilesPath}/shells/envvars.sh" ] && . "${dotfilesPath}/shells/envvars.sh"

      # Source aliases
      [ -f "${dotfilesPath}/shells/aliases.sh" ] && . "${dotfilesPath}/shells/aliases.sh"

      # Source tools initialization
      [ -f "${dotfilesPath}/shells/tools.sh" ] && . "${dotfilesPath}/shells/tools.sh"
    '';
  };
}
