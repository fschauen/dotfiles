# General environment settings.
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export LESS="-i -j.49 -M -R -z-2"
export LESSHISTFILE="$XDG_DATA_HOME/less/history"
export LESSHISTSIZE=1000
export LOCAL_PREFIX="/usr/local"
export PAGER=less
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

# Make man pages pretty, but only if $TERM is set because otherwise `tput`
# would report errors (e.g., when running a command via SSH without allocating
# a pty $TERM is not set).
[ -n "$TERM" ] && {
    rst="$(tput sgr0)"
    LESS_TERMCAP_md="$(printf '%s\n' 'setaf 3' | tput -S)"
    LESS_TERMCAP_mb="$LESS_TERMCAP_md"
    LESS_TERMCAP_me="$rst"
    LESS_TERMCAP_us="$(printf '%s\n' 'setaf 7' 'smul' | tput -S)"
    LESS_TERMCAP_ue="$rst"
    LESS_TERMCAP_so="$(printf '%s\n' 'setaf 4' 'setab 0' | tput -S)"
    LESS_TERMCAP_se="$rst"
    export LESS_TERMCAP_md LESS_TERMCAP_mb LESS_TERMCAP_me
    export LESS_TERMCAP_us LESS_TERMCAP_ue LESS_TERMCAP_so LESS_TERMCAP_se
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
  [ -d "$dir" ] || continue # skip if directory doesn't exist
  case ":${PATH:=$dir}:" in
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
EOL
export PATH

# Prepend custom man directories to MANPATH if they exist, so that we get
# correct man page entries when multiple versions of a command are
# available.
command -v manpath >/dev/null 2>&1 && MANPATH="$(unset MANPATH; manpath)"
while read -r dir; do
  [ -d "$dir" ] || continue # skip if directory doesn't exist
  case ":${MANPATH:=$dir}:" in
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

if command -v nvim >/dev/null 2>&1; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

if command -v brew >/dev/null 2>&1; then
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_AUTO_UPDATE=1
fi

# Set $DISPLAY if running in WSL and an Xserver is reachable
#
# How to configure Windows Firewall for Xserver: https://skeptric.com/wsl2-xserver/
# How to check if running in WSL: https://stackoverflow.com/a/61014411
if [ -n "$(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/ip')" ]; then
  xdisplay="$(awk '/nameserver/ {print $2; exit}' /etc/resolv.conf 2>/dev/null):0.0"
  if command -v xset >/dev/null 2>&1; then
    if DISPLAY="$xdisplay" timeout '0.2s' xset q >/dev/null 2>&1; then
      export DISPLAY="$xdisplay"
      export LIBGL_ALWAYS_INDIRECT=1
    fi
  fi
  unset xdisplay
fi

