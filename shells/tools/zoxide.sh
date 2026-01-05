# Zoxide initialization (should be near end of shell config)
if [ -n "$ZSH_VERSION" ]; then
    command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"
elif [ -n "$BASH_VERSION" ]; then
    command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd bash)"
fi
