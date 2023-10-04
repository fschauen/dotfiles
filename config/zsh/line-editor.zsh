set_cursor_shape() {
    local block='\e[1 q'        # blinking block
    local underline='\e[3 q'    # blinking underline, 4 for steady
    local bar='\e[5 q'          # blinkind bar, 6 for steady
    if [[ -n "$ITERM_SESSION_ID" && -z "$TMUX" ]] {
        block='\e]1337;CursorShape=0\a'
        bar='\e]1337;CursorShape=1\a'
        underline='\e]1337;CursorShape=2\a'
    }

    case "$1" in
        block)      echo -n $block     ;;
        bar)        echo -n $bar       ;;
        underline)  echo -n $underline ;;
    esac
}

# Start new prompts with bar shaped cursor.
zle-line-init() {
  set_cursor_shape bar
}
zle -N zle-line-init

# Switch cursor shape depending on editing mode.
zle-keymap-select() {
    case $KEYMAP in
        vicmd)      set_cursor_shape block ;;
        viins|main) set_cursor_shape bar   ;;
    esac
}
zle -N zle-keymap-select

# Use vi mode for line editing.
bindkey -v
export KEYTIMEOUT=1

# Restore some common and useful emacs mode shortcuts.
bindkey -M viins '^a' vi-beginning-of-line
bindkey -M viins '^e' vi-end-of-line
bindkey -M viins '^l' clear-screen
bindkey -M viins '^u' kill-whole-line
bindkey -M viins '^[.' insert-last-word

# Search through history in insert mode.
bindkey -M viins '^j' history-beginning-search-forward
bindkey -M viins '^k' history-beginning-search-backward

# Move word-wise with Alt.
bindkey -M viins '^[b' vi-backward-word
bindkey -M viins '^[f' vi-forward-word

if command -v fzf >/dev/null 2>&1; then
  # Add `fzf` key bindings if it's installed:
  #   - CTRL-T: paste the selected file path(s) into the command line
  #   - ALT-C: cd into the selected directory
  #   - CTRL-R: paste the selected command from history into the command line
  source "$ZDOTDIR/line-editor-fzf.zsh"
else
  # Fall back to incremental search
  bindkey -M viins '^r' history-incremental-search-backward
  bindkey -M isearch '^j' history-incremental-search-forward
  bindkey -M isearch '^k' history-incremental-search-backward
  bindkey -M isearch '^y' accept-search
fi

