zmodload zsh/complist
autoload -Uz compinit && compinit

# Include hidden files when completing.
_comp_options+=(globdots)

# Completion context pattern:
#   :completion:<function>:<completer>:<command>:<argument>:<tag>

zstyle ':completion:*' completer _extensions _complete

# Match case-insensitively and on partial words.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

# Activate caching for completions that may use it.
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# List files in a format similar to `ls -l`.
zmodload zsh/stat   # required for `file-list all`
disable stat        # don't shadow external `stat` executable
zstyle ':completion:*' file-list all

# Don't complete on all path components, which would complete /u/b/z to /usr/bin/zsh.
zstyle ':completion:*' path-completion false

# Use tags as the group names.
zstyle ':completion:*' group-name ''

# Custom order for words in the command position.
zstyle ':completion:*:*:-command-:*:*' group-order builtins aliases functions commands

# Colors!
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}❯❯ %d%f'
zstyle ':completion:*:*:*:*:corrections'  format '%F{yellow}❯❯ %d%f'
zstyle ':completion:*:*:*:*:original'     format '%F{yellow}❯❯ %d%f'
zstyle ':completion:*:*:*:*:messages'     format '%F{cyan}❯❯ %d%f'
zstyle ':completion:*:*:*:*:warnings'     format '%F{red}❯❯ no matches%f'
zstyle ':completion:*:*:*:*:default'      list-colors true

##################
# Menu selection #
##################
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:default' select-prompt '%K{yellow}%F{black}%l (%p)%f%k'

# Navigate the list with `hjkl`.
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Accept selected match and keep menu open.
bindkey -M menuselect 'p' accept-and-hold

# Accept selected match and restart completion (allows drilling down directories).
bindkey -M menuselect '\t' accept-and-infer-next-history

# Remove previously inserted matches.
bindkey -M menuselect 'u' undo

# Jump to first/last line.
bindkey -M menuselect 'g' beginning-of-history
bindkey -M menuselect 'G' end-of-history

# Page down/up.
bindkey -M menuselect 'f' vi-forward-word
bindkey -M menuselect 'b' vi-backward-word

