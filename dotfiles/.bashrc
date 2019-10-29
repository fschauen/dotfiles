# Return immediately if non-interactive (makes FTP clients happy)
[[ "$-" == *i* ]] || return

bashrc_customize_environment() {
    [ -z "$BACKGROUND" ] && export BACKGROUND="dark"
    export EDITOR="vim"
    export LANG="en_US.UTF-8"
    export LANGUAGE="en_US"
    export LC_CTYPE="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    export LESS="-i -j.49 -M -R -z-2"
    export LESSHISTFILE=/dev/null
    export PAGER=less

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
}

bashrc_customize_shell_options() {
    # Prevent overwriting files by mistake with output redirection.
    set -o noclobber

    local option
    for option in cdspell checkwinsize globstar histappend nocaseglob
    do
        shopt -s "$option" 2> /dev/null
    done
}

bashrc_customize_paths() {
    # Find out where Homebrew performs installations. If Homebrew is not
    # installed (e.g. running on Linux), assume /usr/local for our
    # installations.
    local prefix=/usr/local
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
    local p
    while read p; do
        if [ -d "$p" ] && [[ ":$PATH:" != *":$p:"* ]]; then
            PATH="$p:$PATH"
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
    while read p; do
        if [ -d "$p" ] && [[ ":$MANPATH:" != *":$p:"* ]]; then
            MANPATH="$p:$MANPATH"
        fi
    done <<EOS
        $prefix/share/man
        $prefix/opt/man-db/libexec/man
        $prefix/opt/coreutils/libexec/gnuman
        $prefix/opt/gnu-sed/libexec/gnuman
        $HOME/.local/share/man
EOS
}

bashrc_update_colors() {
    export BACKGROUND="$1"
    if [ -n "$TMUX" ] && [ -f "$HOME/.tmux.conf" ]; then
        tmux set-environment -g BACKGROUND "$BACKGROUND"
        tmux source-file "$HOME/.tmux.conf"
    fi
    bashrc_customize_terminal_colors
    bashrc_customize_prompt
    bashrc_customize_ls
}

bashrc_customize_aliases() {
    alias light='bashrc_update_colors "light"'
    alias dark='bashrc_update_colors "dark"'

    # Make `ls` group directories first if supported.
    if ls --group-directories-first >/dev/null 2>&1; then
        alias ls="ls -hF --group-directories-first --color=auto"    # GNU
    else
        alias ls="ls -hF -G"                                        # BSD
    fi

    # Force `ls` to use color output (e.g. for piping into `less`).
    if ls --color=auto >/dev/null 2>&1; then
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

    # A few options to get public IP address on command line. The dig solution
    # below using the OpenDNS resolver doesn't work when connected to
    # ExpressVPN because all DNS requests are handled by the ExpressVPN DNS
    # servers and the OpenDNS DNS resolver is blocked.
    alias myip="curl https://ifconfig.co"
    #alias myip="curl https://ifconfig.me"
    #alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

    alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'
    alias tree="bashrc_tree"
    alias ltree="bashrc_paged_tree"
}

bashrc_tree() {
    # The 'tree' alias is not available here, so this calls the actual program.
    tree -F --dirsfirst -I '.git|Spotlight-V100|.fseventsd' "$@"
}

bashrc_paged_tree() {
    bashrc_tree -C "$@" | less -R
}

