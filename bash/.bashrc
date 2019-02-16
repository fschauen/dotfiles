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
    export PAGER=less
    export DOTFILES="$HOME/.dotfiles"
    export \
        base03="1;30" base02="0;30" base01="1;32" base00="1;33" \
        base0="1;34"  base1="1;36"  base2="0;37"  base3="1;37"  \
        red="0;31"    orange="1;31" yellow="0;33" green="0;32"  \
        cyan="0;36"   blue="0;34"   violet="1;35" magenta="0;35"

    # Eternal bash history (from https://stackoverflow.com/a/19533853)
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
        export PATH=""
        source /etc/profile
    fi

    # Add custom bin dirs to PATH if they exist and are not already in PATH.
    for p in $prefix/opt/coreutils/libexec/gnubin $HOME/.local/bin $HOME/bin
    do
        if [ -d "$p" ] && [[ ":$PATH:" != *":$p:"* ]]; then
            PATH="$p:$PATH"
        fi
    done

    # If MANPATH is not yet defined, initialize it with the contents of
    # `manpath`.
    if [ -z ${MANPATH+x} ]; then
        export MANPATH=$(manpath)
    fi

    # Prepend custom man directories to MANPATH if they exist, so that we get
    # correct man page entries when multiple versions of a command are
    # available.
    for p in $prefix/share/man $prefix/opt/coreutils/libexec/gnuman
    do
        if [ -d "$p" ] && [[ ":$MANPATH:" != *":$p:"* ]]; then
            MANPATH="$p:$MANPATH"
        fi
    done
}

bashrc_customize_aliases() {
    # Group directories first if supported by the available `ls` command.
    local ls_dir_group=""
    if ls --group-directories-first >/dev/null 2>&1; then
        ls_dir_group="--group-directories-first"
    fi

    alias g="git"
    alias ls="ls -hF --color=auto ${ls_dir_group}"
    alias la="ls -a"
    alias ll="ls -l"
    alias lla="ls -la"
    alias grep="grep --color=auto";
    alias egrep="egrep --color=auto";
    alias fgrep="fgrep --color=auto";
    alias v="vim"
    alias vi="vim"
    alias path='echo $PATH | tr -s ":" "\n"'
    alias mpath='echo $MANPATH | tr -s ":" "\n"'
}

bashrc_send_term_osc() {
    # Send an OSC (Operating System Commmand) to the terminal.
    if [ -n "$TMUX" ]; then
        # http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324
        echo -ne "\ePtmux;\e\e]$1\007\e\\"
    elif [ "${TERM%%-*}" = "screen" ]; then
        echo -ne "\eP\e]$1\007\e\\"
    else
        echo -ne "\e]$1\e\\"
    fi
}

bashrc_customize_terminal_colors() {
    if [ "$TERM_PROGRAM" = "Apple_Terminal" ]; then
        echo "tell application \"Terminal\" to set current settings of selected tab of front window to settings set \"solarized-$BACKGROUND\"" | osascript
        return
    fi

    # Solarized colors from http://ethanschoonover.com/solarized
    local \
    base03_rgb=002b36 base02_rgb=073642 base01_rgb=586e75 base00_rgb=657b83 \
    base0_rgb=839496  base1_rgb=93a1a1  base2_rgb=eee8d5  base3_rgb=fdf6e3 \
    red_rgb=dc322f    orange_rgb=cb4b16 yellow_rgb=b58900 green_rgb=859900 \
    cyan_rgb=2aa198   blue_rgb=268bd2   violet_rgb=6c71c4 magenta_rgb=d33682

    if [ "$BACKGROUND" = "dark" ]; then
        local background_rgb=$base03_rgb foreground_rgb=$base1_rgb
    else
        local background_rgb=$base2_rgb  foreground_rgb=$base02_rgb
    fi
    if [ -n "$ITERM_SESSION_ID" ]; then
        # iTerm2: Pnrrggbb (http://iterm2.com/documentation-escape-codes.html)
        bashrc_send_term_osc "Pg$foreground_rgb"    # Foreground
        bashrc_send_term_osc "Pi$foreground_rgb"    # Bold
        bashrc_send_term_osc "Ph$background_rgb"    # Background
        bashrc_send_term_osc "Pj$base01_rgb"        # Selection
        bashrc_send_term_osc "Pk$base2_rgb"         # Selected text
        bashrc_send_term_osc "Pl$red_rgb"           # Cursor
        bashrc_send_term_osc "Pm$red_rgb"           # Cursor text
        local format_string="P%s" a=a b=b c=c d=d e=e f=f
    else
        # Other terminals: 4;n;#rrggbb (e.g. https://github.com/mintty/mintty/wiki/Tips#changing-colours)
        bashrc_send_term_osc "10;#$foreground_rgb"  # Foreground
        bashrc_send_term_osc "11;#$background_rgb"  # Background
        bashrc_send_term_osc "12;#$red_rgb"         # Cursor
        local format_string="4;%d;#" a=10 b=11 c=12 d=13 e=14 f=15
    fi

    bashrc_send_term_osc "$(printf $format_string  0)$base02_rgb"
    bashrc_send_term_osc "$(printf $format_string  1)$red_rgb"
    bashrc_send_term_osc "$(printf $format_string  2)$green_rgb"
    bashrc_send_term_osc "$(printf $format_string  3)$yellow_rgb"
    bashrc_send_term_osc "$(printf $format_string  4)$blue_rgb"
    bashrc_send_term_osc "$(printf $format_string  5)$magenta_rgb"
    bashrc_send_term_osc "$(printf $format_string  6)$cyan_rgb"
    bashrc_send_term_osc "$(printf $format_string  7)$base2_rgb"
    bashrc_send_term_osc "$(printf $format_string  8)$base03_rgb"
    bashrc_send_term_osc "$(printf $format_string  9)$orange_rgb"
    bashrc_send_term_osc "$(printf $format_string $a)$base01_rgb"
    bashrc_send_term_osc "$(printf $format_string $b)$base00_rgb"
    bashrc_send_term_osc "$(printf $format_string $c)$base0_rgb"
    bashrc_send_term_osc "$(printf $format_string $d)$violet_rgb"
    bashrc_send_term_osc "$(printf $format_string $e)$base1_rgb"
    bashrc_send_term_osc "$(printf $format_string $f)$base3_rgb"
}

