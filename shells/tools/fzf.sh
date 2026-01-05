# FZF (Fuzzy Finder) initialization
if [ -n "$ZSH_VERSION" ]; then
    [ -f ~/.fzf.zsh ] && . ~/.fzf.zsh
    command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"
elif [ -n "$BASH_VERSION" ]; then
    [ -f ~/.fzf.bash ] && . ~/.fzf.bash
    command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"
fi
