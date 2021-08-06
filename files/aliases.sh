#!/bin/sh

# ls:  make `ls` group directories first if supported.
# lsc: force `ls` to use color output (e.g. for piping into `less`).
if command -v exa >/dev/null 2>&1; then
    # Prefer exa if installed
    alias \
        ls="exa -F --git --group-directories-first --group --links" \
        la="ls -a" \
        lt="ls -lT -I'.git'" \
        lta="lt -a" \
        lsc="ls --color=always" \
        ltc="lt --color=always"
elif ls --group-directories-first --color=auto >/dev/null 2>&1; then
    # GNU ls
    alias \
        ls="ls -hF --group-directories-first --color=auto" \
        la="ls -A" \
        lt="tree --dirsfirst -FI '.git|Spotlight-V100|.fseventsd'" \
        lsc="ls --color=always" \
        ltc="tree -C --dirsfirst -FI '.git'"
else
    # BSD ls (e.g. macOS)
    alias \
        ls="ls -hF -G" \
        la="ls -A" \
        lt="tree --dirsfirst -FI '.git|Spotlight-V100|.fseventsd'" \
        lsc="/usr/bin/env CLICOLOR_FORCE=1 ls" \
        ltc="tree -C --dirsfirst -FI '.git'"
fi

alias ll="ls -l"
alias lla="la -l"

alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

if command -v nvim >/dev/null 2>&1; then
    alias vim="nvim"
    alias vimdiff="nvim -d"
fi

