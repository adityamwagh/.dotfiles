# tools.sh - Tool initializations
# Sources modular tool configs in correct order

TOOLS_DIR="$HOME/.dotfiles/shells/tools"

# 1. Homebrew (PATH setup - must be first)
[ -f "$TOOLS_DIR/homebrew.sh" ] && . "$TOOLS_DIR/homebrew.sh"

# 2. FZF (fuzzy finder)
[ -f "$TOOLS_DIR/fzf.sh" ] && . "$TOOLS_DIR/fzf.sh"

# 3. Starship prompt (before zoxide per docs)
[ -f "$TOOLS_DIR/starship.sh" ] && . "$TOOLS_DIR/starship.sh"

# 4. UV package manager completions
[ -f "$TOOLS_DIR/uv.sh" ] && . "$TOOLS_DIR/uv.sh"

# 5. Bun completions (zsh only)
[ -f "$TOOLS_DIR/bun.sh" ] && . "$TOOLS_DIR/bun.sh"

# 6. Zoxide (must be near end per docs)
[ -f "$TOOLS_DIR/zoxide.sh" ] && . "$TOOLS_DIR/zoxide.sh"
