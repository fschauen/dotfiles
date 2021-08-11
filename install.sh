#!/bin/sh
set -e

export DOTFILES="$(dirname "$(realpath "$0")")"

. "$DOTFILES/zsh/zshenv"
. "$DOTFILES/install/functions"

DRY_RUN=yes
while getopts 'fh' opt; do case "$opt" in
    f) DRY_RUN= ;;
    h) usage; exit 0;;
    *) usage; exit 1;;
esac done

export DEFAULT_GIT_USER="Fernando Schauenburg"
export DEFAULT_GIT_EMAIL="fernando@schauenburg.me"

# Oportunity to set GIT_USER and GIT_EMAIL
[ -f "$DOTFILES/install/config" ] && . "$DOTFILES/install/config"

greeting
deploy_alacritty
deploy_bash
deploy_bin
deploy_git
deploy_jupyter
deploy_mintty
deploy_misc
deploy_nvim
deploy_python
deploy_readline
deploy_ssh
deploy_tmux
deploy_x11
deploy_zsh

