#!/bin/sh
# Environment variables are set here for login shells.

export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
else
    export EDITOR="vim"
fi

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

if command -v manpath >/dev/null 2>&1; then
    MANPATH="$(unset MANPATH; manpath)"
    export MANPATH
fi

# Prevent path_helper from messing with the PATH when starting tmux.
#   See: https://superuser.com/a/583502
[ "$(uname -s)" == "Darwin" ] && { PATH=""; source /etc/profile; }

_prepend_path() {  # prepend $1 to var $2 avoiding duplicates using : as separator
    if [ -d "$1" ] && [ -n "$2" ]; then
        local _path="${!2}"                     # get path variable value
        case ":$_path:" in
            *":$1:"*) :;;                       # dir already in path, noop (:)
            *) _path="$1${_path:+:}$_path";;    # prepend (adding : if not empty)
        esac
        printf -v "$2" "%s" "$_path"            # write back to path variable
    fi
}

# Add custom bin dirs to PATH if they exist and are not already in PATH.
# Prepend custom man directories to MANPATH if they exist, so that we get
# correct man page entries when multiple versions of a command are
# available.
while read -r var dir; do _prepend_path "$dir" "$var"; done <<EOL
    PATH    $LOCAL_PREFIX/bin
    MANPATH $LOCAL_PREFIX/share/man
    PATH    $HOME/.local/bin
    MANPATH $HOME/.local/share/man
EOL
unset var dir _prepend_path

# This check has to be done after PATH manipulation above so we can find brew.
if command -v brew >/dev/null 2>&1; then
    LOCAL_PREFIX="$(brew --prefix)"
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

