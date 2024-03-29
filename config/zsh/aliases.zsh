# ls:  make `ls` group directories first if supported.
# lsc: force `ls` to use color output (e.g. for piping into `less`).
if command -v exa >/dev/null 2>&1; then
  # Prefer exa if installed
  alias \
    ls="exa --classify --group-directories-first --group --links" \
    la="ls --all" \
    lt="ls --long --tree --ignore-glob='.git'" \
    lta="lt --all" \
    lsc="ls --color=always" \
    ltc="lt --color=always"
elif ls --group-directories-first --color=auto >/dev/null 2>&1; then
  # GNU ls
  alias \
    ls="ls --classify --human-readable --group-directories-first --color=auto" \
    la="ls --almost-all" \
    lt="tree --dirsfirst -FI '.git|Spotlight-V100|.fseventsd'" \
    lsc="ls --color=always" \
    ltc="tree -C --dirsfirst -FI '.git'"
else
  # BSD ls (e.g. macOS)
  alias \
    ls="ls -hF -G" \
    la="ls -A" \
    lt="tree --dirsfirst -FI '.git|Spotlight-V100|.fseventsd'" \
    lsc="/usr/bin/env CLICOLOR_FORCE=1 ls" \
    ltc="tree -C --dirsfirst -FI '.git'"
fi

alias \
  ll="ls -l" \
  lla="la -l" \
  ltl="lt -L"

alias \
  grep="grep --color=auto" \
  egrep="egrep --color=auto" \
  fgrep="fgrep --color=auto"

alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"

if command -v nvim >/dev/null 2>&1; then
  alias \
    v="nvim" \
    vi="nvim" \
    vim="nvim" \
    vimdiff="nvim -d"
fi

