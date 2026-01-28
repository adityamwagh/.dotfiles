# envvars.sh
# Common environment variables shared between .zshrc and .bashrc

# Fast PATH exports first (before any PATH-dependent commands)
if ! [[ "$PATH" =~ $HOME/.local/bin:$HOME/bin: ]]; then
	PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Set editor
export EDITOR="nvim"

# Pytest options
export PYTEST_ADDOPTS="-v -s --color=yes"

# Ruby Gems configuration
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH"

# Bun configuration
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Add CUDA to path (Linux only)
if [ "$(uname -s)" = "Linux" ] && [ -d /usr/local/cuda ]; then
	export PATH=/usr/local/cuda/bin:$PATH
	export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=/usr/lib64:$LD_LIBRARY_PATH
	export PATH=/usr/src/tensorrt/bin/:$PATH
fi

# >>> juliaup initialize >>>
# !! Contents within this block are managed by juliaup !!
case ":$PATH:" in
*:"$HOME/.juliaup/bin":*) ;;
*)
	export PATH="$HOME/.juliaup/bin${PATH:+:${PATH}}"
	;;
esac
# <<< juliaup initialize <<<

# Rust cargo environment
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Load local environment variables (secrets, machine-specific config)
[ -f "$HOME/.env" ] && . "$HOME/.env"
export LIBVA_DRIVER_NAME=iHD
