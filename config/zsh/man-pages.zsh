customize_man_pages() {
  # Foreground colors
  typeset -A fg
  fg[black]='\e[30m'
  fg[red]='\e[31m'
  fg[green]='\e[32m'
  fg[yellow]='\e[33m'
  fg[blue]='\e[34m'
  fg[magenta]='\e[35m'
  fg[cyan]='\e[36m'
  fg[white]='\e[37m'
  fg[br_black]='\e[90m'
  fg[br_red]='\e[91m'
  fg[br_green]='\e[92m'
  fg[br_yellow]='\e[93m'
  fg[br_blue]='\e[94m'
  fg[br_magenta]='\e[95m'
  fg[br_cyan]='\e[96m'
  fg[br_white]='\e[97m'

  # Background colors
  typeset -A bg
  bg[black]='\e[40m'
  bg[red]='\e[41m'
  bg[green]='\e[42m'
  bg[yellow]='\e[43m'
  bg[blue]='\e[44m'
  bg[magenta]='\e[45m'
  bg[cyan]='\e[46m'
  bg[white]='\e[47m'
  bg[br_black]='\e[100m'
  bg[br_red]='\e[101m'
  bg[br_green]='\e[102m'
  bg[br_yellow]='\e[103m'
  bg[br_blue]='\e[104m'
  bg[br_magenta]='\e[105m'
  bg[br_cyan]='\e[106m'
  bg[br_white]='\e[107m'

  # Other modifiers
  local reset='\e[0m'
  local bold='\e[1m'
  local faint='\e[2m'
  local italic='\e[3m'
  local underline='\e[4m'

  #######################
  # Customize man pages #
  #######################

  # bold (md) and blink (mb)
  export LESS_TERMCAP_md="$(printf %b $fg[blue])"
  export LESS_TERMCAP_mb="$LESS_TERMCAP_md"
  export LESS_TERMCAP_me="$(printf %b $reset)"

  # underline
  export LESS_TERMCAP_us="$(printf %b $fg[br_blue] $italic $underline)"
  export LESS_TERMCAP_ue="$(printf %b $reset)"

  # search
  export LESS_TERMCAP_so="$(printf %b $fg[black] $bg[yellow] $bold)"
  export LESS_TERMCAP_se="$(printf %b $reset)"

  # Tell `groff` to not emit SGR sequences, since we are telling `less` to
  # generate them as per the configurations above.
  export GROFF_NO_SGR=1
}

customize_man_pages

