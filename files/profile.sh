#!/bin/sh
# Environment variables are set here for login shells.

export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LESS="-i -j.49 -M -R -z-2"
export LESSHISTFILE="$XDG_DATA_HOME/less/history"
export LESSHISTSIZE=1000
export LOCAL_CONFIG="$HOME/.local/etc"
export LOCAL_PREFIX="/usr/local"
export PAGER=less
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Make man pages pretty
Reset="$(tput sgr0)"
export LESS_TERMCAP_md="$(printf '%s\n' 'setaf 3' | tput -S)"
export LESS_TERMCAP_mb="$LESS_TERMCAP_md"
export LESS_TERMCAP_me="$Reset"
export LESS_TERMCAP_us="$(printf '%s\n' 'setaf 7' 'smul' | tput -S)"
export LESS_TERMCAP_ue="$Reset"
export LESS_TERMCAP_so="$(printf '%s\n' 'setaf 4' 'setab 0' | tput -S)"
export LESS_TERMCAP_se="$Reset"
export GROFF_NO_SGR=1

# Prevent path_helper from messing with the PATH when starting tmux.
#   See: https://superuser.com/a/583502
[ "$(uname -s)" = "Darwin" ] && { PATH=""; source /etc/profile; }

# Add custom bin dirs to PATH if they exist and are not already in PATH.
while read -r dir; do
    case ":${PATH:=$dir}:" in
        *:"$dir":*) ;;
        *) PATH="$dir:$PATH" ;;
    esac
done <<EOL
    $LOCAL_PREFIX/bin
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
    LOCAL_PREFIX="$(brew --prefix)"
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

