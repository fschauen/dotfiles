# Return immediately if non-interactive (makes FTP clients happy)
[[ "$-" == *i* ]] || return

##############################################################################
# Customize environment
##############################################################################

export EDITOR="vim"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US"
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LESS="-i -j.49 -M -R -z-2"
export LESSHISTFILE=/dev/null
export PAGER=less

# Find out where Homebrew performs installations. If Homebrew is not
# installed (e.g. running on Linux), assume /usr/local for our
# installations.
prefix=/usr/local
if command -v brew &>/dev/null; then prefix=$(brew --prefix); fi

# Prevent path_helper from messing with the PATH when starting tmux.
#   See: https://superuser.com/a/583502
if [ "$(uname)" == "Darwin" ]; then
    # shellcheck disable=SC2123 # intentionally clearing the PATH here
    PATH=""
    # shellcheck disable=SC1091 # /etc/profile is part of macOS
    source /etc/profile
fi

# Add custom bin dirs to PATH if they exist and are not already in PATH.
while read -r bindir; do
    if [ -d "$bindir" ] && [[ ":$PATH:" != *":$bindir:"* ]]; then
        PATH="$bindir:$PATH"
    fi
done <<EOS
    $prefix/bin
    $prefix/opt/man-db/libexec/bin
    $prefix/opt/coreutils/libexec/gnubin
    $prefix/opt/gnu-sed/libexec/gnubin
    $HOME/.local/bin
    $HOME/bin
EOS

# Prepend custom man directories to MANPATH if they exist, so that we get
# correct man page entries when multiple versions of a command are
# available.
export MANPATH
MANPATH=$(MANPATH='' manpath)
while read -r mandir; do
    if [ -d "$mandir" ] && [[ ":$MANPATH:" != *":$mandir:"* ]]; then
        MANPATH="$mandir:$MANPATH"
    fi
done <<EOS
    $prefix/share/man
    $prefix/opt/man-db/libexec/man
    $prefix/opt/coreutils/libexec/gnuman
    $prefix/opt/gnu-sed/libexec/gnuman
    $HOME/.local/share/man
EOS

unset prefix bindir mandir

##############################################################################
# Customize shell options & variables
##############################################################################

shopt -s cdspell checkwinsize globstar histappend nocaseglob
set -o noclobber    # Prevent overwriting files with output redirection.

# Eternal bash history (from https://stackoverflow.com/a/19533853)
HISTCONTROL=erasedups
HISTFILESIZE=
HISTSIZE=
HISTTIMEFORMAT="[%F %T] "
HISTFILE=~/.bash_eternal_history

# shellcheck disable=SC2034 # these variable are meant for use in shell only
{
    # Color definitions (from http://ethanschoonover.com/solarized)
    # NAME                RGB HEX    SGR  ANSI TERMCOL  XTERM/HEX    L*A*B       RGB          HSB
    # ----                -------    ---  ---- -------  ----------- -----------  -----------  -----------
    Base03=8  Base03_RGB="002B36"  # 1;30   8  brblack  234 #1c1c1c  15 -12 -12    0  43  54  193 100  21
    Base02=0  Base02_RGB="073642"  # 0;30   0  black    235 #262626  20 -12 -12    7  54  66  192  90  26
    Base01=10 Base01_RGB="586E75"  # 1;32  10  brgreen  240 #585858  45 -07 -07   88 110 117  194  25  46
    Base00=11 Base00_RGB="657B83"  # 1;33  11  bryellow 241 #626262  50 -07 -07  101 123 131  195  23  51
    Base0=12  Base0_RGB="839496"   # 1;34  12  brblue   244 #808080  60 -06 -03  131 148 150  186  13  59
    Base1=14  Base1_RGB="93A1A1"   # 1;36  14  brcyan   245 #8a8a8a  65 -05 -02  147 161 161  180   9  63
    Base2=7   Base2_RGB="EEE8D5"   # 0;37   7  white    254 #e4e4e4  92 -00  10  238 232 213   44  11  93
    Base3=15  Base3_RGB="FDF6E3"   # 1;37  15  brwhite  230 #ffffd7  97  00  10  253 246 227   44  10  99
    Yellow=3  Yellow_RGB="B58900"  # 0;33   3  yellow   136 #af8700  60  10  65  181 137   0   45 100  71
    Orange=9  Orange_RGB="CB4B16"  # 1;31   9  brred    166 #d75f00  50  50  55  203  75  22   18  89  80
    Red=1     Red_RGB="DC322F"     # 0;31   1  red      160 #d70000  50  65  45  220  50  47    1  79  86
    Magenta=5 Magenta_RGB="D33682" # 0;35   5  magenta  125 #af005f  50  65 -05  211  54 130  331  74  83
    Violet=13 Violet_RGB="6C71C4"  # 1;35  13  brmagenta 61 #5f5faf  50  15 -45  108 113 196  237  45  77
    Blue=4    Blue_RGB="268BD2"    # 0;34   4  blue      33 #0087ff  55 -10 -45   38 139 210  205  82  82
    Cyan=6    Cyan_RGB="2AA198"    # 0;36   6  cyan      37 #00afaf  60 -35 -05   42 161 152  175  74  63
    Green=2   Green_RGB="859900"   # 0;32   2  green     64 #5f8700  60 -20  65  133 153   0   68 100  60

    PS1_DEFAULT=$(tput setaf $Cyan)     # user@host color for local sessions
    PS1_SSH=$(tput setaf $Yellow)       # user@host color in SSH session
    PS1_ROOT=$(tput setaf $Orange)      # user@host color if logged in as root
    PS1_PWD=$(tput setaf $Blue)         # PWD color
    PS1_ERR=$(tput setaf $Red)          # color for last exit code if non-zero
    PS1_GIT=$(tput setaf $Green)        # color for git branch
    PS1_VENV=$(tput setaf $Violet)      # color for python virtual env
    PS1_JOBS=$(tput setaf $Magenta)     # color for background jobs
    PS1_RST=$(tput sgr0)

    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWUPSTREAM=verbose
}

