# Set up zsh for interactive use (options, prompt, aliases, etc.)
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/completion.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/history.zsh"
source "$ZDOTDIR/line-editor.zsh"
source "$ZDOTDIR/man-pages.zsh"
source "$ZDOTDIR/prompt.zsh"

# Prevent ctrl-s from freezing the terminal.
stty stop undef

