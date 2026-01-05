# Starship prompt initialization
if [ -n "$ZSH_VERSION" ]; then
    command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
elif [ -n "$BASH_VERSION" ]; then
    command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"
fi
