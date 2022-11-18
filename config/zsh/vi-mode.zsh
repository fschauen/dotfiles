# Use vi mode for line editing.
bindkey -v
export KEYTIMEOUT=1

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

# Switch cursor shape depending on editing mode.
zle-keymap-select() {
    case $KEYMAP in
        vicmd)      set_cursor_shape block ;;
        viins|main) set_cursor_shape bar   ;;
    esac
}
zle -N zle-keymap-select

# Start new prompts with bar shaped cursor.
zle-line-init() { set_cursor_shape bar }
zle -N zle-line-init

# Search through history in insert mode.
bindkey -M viins '^j' history-beginning-search-forward
bindkey -M viins '^k' history-beginning-search-backward

# Restore some common and useful emacs mode shortcut.
bindkey -M viins '^a' vi-beginning-of-line
bindkey -M viins '^e' vi-end-of-line
bindkey -M viins '^l' clear-screen

