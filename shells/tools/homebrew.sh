# Homebrew initialization
brew_bin=""
if [ -n "${HOMEBREW_PREFIX:-}" ] && [ -x "${HOMEBREW_PREFIX}/bin/brew" ]; then
  brew_bin="${HOMEBREW_PREFIX}/bin/brew"
elif command -v brew > /dev/null 2>&1; then
  brew_bin="$(command -v brew)"
elif [ -x /opt/homebrew/bin/brew ]; then
  brew_bin="/opt/homebrew/bin/brew"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  brew_bin="/home/linuxbrew/.linuxbrew/bin/brew"
elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
  brew_bin="$HOME/.linuxbrew/bin/brew"
fi

if [ -n "$brew_bin" ]; then
  eval "$("$brew_bin" shellenv)"
fi

# Keep Linux system tools ahead of Homebrew by appending brew paths.
if [ "$(uname -s)" = "Linux" ] && [ -n "${HOMEBREW_PREFIX:-}" ]; then
  PATH=":${PATH}:"
  PATH="${PATH//:${HOMEBREW_PREFIX}\/bin:/:}"
  PATH="${PATH//:${HOMEBREW_PREFIX}\/sbin:/:}"
  PATH="${PATH#:}"
  PATH="${PATH%:}"
  export PATH="${PATH}:${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin"
fi
