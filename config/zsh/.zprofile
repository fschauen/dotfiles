# General environment settings.
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

export LANG="en_US.UTF-8"
export LANGUAGE="en_US"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_COLLATE="C"

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export LESS="-i -j.49 -M -R -z-2"
export LESSHISTFILE="$XDG_DATA_HOME/less/history"
export LESSHISTSIZE=1000
export LOCAL_PREFIX="/usr/local"
export PAGER=less
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

have() {
  command -v "$1" >/dev/null 2>&1
}

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
  [ -d "$dir" ] && case ":${PATH:=$dir}:" in
    *:"$dir":*) ;;          # already in PATH -> ignore
    *) PATH="$dir:$PATH" ;; # not yet in PATH -> prepend it
  esac
done <<EOL
  $LOCAL_PREFIX/bin
  $LOCAL_PREFIX/opt/curl/bin
  $LOCAL_PREFIX/opt/make/libexec/gnubin
  $LOCAL_PREFIX/opt/findutils/libexec/gnubin
  $LOCAL_PREFIX/opt/gnu-sed/libexec/gnubin
  $LOCAL_PREFIX/opt/gnu-tar/libexec/gnubin
  $LOCAL_PREFIX/opt/coreutils/libexec/gnubin
  $HOME/.local/bin
  $HOME/.bin
EOL
export PATH

# Prepend custom man directories to MANPATH if they exist, so that we get
# correct man page entries when multiple versions of a command are
# available.
have manpath && MANPATH="$(unset MANPATH; manpath)"
while read -r dir; do
  [ -d "$dir" ] && case ":${MANPATH:=$dir}:" in
    *:"$dir":*) ;;                # already in MANPATH -> ignore
    *) MANPATH="$dir:$MANPATH" ;; # not yet in MANPATH -> prepend it
  esac
done <<EOL
  $LOCAL_PREFIX/share/man
  $LOCAL_PREFIX/opt/curl/share/man
  $LOCAL_PREFIX/opt/make/libexec/gnuman
  $LOCAL_PREFIX/opt/findutils/libexec/gnuman
  $LOCAL_PREFIX/opt/gnu-sed/libexec/gnuman
  $LOCAL_PREFIX/opt/gnu-tar/libexec/gnuman
  $LOCAL_PREFIX/opt/coreutils/libexec/gnuman
  $HOME/.local/share/man
EOL
export MANPATH

unset dir

# These checks have to be done after PATH manipulation above so we can find
# installed programs if they are in the added paths.

have nvim && EDITOR="nvim"
[ -z $EDITOR ] && have vim && EDITOR="vim"
[ -z $EDITOR ] && have vi && EDITOR="vi"
[ -n $EDITOR ] && export EDITOR

have brew && {
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_AUTO_UPDATE=1
}

# Set $DISPLAY if running in WSL and an Xserver is reachable
#
# How to configure Windows Firewall for Xserver: https://skeptric.com/wsl2-xserver/
# How to check if running in WSL: https://stackoverflow.com/a/61014411
if [ -n "$(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/ip')" ]; then
  xdisplay="$(awk '/nameserver/ {print $2; exit}' /etc/resolv.conf 2>/dev/null):0.0"
  have xset && if DISPLAY="$xdisplay" timeout '0.2s' xset q >/dev/null 2>&1; then
    export DISPLAY="$xdisplay"
    export LIBGL_ALWAYS_INDIRECT=1
  fi
  unset xdisplay
fi

