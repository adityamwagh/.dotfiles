# .zshrc
# Source global definitions (if available)
case "$(uname -s)" in
Linux*)
    [ -f /etc/zshrc ] && . /etc/zshrc
    ;;
Darwin*)
    [ -f /etc/zshrc ] && . /etc/zshrc
    ;;
esac

# Source common environment variables
[ -f "$HOME/.dotfiles/shells/envvars.sh" ] && . "$HOME/.dotfiles/shells/envvars.sh"

# History configuration (fast options)
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# History variables
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase

# Key bindings (Emacs bindings)
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -e

# Source shared aliases
[ -f "$HOME/.dotfiles/shells/aliases.sh" ] && . "$HOME/.dotfiles/shells/aliases.sh"

# Load and initialise completion system (after PATH is set)
fpath+=~/.zfunc
autoload -Uz compinit && compinit

# Source tool and application initializations
[ -f "$HOME/.dotfiles/shells/tools.sh" ] && . "$HOME/.dotfiles/shells/tools.sh"

# zsh syntax highlighting (if installed) - MUST be absolutely last in zsh
[ -f "$HOME/.dotfiles/shells/zsh/zsh-syntax.sh" ] && . "$HOME/.dotfiles/shells/zsh/zsh-syntax.sh"
