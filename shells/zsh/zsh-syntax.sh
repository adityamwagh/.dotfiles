# zsh-syntax.sh
# zsh syntax highlighting configuration
# MUST be absolutely last in zsh configuration

[ -z "$ZSH_VERSION" ] && return

# Load fast-syntax-highlighting plugin (supports subcommand highlighting)
case "$(uname -s)" in
Darwin*)
    [ -f /opt/homebrew/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] &&
        . /opt/homebrew/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    ;;
Linux*)
    [ -f /usr/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] &&
        . /usr/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    [ -f /home/linuxbrew/.linuxbrew/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] &&
        . /home/linuxbrew/.linuxbrew/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    ;;
esac

# Configure fast-syntax-highlighting styles
# Custom: bold red for unknown commands, bold green for existing commands, bold yellow for builtins
# Note: FAST_HIGHLIGHT_STYLES uses theme-prefixed keys

# Main Highlighter Styles
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}unknown-token]='fg=red,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}reserved-word]='fg=yellow'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}alias]='fg=green,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}suffix-alias]='fg=cyan,underline'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}global-alias]='fg=cyan,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}builtin]='fg=yellow,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}function]='fg=green,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}command]='fg=green,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}precommand]='fg=green,underline'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}commandseparator]='fg=magenta'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}hashed-command]='fg=green,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}subcommand]='fg=11'                         # Subcommands (custom: bright yellow)
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path]='fg=white,underline'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path-to-dir]='fg=white,underline'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}globbing]='fg=blue,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}history-expansion]='fg=blue,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}single-hyphen-option]='fg=yellow'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-hyphen-option]='fg=yellow'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}back-quoted-argument]='fg=magenta'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}single-quoted-argument]='fg=yellow'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-quoted-argument]='fg=yellow'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}dollar-quoted-argument]='fg=yellow'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}back-quoted-argument-unclosed]='fg=red,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}single-quoted-argument-unclosed]='fg=red,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-quoted-argument-unclosed]='fg=red,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}dollar-quoted-argument-unclosed]='fg=red,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}command-substitution]='fg=magenta'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}command-substitution-delimiter]='fg=magenta,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}process-substitution]='fg=magenta'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}process-substitution-delimiter]='fg=magenta,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}arithmetic-expansion]='fg=blue'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}assign]='fg=yellow'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}redirection]='fg=magenta'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}comment]='fg=black,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}named-fd]='fg=magenta'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}numeric-fd]='fg=magenta'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}arg0]='fg=green'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}default]='fg=white'

# Brackets
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}bracket-error]='fg=red,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}bracket-level-1]='fg=blue,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}bracket-level-2]='fg=green,bold'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}bracket-level-3]='fg=magenta,bold'