PS2="... "

PROMPT_COMMAND=__ps1_set

__ps1_set() {
    local last_status=$?
    local prompt color sep_color sep

    if [ $EUID -eq 0 ]; then
        prompt=$(printf '#%.0s' $(seq 1 $SHLVL))
        color=$PS1_ROOT
    else
        prompt=$(printf '\$%.0s' $(seq 1 $SHLVL))
        if [ -n "$SSH_CLIENT" ]; then
            color=$PS1_SSH
        else
            color=$PS1_DEFAULT
        fi
    fi

    if [ "$BACKGROUND" = "light" ]; then
        sep_color=$(tput setaf $Base1)
    else
        sep_color=$(tput setaf $Base01)
    fi
    sep="$sep_color > $PS1_RST"

    PS1="\n"
    if [ $last_status -ne 0 ]; then
        PS1+="$PS1_ERR$last_status$PS1_RST$sep"     # last exit code (in non-zero)
    fi
    PS1+="$color\h$PS1_RST$sep$PS1_PWD\w$PS1_RST"   # user@host pwd
    PS1+=$(__git_ps1 "$sep$PS1_GIT%s$PS1_RST")      # git status (if in repo)
    PS1+=$(__ps1_venv "$sep$PS1_VENV(%s)$PS1_RST")  # python virtual env (if active)
    PS1+=$(__ps1_jobs "$sep$PS1_JOBS%s$PS1_RST")    # background jobs (if any)
    PS1+="\n$prompt "                               # ] $
}

__ps1_venv() {
    local venv
    venv="$(basename "$VIRTUAL_ENV" 2>/dev/null)"
    # shellcheck disable=SC2059 # variable format string is really needed here
    [ -n "$venv" ] && printf "${1:-%s}" "$venv"
}

__ps1_jobs() {
    local n
    n=$(jobs | wc -l)
    # shellcheck disable=SC2059 # variable format string is really needed here
    [ "$n" -gt 0 ] && printf "${1:-%s}" "$n job$([ "$n" -gt 1 ] && echo -n s)"
}

##############################################################################
# Customize shell aliases
##############################################################################

# Make `ls` group directories first if supported.
if ls --group-directories-first &>/dev/null; then
    alias ls="ls -hF --group-directories-first --color=auto"    # GNU
else
    alias ls="ls -hF -G"                                        # BSD
fi

# Force `ls` to use color output (e.g. for piping into `less`).
if ls --color=auto &>/dev/null; then
    alias lsc="ls --color=always"                               # GNU
else
    alias lsc="/usr/bin/env CLICOLOR_FORCE=1 ls"                # BSD
fi

alias la="ls -a"
alias ll="ls -l"
alias llc="lsc -l"
alias lla="ls -la"
alias llac="lsc -la"

alias grep="grep --color=auto";
alias egrep="egrep --color=auto";
alias fgrep="fgrep --color=auto";
alias path='echo $PATH | tr -s ":" "\n"'
alias mpath='echo $MANPATH | tr -s ":" "\n"'
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# A few options to get public IP address on command line. The dig solution
# below using the OpenDNS resolver doesn't work when connected to
# ExpressVPN because all DNS requests are handled by the ExpressVPN DNS
# servers and the OpenDNS DNS resolver is blocked.
alias myip="curl https://ifconfig.co"
#alias myip="curl https://ifconfig.me"
#alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

alias light='_update_colors light'
alias dark='_update_colors dark'

_send_osc() {
    local OSC ST
    if [ -n "$TMUX" ]; then
        OSC=$'\ePtmux;\e\e]'
        ST=$'\e\e\\\e\\';
    else
        OSC=$'\e]'
        ST=$'\e\\'
    fi
    echo -n "$OSC$1$ST"
}

