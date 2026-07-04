# Shared environment variables for bash and zsh

if [ -z "${PATH-}" ]; then
  PATH="/usr/bin:/bin"
fi

case ":$PATH:" in
  *":$HOME/.local/bin:$HOME/bin:"*) ;;
  *) PATH="$HOME/.local/bin:$HOME/bin:$PATH" ;;
esac
export PATH

export EDITOR="nvim"
export PYTEST_ADDOPTS="--color=yes -sv -o log_cli=true --log-cli-level=INFO"
export CLAUDE_CODE_DISABLE_MOUSE=1
export CLAUDE_CODE_NO_FLICKER=1
export CLAUDE_CODE_ALT_SCREEN_FULL_REPAINT=1
export CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1
export CLAUDE_CODE_NATIVE_CURSOR=0
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH"

if [ "$(uname -s)" = "Linux" ] && [ -d /usr/local/cuda ]; then
  export PATH="/usr/local/cuda/bin:$PATH"
  export LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH-}"
  export LD_LIBRARY_PATH="/usr/lib64:$LD_LIBRARY_PATH"
  export PATH="/usr/src/tensorrt/bin/:$PATH"
fi

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -f "$HOME/.env" ] && . "$HOME/.env"

[ -f "$HOME/.local/shell/env.sh" ] && . "$HOME/.local/shell/env.sh"
