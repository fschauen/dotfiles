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
if command -v brew &>/dev/null; then
    prefix=$(brew --prefix)
fi

# Prevent path_helper from messing with the PATH when starting tmux.
#   See: https://superuser.com/a/583502
if [ "$(uname)" == "Darwin" ]; then
    PATH=""
    source /etc/profile
fi

# Add custom bin dirs to PATH if they exist and are not already in PATH.
while read bindir; do
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
export MANPATH=$(MANPATH= manpath)
while read mandir; do
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

# Color definitions (from http://ethanschoonover.com/solarized)
# NAME  CODE               HEX         16/8 TERMCOL  XTERM/HEX    L*A*B       RGB          HSB
# ----  -----              ------      ---- -------  ----------- -----------  -----------  -----------
Base03="1;30"  Base03_RGB="002B36"   #  8/4 brblack  234 #1c1c1c  15 -12 -12    0  43  54  193 100  21
Base02="0;30"  Base02_RGB="073642"   #  0/4 black    235 #262626  20 -12 -12    7  54  66  192  90  26
Base01="1;32"  Base01_RGB="586E75"   # 10/7 brgreen  240 #585858  45 -07 -07   88 110 117  194  25  46
Base00="1;33"  Base00_RGB="657B83"   # 11/7 bryellow 241 #626262  50 -07 -07  101 123 131  195  23  51
Base0="1;34"   Base0_RGB="839496"    # 12/6 brblue   244 #808080  60 -06 -03  131 148 150  186  13  59
Base1="1;36"   Base1_RGB="93A1A1"    # 14/4 brcyan   245 #8a8a8a  65 -05 -02  147 161 161  180   9  63
Base2="0;37"   Base2_RGB="EEE8D5"    #  7/7 white    254 #e4e4e4  92 -00  10  238 232 213   44  11  93
Base3="1;37"   Base3_RGB="FDF6E3"    # 15/7 brwhite  230 #ffffd7  97  00  10  253 246 227   44  10  99
Yellow="0;33"  Yellow_RGB="B58900"   #  3/3 yellow   136 #af8700  60  10  65  181 137   0   45 100  71
Orange="1;31"  Orange_RGB="CB4B16"   #  9/3 brred    166 #d75f00  50  50  55  203  75  22   18  89  80
Red="0;31"     Red_RGB="DC322F"      #  1/1 red      160 #d70000  50  65  45  220  50  47    1  79  86
Magenta="0;35" Magenta_RGB="D33682"  #  5/5 magenta  125 #af005f  50  65 -05  211  54 130  331  74  83
Violet="1;35"  Violet_RGB="6C71C4"   # 13/5 brmagenta 61 #5f5faf  50  15 -45  108 113 196  237  45  77
Blue="0;34"    Blue_RGB="268BD2"     #  4/4 blue      33 #0087ff  55 -10 -45   38 139 210  205  82  82
Cyan="0;36"    Cyan_RGB="2AA198"     #  6/6 cyan      37 #00afaf  60 -35 -05   42 161 152  175  74  63
Green="0;32"   Green_RGB="859900"    #  2/2 green     64 #5f8700  60 -20  65  133 153   0   68 100  60

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=verbose
PS2="... "