_update_colors() {
    local cursor fg bg n rgb

    export BACKGROUND="$1"

    cursor=$Red_RGB
    if [ "$BACKGROUND" = "light" ]; then
        fg=$Base01_RGB
        bg=$Base3_RGB
    else
        fg=$Base1_RGB
        bg=$Base03_RGB
    fi

    if [ -n "$ITERM_SESSION_ID" ]; then # iTerm2
        while read -r n rgb; do _send_osc "P$n$rgb"; done <<EOL
            0 $Base02_RGB
            1 $Red_RGB
            2 $Green_RGB
            3 $Yellow_RGB
            4 $Blue_RGB
            5 $Magenta_RGB
            6 $Cyan_RGB
            7 $Base2_RGB
            8 $Base03_RGB
            9 $Orange_RGB
            a $Base01_RGB
            b $Base00_RGB
            c $Base0_RGB
            d $Violet_RGB
            e $Base1_RGB
            f $Base3_RGB
            g $fg
            h $bg
            i $fg
            j $Base01_RGB
            k $Base2_RGB
            l $cursor
            m $cursor
EOL
    else # assume xterm
        while read -r n rgb; do _send_osc "4;$n;#$rgb"; done <<EOL
            0  $Base02_RGB
            1  $Red_RGB
            2  $Green_RGB
            3  $Yellow_RGB
            4  $Blue_RGB
            5  $Magenta_RGB
            6  $Cyan_RGB
            7  $Base2_RGB
            8  $Base03_RGB
            9  $Orange_RGB
            10 $Base01_RGB
            11 $Base00_RGB
            12 $Base0_RGB
            13 $Violet_RGB
            14 $Base1_RGB
            15 $Base3_RGB
EOL
        while read -r n rgb; do _send_osc "$n;#$rgb"; done <<EOL
            10 $fg
            11 $bg
            12 $cursor
EOL
    fi

    if [ -n "$TMUX" ] && [ -f "$HOME/.tmux.conf" ]; then
        tmux set-environment -g BACKGROUND "$BACKGROUND"
        tmux source-file "$HOME/.tmux.conf"
    fi

    local ls_colors="$HOME/.config/dircolors/solarized-$BACKGROUND"
    if type dircolors &>/dev/null && [ -f "$ls_colors" ]; then
        eval "$(dircolors "$ls_colors")"
    fi
}

##############################################################################
# Add shell functions
##############################################################################

tree() { command tree --dirsfirst -FI '.git|Spotlight-V100|.fseventsd' "$@"; }

ltree() { tree -C "$@" | less -R; }

# Combined mkdir and cd
mkcd() { mkdir -p -- "$1" && cd -P -- "$1" || return; }

# Colorized `man`
man() {
    local rst standout bold underline

    rst=$(tput sgr0)
    if [ "$BACKGROUND" = "light" ]; then
        standout=$(tput -S      <<<"$(echo -e "setaf $Base3\nsetab $Cyan")")
        bold=$(tput -S          <<<"$(echo -e "setaf $Blue")")
        underline=$(tput -S     <<<"$(echo -e "setaf $Base02\nsmul")")
    else
        standout=$(tput -S      <<<"$(echo -e "setaf $Base03\nsetab $Cyan")")
        bold=$(tput -S          <<<"$(echo -e "setaf $Yellow")")
        underline=$(tput -S     <<<"$(echo -e "setaf $Base3\nsmul")")
    fi

    LESS_TERMCAP_so=$standout   \
    LESS_TERMCAP_md=$bold       \
    LESS_TERMCAP_us=$underline  \
    LESS_TERMCAP_se=$rst        \
    LESS_TERMCAP_me=$rst        \
    LESS_TERMCAP_ue=$rst        \
    GROFF_NO_SGR=1              \
    command man "$@"
}

solarized() {
    local rst name name_rgb rgb fg bg

    rst=$(tput sgr0)
    for name in Red Orange Yellow Green Cyan Blue Violet Magenta Base{0{3..0},{0..3}}
    do
        name_rgb=${name}_RGB
        i=
        rgb=${!name_rgb}
        fg=$(tput setaf "${!name}")
        bg=$(tput setab  "${!name}")
        printf "$bg%6s$rst $fg#$rgb %2d $name$rst\n" ''  "${!name}"
    done
}

# Print all 256 colors
colortest() {
    local i j rst
    rst=$(tput sgr0)
    for i in $(seq 0 15); do
        for j in $(seq 0 15); do
            local n=$(( 16 * i + j ))
            printf "$(tput setab $n)  %3d  " $n
        done
        echo "$rst"
    done
}

##############################################################################
# Run external cusomizations
##############################################################################

stty -ixon # disable ctrl-s and ctrl-q
_update_colors "${BACKGROUND:-dark}"

# Enable available completion helpers
if [ -d /usr/local/etc/bash_completion.d ]; then
    for completion in /usr/local/etc/bash_completion.d/*; do
        # shellcheck disable=SC1090
        source "$completion"
    done
    unset completion
fi

# Source a local bashrc if available
if [ -f "$HOME/.bashrc.local" ]; then
    # shellcheck disable=SC1090
    source "$HOME/.bashrc.local"
fi

