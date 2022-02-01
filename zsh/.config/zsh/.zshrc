#!/bin/zsh
# Set up zsh for interactive use (options, prompt, aliases, etc.)

# Source additional configurations if available.
while read -r f; do [ -f "$f" ] && source "$f"; done <<EOL
    $ZDOTDIR/aliases
    $ZDOTDIR/completion
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

