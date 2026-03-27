# bun
export BUN_INSTALL="$HOME/.bun"
case ":$PATH:" in
  *":$BUN_INSTALL/bin:"*) ;;
  *) export PATH="$BUN_INSTALL/bin:$PATH" ;;
esac

# bun completions (zsh)
[ -n "$ZSH_VERSION" ] && [ -s "$HOME/.bun/_bun" ] && . "$HOME/.bun/_bun"
