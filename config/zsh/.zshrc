# Set up zsh for interactive use (options, prompt, aliases, etc.)
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/completion.zsh"
source "$ZDOTDIR/history.zsh"
source "$ZDOTDIR/line-editor.zsh"
source "$ZDOTDIR/man-pages.zsh"
source "$ZDOTDIR/prompt.zsh"

# Set up autoload for custom functions.
fpath=("$ZDOTDIR/functions" $fpath)
for filepath in $ZDOTDIR/functions/*; do
  autoload "${filepath##*/}"
done
unset filepath

# Prevent ctrl-s from freezing the terminal.
stty stop undef

# Allow comments in interactive use.
setopt INTERACTIVE_COMMENTS

