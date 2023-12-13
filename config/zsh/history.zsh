setopt APPEND_HISTORY     # Append history rather than overwrite.
setopt EXTENDED_HISTORY   # Save beginning timestamp and duration.
setopt INC_APPEND_HISTORY # Don't wait until shell exits to save history.

HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
HISTSIZE=1000000
SAVEHIST=1000000

