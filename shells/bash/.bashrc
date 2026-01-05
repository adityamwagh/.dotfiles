# .bashrc

# Source global definitions
case "$(uname -s)" in
Linux*)
    [ -f /etc/bashrc ] && . /etc/bashrc
    ;;
Darwin*)
    [ -f /etc/bash.bashrc ] && . /etc/bash.bashrc
    ;;
esac

# Source common environment variables
[ -f "$HOME/.dotfiles/shells/envvars.sh" ] && . "$HOME/.dotfiles/shells/envvars.sh"

# History configuration
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:la:ll:cd:cd -:pwd:exit:clear"
export HISTFILE=~/.bash_history
export HISTSIZE
export HISTFILESIZE

# Source shared aliases
[ -f "$HOME/.dotfiles/shells/aliases.sh" ] && . "$HOME/.dotfiles/shells/aliases.sh"

# Source tool and application initializations
[ -f "$HOME/.dotfiles/shells/tools.sh" ] && . "$HOME/.dotfiles/shells/tools.sh"