bashrc_set_prompt() {
    local exit_code=$?

    local level=$SHLVL
    if [[ -n "$TMUX" ]]; then
        level=$(($SHLVL - 2))
    fi

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

    local user_host_color="\[\e[${color}m\]"
    local pwd_color="\[\e[${blue}m\]"
    local default_color="\[\e[0m\]"
    local exit_code_color="\[\e[${magenta}m\]"

    PS1="["                                 # [
    PS1+="$user_host_color\u@\h "           # user @ host
    PS1+="$pwd_color\w"                     # pwd
    if [[ $exit_code != 0 ]]; then
        PS1+=" $exit_code_color$exit_code"  # last exit code if non-zero
    fi
    PS1+="$default_color"                   # back to default color
    PS1+="]"                                # ]
    PS1+="\n$prompt "                       # prompt on next line
}

bashrc_customize_prompt() {
    export PROMPT_COMMAND="bashrc_set_prompt"
    export PS2=". "
}

bashrc_customize_ls() {
    local ls_colors="$HOME/.dircolors/solarized-$BACKGROUND"
    if type dircolors &> /dev/null && [ -f $ls_colors ]; then
        eval "$(dircolors $ls_colors)"
    fi
}

# Change to light background
light() {
    export BACKGROUND="light"
    bashrc_customize_terminal_colors
    bashrc_customize_prompt
    bashrc_customize_ls
}

# Change to dark background
dark() {
    export BACKGROUND="dark"
    bashrc_customize_terminal_colors
    bashrc_customize_prompt
    bashrc_customize_ls
}

# Print the solarized palette (for testing)
solarized() {
    printf "\e[%sm%-7s %-s %2d\e[0m\t" "$base03"  Base03  "$base03"  8
    printf "\e[%sm%-7s %-s %2d\e[0m\n" "$red"     Red     "$red"     1
    printf "\e[%sm%-7s %-s %2d\e[0m\t" "$base02"  Base02  "$base02"  0
    printf "\e[%sm%-7s %-s %2d\e[0m\n" "$orange"  Orange  "$orange"  9
    printf "\e[%sm%-7s %-s %2d\e[0m\t" "$base01"  Base01  "$base01"  10
    printf "\e[%sm%-7s %-s %2d\e[0m\n" "$yellow"  Yellow  "$yellow"  3
    printf "\e[%sm%-7s %-s %2d\e[0m\t" "$base00"  Base00  "$base00"  11
    printf "\e[%sm%-7s %-s %2d\e[0m\n" "$green"   Green   "$green"   2
    printf "\e[%sm%-7s %-s %2d\e[0m\t" "$base0"   Base0   "$base0"   12
    printf "\e[%sm%-7s %-s %2d\e[0m\n" "$cyan"    Cyan    "$cyan"    6
    printf "\e[%sm%-7s %-s %2d\e[0m\t" "$base1"   Base1   "$base1"   14
    printf "\e[%sm%-7s %-s %2d\e[0m\n" "$blue"    Blue    "$blue"    4
    printf "\e[%sm%-7s %-s %2d\e[0m\t" "$base2"   Base2   "$base2"   7
    printf "\e[%sm%-7s %-s %2d\e[0m\n" "$violet"  Violet  "$violet"  13
    printf "\e[%sm%-7s %-s %2d\e[0m\t" "$base3"   Base3   "$base3"   15
    printf "\e[%sm%-7s %-s %2d\e[0m\n" "$magenta" Magenta "$magenta" 5
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
    LESS_TERMCAP_so=$(echo -ne "\e[${standout}m") \
    LESS_TERMCAP_md=$(echo -ne "\e[${bold}m") \
    LESS_TERMCAP_us=$(echo -ne "\e[${underline}m") \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    GROFF_NO_SGR=1 \
    man "$@"
}

# Apply customizations
bashrc_customize_environment
bashrc_customize_shell_options
bashrc_customize_paths
bashrc_customize_aliases
bashrc_customize_terminal_colors
bashrc_customize_prompt
bashrc_customize_ls

[ -f  ~/.git-completion.bash ] && . ~/.git-completion.bash
[ -f ~/.bashrc.local ] && . ~/.bashrc.local

