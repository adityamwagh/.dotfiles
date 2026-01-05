# .profile
# Shell-agnostic profile for login shells
# Sources the appropriate shell-specific rc file based on the default shell

# Get the default shell
case "$SHELL" in
*/zsh)
	[ -f ~/.zshrc ] && . ~/.zshrc
	;;
*/bash)
	[ -f ~/.bashrc ] && . ~/.bashrc
	;;
*)
	# Fallback: try to detect from process name if $SHELL is not set
	case "$0" in
	*zsh)
		[ -f ~/.zshrc ] && . ~/.zshrc
		;;
	*bash)
		[ -f ~/.bashrc ] && . ~/.bashrc
		;;
	esac
	;;
esac
