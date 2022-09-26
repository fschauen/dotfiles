#!/bin/sh
# Environment variables are set here for login shells.

# Keep things organized.
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# General environment settings.
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LESS="-i -j.49 -M -R -z-2"
export LESSHISTFILE="$XDG_DATA_HOME/less/history"
export LESSHISTSIZE=1000
export LOCAL_PREFIX="/usr/local"
export PAGER=less
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Make man pages pretty, but only if $TERM is set because otherwise `tput`
# would report errors (e.g., when running a command via SSH without allocating
# a pty $TERM is not set).
[ -n "$TERM" ] && {
    rst="$(tput sgr0)"
    export LESS_TERMCAP_md="$(printf '%s\n' 'setaf 3' | tput -S)"
    export LESS_TERMCAP_mb="$LESS_TERMCAP_md"
    export LESS_TERMCAP_me="$rst"
    export LESS_TERMCAP_us="$(printf '%s\n' 'setaf 7' 'smul' | tput -S)"
    export LESS_TERMCAP_ue="$rst"
    export LESS_TERMCAP_so="$(printf '%s\n' 'setaf 4' 'setab 0' | tput -S)"
    export LESS_TERMCAP_se="$rst"
    export GROFF_NO_SGR=1
    unset rst
}

# Add custom directories to PATH and MANPATH.
#
# On MacOS, we skip it here because these relevant files are sourced in order
# by zsh on startup ($ZDOTDIR defaults to $HOME if not set):
#
#   $ZDOTDIR/.zshenv     <-- This file.
#   /etc/zprofile        <-- On MacOS this sources /usr/libexec/path_helper,
#                            which would undo what we do here.
#   $ZDOTDIR/.zshrc      <-- So we defer our PATH manipulation to this file.
#
[ "$(uname -s)" = "Darwin" ] || source "$XDG_CONFIG_HOME/shell/path.sh"

# Set $DISPLAY if running in WSL
#
# How to configure Windows Firewall for Xserver: https://skeptric.com/wsl2-xserver/
# How to check if running in WSL: https://stackoverflow.com/a/61014411
if [ $(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/ip') ]; then
  export DISPLAY=$(awk '/nameserver/ {print $2; exit}' /etc/resolv.conf 2>/dev/null):0.0
  export LIBGL_ALWAYS_INDIRECT=1
fi

