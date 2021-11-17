#!/bin/zsh
# Set up zsh for interactive use (options, prompt, aliases, etc.)

# Source additional configurations if available.
while read -r f; do [ -f "$f" ] && source "$f"; done <<EOL
    $ZDOTDIR/aliases
    $ZDOTDIR/prompt
    $ZDOTDIR/vi-mode
EOL
unset f

# Prevent ctrl-s from freezing the terminal.
stty stop undef

# Save a lot of history.
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
HISTSIZE=1000000
SAVEHIST=1000000

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select

# bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'k' vi-up-line-or-history
# bindkey -M menuselect 'l' vi-forward-char
# bindkey -M menuselect 'j' vi-down-line-or-history


