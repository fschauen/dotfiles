# Keep things organized.
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Everything else will be configured from within $ZDOTDIR.
export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"

