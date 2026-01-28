# UV package manager completions (cached for faster startup)
_uv_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/uv-completions"
if [ -n "$ZSH_VERSION" ]; then
    if command -v uv >/dev/null 2>&1; then
        _uv_cache="$_uv_cache_dir/uv.zsh"
        if [[ ! -f "$_uv_cache" || ! -s "$_uv_cache" ]]; then
            mkdir -p "$_uv_cache_dir"
            uv generate-shell-completion zsh > "$_uv_cache" 2>/dev/null
        fi
        [[ -f "$_uv_cache" ]] && source "$_uv_cache"
    fi
    if command -v uvx >/dev/null 2>&1; then
        _uvx_cache="$_uv_cache_dir/uvx.zsh"
        if [[ ! -f "$_uvx_cache" || ! -s "$_uvx_cache" ]]; then
            mkdir -p "$_uv_cache_dir"
            uvx --generate-shell-completion zsh > "$_uvx_cache" 2>/dev/null
        fi
        [[ -f "$_uvx_cache" ]] && source "$_uvx_cache"
    fi
elif [ -n "$BASH_VERSION" ]; then
    if command -v uv >/dev/null 2>&1; then
        _uv_cache="$_uv_cache_dir/uv.bash"
        if [[ ! -f "$_uv_cache" || ! -s "$_uv_cache" ]]; then
            mkdir -p "$_uv_cache_dir"
            uv generate-shell-completion bash > "$_uv_cache" 2>/dev/null
        fi
        [[ -f "$_uv_cache" ]] && source "$_uv_cache"
    fi
    if command -v uvx >/dev/null 2>&1; then
        _uvx_cache="$_uv_cache_dir/uvx.bash"
        if [[ ! -f "$_uvx_cache" || ! -s "$_uvx_cache" ]]; then
            mkdir -p "$_uv_cache_dir"
            uvx --generate-shell-completion bash > "$_uvx_cache" 2>/dev/null
        fi
        [[ -f "$_uvx_cache" ]] && source "$_uvx_cache"
    fi
fi
unset _uv_cache_dir _uv_cache _uvx_cache
