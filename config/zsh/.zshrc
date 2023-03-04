# Set up zsh for interactive use (options, prompt, aliases, etc.)
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/completion.zsh"
source "$ZDOTDIR/history.zsh"
source "$ZDOTDIR/prompt.zsh"
source "$ZDOTDIR/vi-mode.zsh"

# Prevent ctrl-s from freezing the terminal.
stty stop undef

