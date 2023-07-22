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
have tput && [ -n "$TERM" ] && {
      reset="$(printf %b '\e[0m')"
      bold='\e[1m'      faint='\e[2m'      italic='\e[3m'     underline='\e[4m'
      black='\e[30m'   brblack='\e[90m'   black_bg='\e[40m'   brblack_bg='\e[100m'
        red='\e[31m'     brred='\e[91m'     red_bg='\e[41m'     brred_bg='\e[101m'
      green='\e[32m'   brgreen='\e[92m'   green_bg='\e[42m'   brgreen_bg='\e[102m'
     yellow='\e[33m'  bryellow='\e[93m'  yellow_bg='\e[43m'  bryellow_bg='\e[103m'
       blue='\e[34m'    brblue='\e[94m'    blue_bg='\e[44m'    brblue_bg='\e[104m'
    magenta='\e[35m' brmagenta='\e[95m' magenta_bg='\e[45m' brmagenta_bg='\e[105m'
       cyan='\e[36m'    brcyan='\e[96m'    cyan_bg='\e[46m'    brcyan_bg='\e[106m'
      white='\e[37m'   brwhite='\e[97m'   white_bg='\e[47m'   brwhite_bg='\e[107m'

    export LESS_TERMCAP_md="$(printf %b $blue)"             # bold
    export LESS_TERMCAP_mb="$LESS_TERMCAP_md"               # blink
    export LESS_TERMCAP_me="$reset"
    export LESS_TERMCAP_us="$(printf %b $brblue $italic $underline)"   # underline
    export LESS_TERMCAP_ue="$reset"
    export LESS_TERMCAP_so="$(printf %b $black $yellow_bg $bold)"  # search
    export LESS_TERMCAP_se="$reset"
    export GROFF_NO_SGR=1

    unset bold    faint     italic     underline  reset
    unset black   brblack   black_bg   brblack_bg
    unset red     brred     red_bg     brred_bg
    unset green   brgreen   green_bg   brgreen_bg
    unset yellow  bryellow  yellow_bg  bryellow_bg
    unset blue    brblue    blue_bg    brblue_bg
    unset magenta brmagenta magenta_bg brmagenta_bg
    unset cyan    brcyan    cyan_bg    brcyan_bg
    unset white   brwhite   white_bg   brwhite_bg
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

