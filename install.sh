#!/bin/sh
# shellcheck disable=SC1090,SC1091

set -eu

dotfiles="$(dirname "$(realpath "$0")")"

if [ -t 1 ]; then
  sgr0="$(printf      '\033[0m')"
  red="$(printf       '\033[31m')"
  green="$(printf     '\033[32m')"
  yellow="$(printf    '\033[33m')"
  blue="$(printf      '\033[34m')"
  # magenta="$(printf  '\033[35m')"
  cyan="$(printf      '\033[36m')"
else
  sgr0=''
  red=''
  green=''
  yellow=''
  blue=''
  # magenta=''
  cyan=''
fi

CMD=''  # Support for dry runs, see main() below.
SKIP_CONFIRMATION='no'

error() {
  printf "${red}ERROR:$sgr0 %s\n"  "$1"
  exit 1
}

heading() {
  echo "${blue}=====  $1  ==========$sgr0"
}

load_config() {
  defconfig="$dotfiles/config.def.sh"
  config="$dotfiles/config.sh"
  { [ -r "$config" ] || cp -v "$defconfig" "$config"; } || error "can't create config.sh"
  . "$config"
}

move_aside() {
  backup="$1.$(date +%s)"
  echo "${red}WARNING:$sgr0 moving '$1' to '$backup'"
  $CMD mv "$1" "$backup"
}

greeting() {
  echo "Deploying dotfiles:"
  echo "       Source: $cyan$dotfiles$sgr0"
  echo "  Destination: $cyan$DESTDIR$sgr0"
  echo "     Git user: $green$GIT_USER <$GIT_EMAIL>$sgr0"
  echo

  if [ -t 0 ] && [ -t 1 ] && [ "$SKIP_CONFIRMATION" != "yes" ] ; then
    echo "Press ENTER to continue (CTRL-C to cancel)..."
    read -r _
  fi
}

make_dir() {
  if [ -d "$1" ]; then
    echo "${green}OK:$sgr0 $1"
  else
    echo "${yellow}MKDIR:$sgr0 $1"
    $CMD mkdir -vp "$1"
  fi
}

make_link() {
  link="$1"
  target="$2"
  if [ -e "$link" ] && [ "$(realpath "$link")" = "$target" ]; then
    echo "${green}OK:$sgr0 $link $blue->$sgr0 $target"
  else
    [ -e "$link" ] && move_aside "$link"
    echo "${yellow}LINK:$sgr0 $link $blue->$sgr0 $target"
    $CMD ln -sf "$target" "$link"
  fi
}

make_git_user_config() {
  user_config="$DESTDIR/.local/etc/git/config.user"
  temp_git="$(mktemp)"
  cat >"$temp_git" <<EOF
#         *************************************
#         *       DO NOT EDIT THIS FILE       *
#         *************************************
#
# This file was generated by the bootstrap script and any changes will be
# overwritten the next time it is run. For local settings, use this instead:
#
#   ~/.local/etc/git/config
#
EOF
  git config -f "$temp_git" user.name "$GIT_USER"
  git config -f "$temp_git" user.email "$GIT_EMAIL"

  if diff "$user_config" "$temp_git" >/dev/null 2>&1; then
    echo "${green}OK:$sgr0 $user_config has '$GIT_USER <$GIT_EMAIL>'"
  else
    [ -f "$user_config" ] && move_aside "$user_config"
    echo "${yellow}WRITE:$sgr0 $user_config with '$GIT_USER <$GIT_EMAIL>'"
    $CMD cp -f "$temp_git" "$user_config"
  fi
}

usage() {
  echo "Usage: $(basename "$0") [-h] [-n]"
  echo ""
  echo "  -h  print this help and exit"
  echo "  -n  perform dry run"
  echo "  -y  assume yes, i.e. don't ask for confirmation"
}

execute() {
  load_config || error "could not load config.sh"

  [ -n "$DESTDIR" ]   || error "\$DESTDIR must be set in config.sh"
  [ -n "$GIT_USER" ]  || error "\$GIT_USER must be set in config.sh"
  [ -n "$GIT_EMAIL" ] || error "\$GIT_EMAIL must be set in config.sh"

  greeting

  heading 'create required directories'
  make_dir "$DESTDIR/.ssh/"
  make_dir "$DESTDIR/.cache/zsh/"
  make_dir "$DESTDIR/.local/etc/git/"
  make_dir "$DESTDIR/.local/share/less/"
  make_dir "$DESTDIR/.local/share/python/"
  make_dir "$DESTDIR/.local/share/nvim/shada/"
  make_dir "$DESTDIR/.local/share/zsh/"

  heading 'create links'
  make_link "$DESTDIR/.hushlogin"   "$dotfiles/home/.hushlogin"
  make_link "$DESTDIR/.XCompose"    "$dotfiles/home/.XCompose"
  make_link "$DESTDIR/.zshenv"      "$dotfiles/home/.zshenv"
  make_link "$DESTDIR/.bin"         "$dotfiles/bin"
  make_link "$DESTDIR/.config"      "$dotfiles/config"
  make_link "$DESTDIR/.ssh/config"  "$dotfiles/ssh/config"

  heading 'git user configuration'
  make_git_user_config
}

main() {
  while getopts 'hny' opt; do
    case "$opt" in
    n)  # dry run
      cmd='echo'
      echo "${yellow}Performing dry run (no changes will be made).${sgr0}"
      echo
      ;;
    y)  # assume yes, i.e. skip confirmation
      SKIP_CONFIRMATION='yes'
      ;;
    h)  # help
      usage
      exit 0
      ;;
    *)  # invalid option
      usage
      exit 1
      ;;
    esac
  done

  execute
}

main "$@"

