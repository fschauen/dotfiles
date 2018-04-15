# Environment variables
export EDITOR="vim"
export HISTSIZE="65536"
export HISTFILESIZE="$HISTSIZE"
export HISTCONTROL=ignoredups:ignorespace
export LANG="en_US.UTF-8"
export LANGUAGE="en_US"
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LESS="-i -j.49 -M -R -z-2"
export PAGER=less
export DOTFILES="$HOME/.dotfiles"

# Prepend custom bin directories to PATH if they exist.
for p in /usr/local/opt/coreutils/libexec/gnubin "$DOTFILES/bin" "$HOME/bin"
do
    [ -d "$p" ] && export PATH="$p:$PATH"
done

# Prepend custom man directories to MANPATH if they exist, so that we get
# correct man page entries when multiple versions of a command are available.
for p in /usr/local/share/man /usr/local/opt/coreutils/libexec/gnuman
do
    [ -d "$p" ] && export MANPATH="$p:$MANPATH"
done

# Useful aliases
if ls --group-directories-first >/dev/null 2>&1
then
    ls_dir_group="--group-directories-first"    # GNU version
else
    ls_dir_group="" # BSD version, doesn't support directory grouping
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
alias manpath='echo $MANPATH | tr -s ":" "\n"'

# Shell options
for option in cdspell checkwinsize globstar histappend nocaseglob
do
    shopt -s "$option" 2> /dev/null
done

# Add git command completion
source "$DOTFILES/resources/git-completion.bash"

# combined mkdir and cd
mkcd() { mkdir -p -- "$1" && cd -P -- "$1"; }

# Change a color in the terminal's palette
change_palette() (
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

# Solarize the shell by adjusting:
#   - the terminal's color palette
#   - the ANSI color palette
#   - prompt string
#   - `ls` command output colors
do_solarize_shell() {
    [ -z "$BACKGROUND" ] && export BACKGROUND="dark"

    if [ "$TERM_PROGRAM" = "Apple_Terminal" ]; then
        echo "tell application \"Terminal\" to set current settings of selected tab of front window to settings set \"solarized-$BACKGROUND\"" | osascript
    else
        # Solarized colors from http://ethanschoonover.com/solarized
        base03=002b36 base02=073642 base01=586e75 base00=657b83
        base0=839496  base1=93a1a1  base2=eee8d5  base3=fdf6e3
        red=dc322f    orange=cb4b16 yellow=b58900 green=859900
        cyan=2aa198   blue=268bd2   violet=6c71c4 magenta=d33682

        # Customize the terminal's color palette & determine selector for
        # changing the ANSI color palette below
        cursor_color=$red
        if [ "$BACKGROUND" = "dark" ]; then
            bg_color=$base03
            fg_color=$base1
        else
            bg_color=$base2
            fg_color=$base02
        fi
        if [ -n "$ITERM_SESSION_ID" ]; then
            change_palette Pg $fg_color       # Foreground
            change_palette Pi $fg_color       # Bold
            change_palette Ph $bg_color       # Background
            change_palette Pj $base01         # Selection
            change_palette Pk $base2          # Selected text
            change_palette Pl $cursor_color   # Cursor
            change_palette Pm $cursor_color   # Cursor text
            selector="P%s" a=a b=b c=c d=d e=e f=f
        else
            change_palette "10;#" $fg_color       # Foreground
            change_palette "11;#" $bg_color       # Background
            change_palette "12;#" $cursor_color   # Cursor
            selector="4;%d;#" a=10 b=11 c=12 d=13 e=14 f=15
        fi

        # Change the ANSI color palette
        #   iTerm2: Pnrrggbb (http://iterm2.com/documentation-escape-codes.html)
        #   other terminals: 4;n;#rrggbb
        #        Pn or 4;n;#         n        rrggbb        ANSI name
        change_palette $(printf $selector  0) $base02     # 0;30 black
        change_palette $(printf $selector  1) $red        # 0;31 red
        change_palette $(printf $selector  2) $green      # 0;32 green
        change_palette $(printf $selector  3) $yellow     # 0;33 yellow
        change_palette $(printf $selector  4) $blue       # 0;34 blue
        change_palette $(printf $selector  5) $magenta    # 0;35 magenta
        change_palette $(printf $selector  6) $cyan       # 0;36 cyan
        change_palette $(printf $selector  7) $base2      # 0;37 white
        change_palette $(printf $selector  8) $base03     # 1;30 bold black
        change_palette $(printf $selector  9) $orange     # 1;31 bold red
        change_palette $(printf $selector $a) $base01     # 1;32 bold green
        change_palette $(printf $selector $b) $base00     # 1;33 bold yellow
        change_palette $(printf $selector $c) $base0      # 1;34 bold blue
        change_palette $(printf $selector $d) $violet     # 1;35 bold magenta
        change_palette $(printf $selector $e) $base1      # 1;36 bold cyan
        change_palette $(printf $selector $f) $base3      # 1;37 bold white
    fi

    # Customize the prompt
    if [ $(id -u) -eq 0 ]; then
        __c="1;31"      # orange user name for root
    elif [ -n "$SSH_CLIENT" ]; then
        __c="0;33"      # yellow user name when connected via SSH
    else
        __c="0;36"      # default user name color is cyan
    fi
    export PS1="[\[\033[${__c}m\]\u@\h \[\033[0;34m\]\w\[\033[0m\]]\n\$ "
    export PS2=". "

    # Customize colors for `ls` command
    ls_colors="$HOME/.dircolors/solarized-$BACKGROUND"
    if type dircolors &> /dev/null && [ -f $ls_colors ]; then
        eval "$(dircolors $ls_colors)"
    fi
}

# Quickly change between light and dark background
light() { export BACKGROUND="light" && do_solarize_shell; }
dark() { export BACKGROUND="dark" && do_solarize_shell; }

# Print the solarized palette (for testing)
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

# Solarize the shell only if running interactively (makes FTP clients happy)
[[ "$-" == *i* ]] && do_solarize_shell

# ~/.bashrc.local can be used for local settings (not in repository)
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
