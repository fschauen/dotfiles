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
    export \
        base03="1;30" base02="0;30" base01="1;32" base00="1;33" \
        base0="1;34"  base1="1;36"  base2="0;37"  base3="1;37"  \
        red="0;31"    orange="1;31" yellow="0;33" green="0;32"  \
        cyan="0;36"   blue="0;34"   violet="1;35" magenta="0;35"

    # Eternal bash history (from https://stackoverflow.com/a/19533853)
    export HISTCONTROL=erasedups
    export HISTFILESIZE=
    export HISTSIZE=
    export HISTTIMEFORMAT="[%F %T] "
    export HISTFILE=~/.bash_eternal_history
}

bashrc_customize_shell_options() {
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
    export PATH

    # Prepend custom man directories to MANPATH if they exist, so that we get
    # correct man page entries when multiple versions of a command are
    # available.
    MANPATH=$(MANPATH= manpath)
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
    export MANPATH
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

    alias tree="tree -F --dirsfirst"
    alias tra="tree -a"
    alias trl="tree -ugsh"   # like ls -l (prints owner, group, human size)
    alias trla="trl -a"
    alias trac="tra -C"
    alias trlc="trl -C"
    alias trlac="trla -C"
}

# Send an OSC (Operating System Commmand) to the terminal.
if [ -n "$TMUX" ]; then
    # http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324
    bashrc_send_term_osc() { printf '\033Ptmux;\033\033]%s\007\033\\' "$1"; }
    # bashrc_send_term_osc() { printf '\033Ptmux;\033\033]%s\033\033\\\033\\' "$1"; }
elif [ "${TERM%%[-.]*}" = "screen" ]; then
    # GNU screen (screen, screen-256color, screen-256color-bce)
    bashrc_send_term_osc() { printf '\033P\033]%s\007\033\\' "$1"; }
else
    bashrc_send_term_osc() { printf '\033]%s\033\\' "$1"; }
fi

bashrc_customize_terminal_colors() {
    if [ "$TERM_PROGRAM" = "Apple_Terminal" ]; then
        echo "tell application \"Terminal\" to set current settings of selected tab of front window to settings set \"solarized-$BACKGROUND\"" | osascript
        return
    fi

    # Solarize the terminal:
    #   - 4;n;#rrggbb (e.g. https://github.com/mintty/mintty/wiki/Tips#changing-colours)
    #   - Colors from http://ethanschoonover.com/solarized
    bashrc_send_term_osc "4;0;#073642"  # Base02
    bashrc_send_term_osc "4;1;#DC322F"  # Red
    bashrc_send_term_osc "4;2;#859900"  # Green
    bashrc_send_term_osc "4;3;#B58900"  # Yellow
    bashrc_send_term_osc "4;4;#268BD2"  # Blue
    bashrc_send_term_osc "4;5;#D33682"  # Magenta
    bashrc_send_term_osc "4;6;#2AA198"  # Cyan
    bashrc_send_term_osc "4;7;#EEE8D5"  # Base2
    bashrc_send_term_osc "4;8;#002B36"  # Base03
    bashrc_send_term_osc "4;9;#CB4B16"  # Orange
    bashrc_send_term_osc "4;10;#586E75" # Base01
    bashrc_send_term_osc "4;11;#657B83" # Base00
    bashrc_send_term_osc "4;12;#839496" # Base0
    bashrc_send_term_osc "4;13;#6C71C4" # Violet
    bashrc_send_term_osc "4;14;#93A1A1" # Base1
    bashrc_send_term_osc "4;15;#FDF6E3" # Base3

    if [ "$BACKGROUND" = "dark" ]; then
        local background_rgb="002B36"   # Base03
        local foreground_rgb="93A1A1"   # Base1
    else
        local background_rgb="EEE8D5"   # Base2
        local foreground_rgb="073642"   # Base02
    fi

    if [ -n "$ITERM_SESSION_ID" ]; then
        # iTerm2: Pnrrggbb (http://iterm2.com/documentation-escape-codes.html)
        bashrc_send_term_osc "Pg$foreground_rgb"    # Foreground
        bashrc_send_term_osc "Pi$foreground_rgb"    # Bold
        bashrc_send_term_osc "Ph$background_rgb"    # Background
        bashrc_send_term_osc "Pj586E75"             # Selection (Base01)
        bashrc_send_term_osc "PkEEE8D5"             # Selected text (Base2)
        bashrc_send_term_osc "PlDC322F"             # Cursor (Red)
        bashrc_send_term_osc "PmDC322F"             # Cursor text (Red)
    else
        bashrc_send_term_osc "10;#$foreground_rgb"  # Foreground
        bashrc_send_term_osc "11;#$background_rgb"  # Background
        bashrc_send_term_osc "12;#DC322F"           # Cursor (Red)
    fi
}

