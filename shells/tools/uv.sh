# UV package manager completions
if [ -n "$ZSH_VERSION" ]; then
    command -v uv >/dev/null 2>&1 && eval "$(uv generate-shell-completion zsh)"
    command -v uvx >/dev/null 2>&1 && eval "$(uvx --generate-shell-completion zsh)"
elif [ -n "$BASH_VERSION" ]; then
    command -v uv >/dev/null 2>&1 && eval "$(uv generate-shell-completion bash)"
    command -v uvx >/dev/null 2>&1 && eval "$(uvx --generate-shell-completion bash)"
fi
