# This file is meant to be sourced from either $ZDOTDIR/.zshenv or
# $ZDOTDIR/.zshrc (see those files for explanation).

# Prevent path_helper from messing with the PATH when starting tmux.
#
# Clearing PATH before path_helper executes (from /etc/profile) will prevent it
# from prepending the default PATH to our (previously) chosen PATH, and will
# allow the rest of this file to set up PATH and MANPATH correctly.
#
#   For details see: https://superuser.com/a/583502
#
[ "$(uname -s)" = "Darwin" ] && { PATH=""; source /etc/profile; }

# Add custom bin dirs to PATH if they exist and are not already in PATH.
while read -r dir; do
    case ":${PATH:=$dir}:" in
        *:"$dir":*) ;;
        *) PATH="$dir:$PATH" ;;
    esac
done <<EOL
    $LOCAL_PREFIX/bin
    $LOCAL_PREFIX/opt/findutils/libexec/gnubin
    $HOME/.local/bin
EOL
export PATH

# Prepend custom man directories to MANPATH if they exist, so that we get
# correct man page entries when multiple versions of a command are
# available.
command -v manpath >/dev/null 2>&1 && MANPATH="$(unset MANPATH; manpath)"
while read -r dir; do
    case ":${MANPATH:=$dir}:" in
        *:"$dir":*) ;;
        *) MANPATH="$dir:$MANPATH" ;;
    esac
done <<EOL
    $LOCAL_PREFIX/share/man
    $LOCAL_PREFIX/opt/findutils/libexec/gnuman
    $HOME/.local/share/man
EOL
export MANPATH

unset dir

# These checks habe to be done after PATH manipulation above so we can find
# installed programs if they are in the added paths.

if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
else
    export EDITOR="vim"
fi

if command -v brew >/dev/null 2>&1; then
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

