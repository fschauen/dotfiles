get_platform() {
    local remove_spaces="s/ *//g"
    local to_lower="y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
    local get_version="s/[^0-9]*\(\([0-9]\+\.\?\)*\)/\1/"
    local kernel=$(uname -s  | sed "$remove_spaces; $to_lower")
    local version=$(uname -r | sed "$get_version")
    local machine=$(uname -m | sed "$remove_spaces; $to_lower")
    echo "$kernel-$version-$machine"
}

#
# Environment variables
#
export PLATFORM=$(get_platform)
export EDITOR="vim"
export HISTSIZE="65536"
export HISTFILESIZE="$HISTSIZE"
export HISTCONTROL=ignoredups:ignorespace
export LANG="en_US.UTF-8"
export LANGUAGE="en_US"
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
[ -z "$BACKGROUND" ] && export BACKGROUND="dark"

gnubin=/usr/local/opt/coreutils/libexec/gnubin
[ -d "$gnubin" ] && PATH="$gnubin:$PATH"
[ -d "$HOME/.dotfiles/bin" ] && PATH="$HOME/.dotfiles/bin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
export PATH

localman=/usr/local/share/man
gnuman=/usr/local/opt/coreutils/libexec/gnuman
[ -d "$localman" ] && MANPATH="$localman:$MANPATH"
[ -d "$gnuman" ] && MANPATH="$gnuman:$MANPATH"
export MANPATH

#
# Aliases
#
alias g="git"
alias ls="ls --color=auto"
alias l="ls -F"
alias la="ls -aF"
alias ll="ls -lF"
alias lla="ls -laF"
alias grep="grep --color=auto";
alias vi="vim"
alias path='echo $PATH | tr -s ":" "\n"'

if [[ ${PLATFORM%%-*} == "darwin" ]]; then
    alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
fi

#
# Shell options
#
for option in cdspell checkwinsize globstar histappend nocaseglob
do
    shopt -s "$option" 2> /dev/null
done

#
# ~/.bashrc.local can be used for local settings (not in repository)
#
[ -f ~/.bashrc.local ] && . ~/.bashrc.local

#
# Solarized shell & prompt
#

setcolor() (
    IFS=""  # $* should be joined without spaces
    if [ -n "$TMUX" ]; then
        # http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324
        echo -ne "\033Ptmux;\033\033]$*\007\033\\"
    elif [ "${TERM%%-*}" = "screen" ]; then
        echo -ne "\033P\033]$*\007\033\\"
    else
        echo -ne "\033]$*\033\\"
    fi
)

apply_solarized() {
    if [ "$TERM_PROGRAM" = "Apple_Terminal" ]; then
        echo "tell application \"Terminal\" to set current settings of selected tab of front window to settings set \"solarized-$BACKGROUND\"" | osascript
    else
        # http://ethanschoonover.com/solarized
        base03=002b36 base02=073642 base01=586e75 base00=657b83
        base0=839496  base1=93a1a1  base2=eee8d5  base3=fdf6e3
        red=dc322f    orange=cb4b16 yellow=b58900 green=859900
        cyan=2aa198   blue=268bd2   violet=6c71c4 magenta=d33682

        # Determine customization colors based on dark/light background
        cursor_color=$red
        sel_color=$base01             # only for iTerm2
        sel_text_color=$Base2         # only for iTerm2
        if [ "$BACKGROUND" = "dark" ]; then
            bg_color=$base03
            fg_color=$base1
        else
            bg_color=$base2
            fg_color=$base02
        fi

        # Customize foreground/background/cursor & determine selector for
        # setting the ANSI colors below
        if [ -n "$ITERM_SESSION_ID" ]; then
            setcolor Pg $fg_color       # Foreground
            setcolor Pi $fg_color       # Bold
            setcolor Ph $bg_color       # Background
            setcolor Pj $sel_color      # Selection
            setcolor Pk $sel_text_color # Selected text
            setcolor Pl $cursor_color   # Cursor
            setcolor Pm $cursor_color   # Cursor text
            selector="P%s" a=a b=b c=c d=d e=e f=f
        else
            setcolor "10;" $fg_color        # Foreground
            setcolor "11;" $bg_color        # Background
            setcolor "12;" $cursor_color    # Cursor
            selector="4;%d;#" a=10 b=11 c=12 d=13 e=14 f=15
        fi

        # Set the ANSI colors
        #   iTerm2: Pnrrggbb (http://iterm2.com/documentation-escape-codes.html)
        #   other terminals: 4;n;#rrggbb
        #        Pn or 4;n;#         n  rrggbb        ANSI name
        setcolor $(printf $selector  0) $base02     # 0;30 black
        setcolor $(printf $selector  1) $red        # 0;31 red
        setcolor $(printf $selector  2) $green      # 0;32 green
        setcolor $(printf $selector  3) $yellow     # 1;33 yellow
        setcolor $(printf $selector  4) $blue       # 0;34 blue
        setcolor $(printf $selector  5) $magenta    # 0;35 magenta
        setcolor $(printf $selector  6) $cyan       # 0;36 cyan
        setcolor $(printf $selector  7) $base2      # 0;37 white
        setcolor $(printf $selector  8) $base03     # 1;30 bold black
        setcolor $(printf $selector  9) $orange     # 1;31 bold red
        setcolor $(printf $selector $a) $base01     # 1;32 bold green
        setcolor $(printf $selector $b) $base00     # 1;33 bold yellow
        setcolor $(printf $selector $c) $base0      # 1;34 bold blue
        setcolor $(printf $selector $d) $violet     # 1;35 bold magenta
        setcolor $(printf $selector $e) $base1      # 1;36 bold cyan
        setcolor $(printf $selector $f) $base3      # 1;37 bold white
    fi

    if [ "$BACKGROUND" = "light" ]; then
        prompt_color="\[\033[0;36m\]" # cyan
    else
        prompt_color="\[\033[0;34m\]" # blue
    fi
    export PS1="\n[${prompt_color}\w\[\033[0m\]]\n\$ ";
    export PS2=". ";

    ls_colors="$HOME/.dircolors/solarized-$BACKGROUND"
    if type dircolors &> /dev/null && [ -f $ls_colors ]; then
        eval "$(dircolors $ls_colors)"
    fi
}
apply_solarized

light() { export BACKGROUND="light" && apply_solarized; }
dark() { export BACKGROUND="dark" && apply_solarized; }

solarized() {
    printf "\033[%sm%-7s\033[0m "  "1;30" Base03
    printf "\033[%sm%-7s\033[0m "  "0;30" Base02
    printf "\033[%sm%-7s\033[0m "  "1;32" Base01
    printf "\033[%sm%-7s\033[0m "  "1;33" Base00
    printf "\033[%sm%-7s\033[0m "  "1;34" Base0
    printf "\033[%sm%-7s\033[0m "  "1;36" Base1
    printf "\033[%sm%-7s\033[0m "  "0;37" Base2
    printf "\033[%sm%-7s\033[0m\n" "1;37" Base3
    printf "\033[%sm%-7s\033[0m "  "0;31" Red
    printf "\033[%sm%-7s\033[0m "  "1;31" Orange
    printf "\033[%sm%-7s\033[0m "  "0;33" Yellow
    printf "\033[%sm%-7s\033[0m "  "0;32" Green
    printf "\033[%sm%-7s\033[0m "  "0;36" Cyan
    printf "\033[%sm%-7s\033[0m "  "0;34" Blue
    printf "\033[%sm%-7s\033[0m "  "1;35" Violet
    printf "\033[%sm%-7s\033[0m\n" "0;35" Magenta
}

