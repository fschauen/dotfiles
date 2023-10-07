# Customize man pages.
  reset="$(printf %b '\e[0m')"
  bold='\e[1m'      faint='\e[2m'      italic='\e[3m'     underline='\e[4m'
  black='\e[30m'   brblack='\e[90m'   black_bg='\e[40m'   brblack_bg='\e[100m'
    red='\e[31m'     brred='\e[91m'     red_bg='\e[41m'     brred_bg='\e[101m'
  green='\e[32m'   brgreen='\e[92m'   green_bg='\e[42m'   brgreen_bg='\e[102m'
 yellow='\e[33m'  bryellow='\e[93m'  yellow_bg='\e[43m'  bryellow_bg='\e[103m'
   blue='\e[34m'    brblue='\e[94m'    blue_bg='\e[44m'    brblue_bg='\e[104m'
magenta='\e[35m' brmagenta='\e[95m' magenta_bg='\e[45m' brmagenta_bg='\e[105m'
   cyan='\e[36m'    brcyan='\e[96m'    cyan_bg='\e[46m'    brcyan_bg='\e[106m'
  white='\e[37m'   brwhite='\e[97m'   white_bg='\e[47m'   brwhite_bg='\e[107m'

export LESS_TERMCAP_md="$(printf %b $blue)"             # bold
export LESS_TERMCAP_mb="$LESS_TERMCAP_md"               # blink
export LESS_TERMCAP_me="$reset"
export LESS_TERMCAP_us="$(printf %b $brblue $italic $underline)"   # underline
export LESS_TERMCAP_ue="$reset"
export LESS_TERMCAP_so="$(printf %b $black $yellow_bg $bold)"  # search
export LESS_TERMCAP_se="$reset"
export GROFF_NO_SGR=1

unset bold    faint     italic     underline  reset
unset black   brblack   black_bg   brblack_bg
unset red     brred     red_bg     brred_bg
unset green   brgreen   green_bg   brgreen_bg
unset yellow  bryellow  yellow_bg  bryellow_bg
unset blue    brblue    blue_bg    brblue_bg
unset magenta brmagenta magenta_bg brmagenta_bg
unset cyan    brcyan    cyan_bg    brcyan_bg
unset white   brwhite   white_bg   brwhite_bg

# Set up zsh for interactive use (options, prompt, aliases, etc.)
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/completion.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/history.zsh"
source "$ZDOTDIR/line-editor.zsh"
source "$ZDOTDIR/prompt.zsh"

# Prevent ctrl-s from freezing the terminal.
stty stop undef