bashrc_set_prompt() {
    local exit_code=$?
    local level=$SHLVL
    local prompt=$(printf '\$%.0s' $(seq 1 $level))
    local color="$cyan"
    if [ $EUID -eq 0 ]; then
        # root user
        prompt=$(printf '#%.0s' $(seq 1 $level))
        color="$orange"
    elif [ -n "$SSH_CLIENT" ]; then
        # SSH connection
        color="$yellow"
    fi

    local user_host_color="\[\033[${color}m\]"
    local pwd_color="\[\033[${blue}m\]"
    local exit_code_color="\[\033[${magenta}m\]"
    local git_color="\[\033[${green}m\]"
    local default_color="\[\033[0m\]"

    PS1="\n["                               # [
    PS1+="$user_host_color\u@\h "           # user @ host
    PS1+="$pwd_color\w"                     # pwd
    PS1+="$git_color$(__git_ps1 ' %s')"     # git status (only if in repo)
    PS1+="$default_color"                   # back to default color
    PS1+="]\n"                              # ]
    if [[ $exit_code != 0 ]]; then
        PS1+="$exit_code_color$exit_code "  # last exit code if non-zero
        PS1+="$default_color"               # back to default color
    fi
    PS1+="$prompt "                       # prompt
}

bashrc_customize_prompt() {
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM="verbose"
    export PROMPT_COMMAND="bashrc_set_prompt"
    export PS2=". "
}

bashrc_customize_ls() {
    local ls_colors="$HOME/.config/dircolors/solarized-$BACKGROUND"
    if type dircolors &> /dev/null && [ -f $ls_colors ]; then
        eval "$(dircolors $ls_colors)"
    fi
}

# Print the solarized palette (for testing)
solarized() {
    local names=(Base02 Red Green Yellow Blue Magenta Cyan Base2
                 Base03 Orange Base01 Base00 Base0 Violet Base1 Base3)
    local   hex=(073642 DC322F 859900 B58900 268BD2 D33682 2AA198 EEE8D5
                 002B36 CB4B16 586E75 657B83 839496 6C71C4 93A1A1 FDF6E3)

    for index in 1 9 3 2 6 4 13 5 8 0 10 11 12 14 7 15; do
        local c="$(( $index > 7 ));$(( 30 + $index % 8 ))"
        printf \
            "\033[${c}m%2d $c ${hex[index]} %-7s \x1b[48;5;${index}m%s\033[0m\n" \
            $index ${names[index]} "          "
    done
}

# Combined mkdir and cd
mkcd() { mkdir -p -- "$1" && cd -P -- "$1"; }

# Colorized `man`
man() {
    if [ "$BACKGROUND" = "dark" ]; then
        local standout="$base02;44" bold="$yellow" underline="$base3;4"
    else
        local standout="$base02;46" bold="$blue" underline="$base00;4"
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

# Source any available completion helpers
if [ -d /usr/local/etc/bash_completion.d ]; then
    for f in /usr/local/etc/bash_completion.d/*; do
        source "$f"
    done
fi

# Source a local bashrc if available
if [ -f "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
fi

