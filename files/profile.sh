#!/bin/sh
# Environment variables are set here for login shells.

# From: https://ethanschoonover.com/solarized/
# SOLARIZED HEX     16/8 TERMCOL  XTERM/HEX   L*A*B      RGB         HSB
# --------- ------- ---- -------  ----------- ---------- ----------- -----------
# base03    #002b36  8/4 brblack  234 #1c1c1c 15 -12 -12   0  43  54 193 100  21
# base02    #073642  0/4 black    235 #262626 20 -12 -12   7  54  66 192  90  26
# base01    #586e75 10/7 brgreen  240 #585858 45 -07 -07  88 110 117 194  25  46
# base00    #657b83 11/7 bryellow 241 #626262 50 -07 -07 101 123 131 195  23  51
# base0     #839496 12/6 brblue   244 #808080 60 -06 -03 131 148 150 186  13  59
# base1     #93a1a1 14/4 brcyan   245 #8a8a8a 65 -05 -02 147 161 161 180   9  63
# base2     #eee8d5  7/7 white    254 #e4e4e4 92 -00  10 238 232 213  44  11  93
# base3     #fdf6e3 15/7 brwhite  230 #ffffd7 97  00  10 253 246 227  44  10  99
# yellow    #b58900  3/3 yellow   136 #af8700 60  10  65 181 137   0  45 100  71
# orange    #cb4b16  9/3 brred    166 #d75f00 50  50  55 203  75  22  18  89  80
# red       #dc322f  1/1 red      160 #d70000 50  65  45 220  50  47   1  79  86
# magenta   #d33682  5/5 magenta  125 #af005f 50  65 -05 211  54 130 331  74  83
# violet    #6c71c4 13/5 brmagenta 61 #5f5faf 50  15 -45 108 113 196 237  45  77
# blue      #268bd2  4/4 blue      33 #0087ff 55 -10 -45  38 139 210 205  82  82
# cyan      #2aa198  6/6 cyan      37 #00afaf 60 -35 -05  42 161 152 175  74  63
# green     #859900  2/2 green     64 #5f8700 60 -20  65 133 153   0  68 100  60
#                    ^
#                    |
#                    +--- set colors according to this column, assuming a
#                         properly configured terminal.
#
# Don't export these into the environment -> the point is to have them
# available within the shell only.
Base03=8
Base02=0
Base01=10
Base00=11
Base0=12
Base1=14
Base2=7
Base3=15
Red=1
Orange=9
Yellow=3
Green=2
Cyan=6
Blue=4
Violet=13
Magenta=5
Reset=$(tput sgr0)

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
export LESS_TERMCAP_so="$(printf '%s\n' "setaf $Base03" "setab $Cyan" | tput -S)"
export LESS_TERMCAP_md="$(printf '%s\n' "setaf $Yellow" | tput -S)"
export LESS_TERMCAP_us="$(printf '%s\n' "setaf $Base3" 'smul' | tput -S)"
export LESS_TERMCAP_se="$Reset"
export LESS_TERMCAP_me="$Reset"
export LESS_TERMCAP_ue="$Reset"
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
[ command -v manpath >/dev/null 2>&1 ] && MANPATH="$(unset MANPATH; manpath)"
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

