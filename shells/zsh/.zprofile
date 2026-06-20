# .zprofile
# shellcheck source=/dev/null
[ -f ~/.profile ] && . ~/.profile
# Note: zsh sources ~/.zshrc automatically for every interactive shell, so we
# must NOT source it here — doing so runs ~/.zshrc twice on login shells.
