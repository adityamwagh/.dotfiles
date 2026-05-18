# uv completions
if [ -n "$ZSH_VERSION" ]; then
  if command -v uv >/dev/null 2>&1; then
    eval "$(uv generate-shell-completion zsh 2>/dev/null)"
  fi
  if command -v uvx >/dev/null 2>&1; then
    eval "$(uvx --generate-shell-completion zsh 2>/dev/null)"
  fi
elif [ -n "$BASH_VERSION" ]; then
  if command -v uv >/dev/null 2>&1; then
    eval "$(uv generate-shell-completion bash 2>/dev/null)"
  fi
  if command -v uvx >/dev/null 2>&1; then
    eval "$(uvx --generate-shell-completion bash 2>/dev/null)"
  fi
fi