bashrc_customize_terminal_colors() {
    # Format string for sending an OSC (Operating System Commmand) to the terminal.
    if [ -n "$TMUX" ]; then
        # http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324
        local format='\033Ptmux;\033\033]%s\007\033\\'
        # local format='\033Ptmux;\033\033]%s\033\033\\\033\\'
    elif [ "${TERM%%[-.]*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        local format='\033P\033]%s\007\033\\'
    else
        local format='\033]%s\033\\'
    fi

    # Solarize the terminal:
    #   - 4;n;#rrggbb (e.g. https://github.com/mintty/mintty/wiki/Tips#changing-colours)
    printf "$format" "4;0;#$Base02_RGB"
    printf "$format" "4;1;#$Red_RGB"
    printf "$format" "4;2;#$Green_RGB"
    printf "$format" "4;3;#$Yellow_RGB"
    printf "$format" "4;4;#$Blue_RGB"
    printf "$format" "4;5;#$Magenta_RGB"
    printf "$format" "4;6;#$Cyan_RGB"
    printf "$format" "4;7;#$Base2_RGB"
    printf "$format" "4;8;#$Base03_RGB"
    printf "$format" "4;9;#$Orange_RGB"
    printf "$format" "4;10;#$Base01_RGB"
    printf "$format" "4;11;#$Base00_RGB"
    printf "$format" "4;12;#$Base0_RGB"
    printf "$format" "4;13;#$Violet_RGB"
    printf "$format" "4;14;#$Base1_RGB"
    printf "$format" "4;15;#$Base3_RGB"

    if [ "$BACKGROUND" = "dark" ]; then
        local background="$Base03_RGB"
        local foreground="$Base1_RGB"
    else
        local background="$Base3_RGB"
        local foreground="$Base01_RGB"
    fi

    if [ -n "$ITERM_SESSION_ID" ]; then
        # iTerm2: Pnrrggbb (http://iterm2.com/documentation-escape-codes.html)
        printf "$format" "Pg$foreground"    # Foreground
        printf "$format" "Pi$foreground"    # Bold
        printf "$format" "Ph$background"    # Background
        printf "$format" "Pj$Base01_RGB"    # Selection
        printf "$format" "Pk$Base2_RGB"     # Selected text
        printf "$format" "Pl$Red_RGB"       # Cursor
        printf "$format" "Pm$Red_RGB"       # Cursor text
    else
        printf "$format" "10;#$foreground"  # Foreground
        printf "$format" "11;#$background"  # Background
        printf "$format" "12;#$Red_RGB"     # Cursor
    fi
}

bashrc_set_prompt() {
    local exit_code=$?
    local level=$SHLVL
    local prompt=$(printf '\$%.0s' $(seq 1 $level))

    local pyvenv=""
    if ! [ -z "$VIRTUAL_ENV" ]; then
        pyvenv=$(basename "$VIRTUAL_ENV" 2>/dev/null)
    fi

    local color="$Cyan"
    if [ $EUID -eq 0 ]; then
        # root user
        prompt=$(printf '#%.0s' $(seq 1 $level))
        color="$Orange"
    elif [ -n "$SSH_CLIENT" ]; then
        # SSH connection
        color="$Yellow"
    fi

    local user_host_color="\[\033[${color}m\]"
    local pwd_color="\[\033[${Blue}m\]"
    local exit_code_color="\[\033[${Red}m\]"
    local git_color="\[\033[${Green}m\]"
    local env_color="\[\033[${Magenta}m\]"
    local default_color="\[\033[0m\]"

    PS1="\n["                               # [
    PS1+="$user_host_color\u@\h "           # user @ host
    PS1+="$pwd_color\w"                     # pwd
    PS1+="$git_color$(__git_ps1 ' %s')"     # git status (if in repo)
    PS1+="$env_color $pyvenv"               # python virtual env (if active)
    PS1+="$default_color"                   # back to default color
    PS1+="]\n"                              # ]
    if [[ $exit_code != 0 ]]; then
        PS1+="$exit_code_color$exit_code "  # last exit code if non-zero
        PS1+="$default_color"               # back to default color
    fi
    PS1+="$prompt "                       # prompt
}

bashrc_customize_prompt() {
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWUPSTREAM="verbose"
    PROMPT_COMMAND="bashrc_set_prompt"
    PS2=". "
}

bashrc_customize_ls() {
    local ls_colors="$HOME/.config/dircolors/solarized-$BACKGROUND"
    if type dircolors &> /dev/null && [ -f $ls_colors ]; then
        eval "$(dircolors $ls_colors)"
    fi
}

bashrc_source_completion_helpers() {
    if [ -d /usr/local/etc/bash_completion.d ]; then
        local f
        for f in /usr/local/etc/bash_completion.d/*; do
            source "$f"
        done
    fi
}

# Print the solarized palette (for testing)
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

# Combined mkdir and cd
mkcd() { mkdir -p -- "$1" && cd -P -- "$1"; }

# Colorized `man`
man() {
    if [ "$BACKGROUND" = "dark" ]; then
        local standout="$Base02;44" bold="$Yellow" underline="$Base3;4"
    else
        local standout="$Base02;46" bold="$Blue" underline="$Base00;4"
    fi

    env \
    LESS_TERMCAP_so=$(echo -ne "\033[${standout}m") \
    LESS_TERMCAP_md=$(echo -ne "\033[${bold}m") \
    LESS_TERMCAP_us=$(echo -ne "\033[${underline}m") \
    LESS_TERMCAP_se=$'\033[0m' \
    LESS_TERMCAP_me=$'\033[0m' \
    LESS_TERMCAP_ue=$'\033[0m' \
    GROFF_NO_SGR=1 \
    man "$@"
}

# Apply customizations
stty -ixon # disable ctrl-s and ctrl-q
bashrc_customize_environment
bashrc_customize_shell_options
bashrc_customize_paths
bashrc_customize_aliases
bashrc_customize_terminal_colors
bashrc_customize_prompt
bashrc_customize_ls
bashrc_source_completion_helpers

# Source a local bashrc if available
if [ -f "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
fi