PROMPT_COMMAND=bashrc_set_prompt
bashrc_set_prompt() {
    local exit_code=$? prompt=$(printf '\$%.0s' $(seq 1 $SHLVL)) pyvenv=""

    if ! [ -z "$VIRTUAL_ENV" ]; then
        pyvenv=" "$(basename "$VIRTUAL_ENV" 2>/dev/null)
    fi

    local stopped_jobs="" running_jobs=""
    local running=$(jobs -r | wc -l) stopped=$(jobs -s | wc -l)
    if [ ${running} -gt 0 ]; then running_jobs=" run:${running}"; fi
    if [ ${stopped} -gt 0 ]; then stopped_jobs=" stp:${stopped}"; fi

    local color="$Cyan"
    if [ $EUID -eq 0 ]; then                        # root user
        prompt=$(printf '#%.0s' $(seq 1 $SHLVL))
        color="$Orange"
    elif [ -n "$SSH_CLIENT" ]; then                 # SSH session
        color="$Yellow"
    fi

    local user_host_color="\[\033[${color}m\]"
    local pwd_color="\[\033[${Blue}m\]"
    local exit_code_color="\[\033[${Red}m\]"
    local git_color="\[\033[${Green}m\]"
    local env_color="\[\033[${Magenta}m\]"
    local running_color="\[\033[${Orange}m\]"
    local stopped_color="\[\033[${Orange}m\]"
    local default_color="\[\033[0m\]"

    PS1="\n["                               # [
    PS1+="$user_host_color\u@\h "           # user @ host
    PS1+="$pwd_color\w"                     # pwd
    PS1+="$git_color$(__git_ps1 ' %s')"     # git status (if in repo)
    PS1+="$env_color$pyvenv"                # python virtual env (if active)
    PS1+="$running_color$running_jobs"      # background running jobs (if any)
    PS1+="$stopped_color$stopped_jobs"      # background stopped jobs (if any)
    PS1+="$default_color"                   # back to default color
    PS1+="]\n"                              # ]
    if [[ $exit_code != 0 ]]; then
        PS1+="$exit_code_color$exit_code "  # last exit code if non-zero
        PS1+="$default_color"               # back to default color
    fi
    PS1+="$prompt "                       # prompt
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

alias light='bashrc_update_colors light'
alias dark='bashrc_update_colors dark'
bashrc_update_colors() {
    export BACKGROUND="$1"

    if [ -n "$TMUX" ] && [ -f "$HOME/.tmux.conf" ]; then
        tmux set-environment -g BACKGROUND "$BACKGROUND"
        tmux source-file "$HOME/.tmux.conf"
    fi

    # Terminal OSC (Operating System Commmand) definition
    local osc='\033]%s\033\\'
    if [ -n "$TMUX" ]; then                osc='\033Ptmux;\033\033]%s\007\033\\'
    elif [ ${TERM%%[-.]*} = screen ]; then osc='\033P\033]%s\007\033\\'
    fi

    # Solarize the terminal: 4;n;#rrggbb
    local n rgb comment
    while read n rgb comment; do printf "$osc" "4;$n;#$rgb"; done <<EOS
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
EOS

    local fg=$Base1_RGB bg=$Base03_RGB cursor=$Red_RGB
    if [ $BACKGROUND = light ]; then fg=$Base01_RGB; bg=$Base3_RGB; fi

    if [ -n "$ITERM_SESSION_ID" ]; then # iTerm2: Pnrrggbb
        while read n rgb comment; do printf "$osc" "P$n$rgb"; done <<EOS
            g $fg           Foreground
            i $fg           Bold
            h $bg           Background
            j $Base01_RGB   Selection
            k $Base2_RGB    Selected text
            l $cursor       Cursor
            m $cursor       Cursor text
EOS
    else  # other terminals: n;#rrggbb
        while read n rgb comment; do printf "$osc" "$n;#$rgb"; done <<EOS
            10 $fg      Foreground
            11 $bg      Background
            12 $cursor  Cursor
EOS
    fi

    local ls_colors="$HOME/.config/dircolors/solarized-$BACKGROUND"
    if type dircolors &>/dev/null && [ -f $ls_colors ]; then
        eval "$(dircolors $ls_colors)"
    fi
}

##############################################################################
# Add shell functions
##############################################################################

tree() { command tree --dirsfirst -FI '.git|Spotlight-V100|.fseventsd' "$@"; }

ltree() { tree -C "$@" | less -R; }

# Combined mkdir and cd
mkcd() { mkdir -p -- "$1" && cd -P -- "$1"; }

# Colorized `man`
man() {
    local standout="$Base02;44" bold="$Yellow" underline="$Base3;4"
    if [ $BACKGROUND = light ]; then
        standout="$Base02;46" bold="$Blue" underline="$Base00;4"
    fi

    LESS_TERMCAP_so=$(echo -ne "\033[${standout}m") \
    LESS_TERMCAP_md=$(echo -ne "\033[${bold}m") \
    LESS_TERMCAP_us=$(echo -ne "\033[${underline}m") \
    LESS_TERMCAP_se=$'\033[0m' \
    LESS_TERMCAP_me=$'\033[0m' \
    LESS_TERMCAP_ue=$'\033[0m' \
    GROFF_NO_SGR=1 \
    command man "$@"
}

solarized() {
    local names=(Base02 Red Green Yellow Blue Magenta Cyan Base2
                 Base03 Orange Base01 Base00 Base0 Violet Base1 Base3)
    local i
    for i in 1 9 3 2 6 4 13 5 8 0 10 11 12 14 7 15; do
        local name=${names[i]}
        local name_rgb=${name}_RGB
        local code=${!name} rgb=${!name_rgb}
        echo -e "\x1b[48;5;${i}m    \033[0m \033[${code}m#$rgb $code $name ($i)"
    done
}

# Print all 256 colors
colortest() {
    local i
    for i in $(seq 0 15); do
        for j in $(seq 0 15); do
            local n=$(( 16 * $i + $j ))
            printf "\x1b[48;5;${n}m  %3d  \033[0m" $n
        done
        printf '\n'
    done
    printf '\033[0m'
}

##############################################################################
# Run external cusomizations
##############################################################################

stty -ixon # disable ctrl-s and ctrl-q
bashrc_update_colors "${BACKGROUND:-dark}"

# Enable available completion helpers
if [ -d /usr/local/etc/bash_completion.d ]; then
    for completion in /usr/local/etc/bash_completion.d/*; do
        source "$completion"
    done
    unset completion
fi

# Source a local bashrc if available
if [ -f "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
fi

