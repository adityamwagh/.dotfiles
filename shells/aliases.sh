# Shared aliases for both bash and zsh

# `clear` aliases
alias clr="clear"
alias cls="clear"

# `eza` aliases (if available)
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons --group-directories-first'
    alias la='eza -a --icons --group-directories-first'
    alias l='eza -l --icons --group-directories-first'
    alias ll='eza -lah --icons --git --group-directories-first'
    alias tree='eza --tree --icons --level 2 --group-directories-first'
    alias lt='eza --tree --level=2 --icons'         # Tree view 2 levels
    alias llt='eza --tree --level=3 --long --icons' # Detailed tree
fi

# Set brightness
if command -v ddcutil >/dev/null 2>&1; then
    alias brightness="ddcutil setvcp 10"
fi

# `uv` package manager typos and aliases
alias yv='uv'
alias uvr='uv run'
alias uvp='uv pip'
alias uvpi='uv pip install'
alias uvpri='uv pip install --reinstall'

# Editor aliases
alias vi='nvim'
alias vim='nvim'

# Quick edits
alias aliases='$EDITOR ~/.dotfiles/shells/aliases.sh'
alias envvars='$EDITOR ~/.dotfiles/shells/envvars.sh'
alias bashrc='$EDITOR ~/.bashrc'
alias zshrc='$EDITOR ~/.zshrc'
alias nvimc='$EDITOR ~/.config/nvim/'

# Pre-commit alias
alias pcra='pre-commit run --show-diff-on-failure --color=always --all-files'
alias pci='pre-commit install'

# Git aliases
alias gcm='git commit -m'
alias gc-am='git commit --amend'
alias gc-amne='git commit --amend --no-edit'
alias gc-amra='git commit --amend --reset-author'
alias gc='git commit'
alias gp-fwl='git push --force-with-lease'
alias gf='git fetch --prune'
alias gco='git checkout'
alias gs='git status'
alias gpl='git pull'
alias gre='git rebase'
alias gd='git diff'

# Better logging
alias gll='git log --oneline --graph --decorate -10' # Last 10 commits
alias gla='git log --all --graph --decorate --oneline'
alias gl='git log --oneline --graph --decorate --all'

# Stash operations
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'

# Quick navigation (with zoxide already installed)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Cat aliases
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --theme=base16'
fi

# Replace node with bun
if command -v bun >/dev/null 2>&1; then
    alias node='bun'
    alias npm='bun'
    alias yarn='bun'
    alias pnpm='bun'
fi

# System aliases
alias sudo='sudo '

# Safety aliases for destructive operations
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# System package manager aliases
if command -v apt >/dev/null 2>&1; then
    alias dnf='nala'
    alias apt='nala '
fi

if command -v dnf >/dev/null 2>&1; then
    alias apt='dnf '
    alias apt-get='dnf '
fi
