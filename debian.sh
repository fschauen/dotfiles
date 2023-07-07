#!/bin/sh
set -e

USERNAME=fernando
DOTFILES_URL="https://github.com/fschauen/dotfiles.git"
NEOVIM_VERSION="0.9.1"

if [ -t 1 ]; then
  sgr0="$(printf      '\033[0m')"
  red="$(printf       '\033[31m')"
  green="$(printf     '\033[32m')"
  yellow="$(printf    '\033[33m')"
  blue="$(printf      '\033[34m')"
  magenta="$(printf   '\033[35m')"
  cyan="$(printf      '\033[36m')"
else
  sgr0=''
  red=''
  green=''
  yellow=''
  blue=''
  magenta=''
  cyan=''
fi

usage() {
  echo "Usage: $(basename "$0") [-h] [-n]"
  echo ""
  echo "  -h  print this help and exit"
  echo "  -n  perform dry run"
}

error() {
  printf "${red}ERROR:${sgr0} %s\n"  "$1" >&2
  exit 1
}

heading(){
  echo "${blue}=====  ${1}  ==========${sgr0}"
}

install_packages() {
  $cmd apt update
  $cmd apt install -y           \
    apt-file                    \
    ascii                       \
    build-essential             \
    ca-certificates             \
    cmake                       \
    cmake-doc                   \
    curl                        \
    exa                         \
    exuberant-ctags             \
    fd-find                     \
    g++                         \
    gcc                         \
    git                         \
    git-crypt                   \
    gnupg                       \
    htop                        \
    jq                          \
    make                        \
    man-db                      \
    nodejs                      \
    pkg-config                  \
    psmisc                      \
    python3                     \
    ripgrep                     \
    rsync                       \
    shellcheck                  \
    sshpass                     \
    stow                        \
    sudo                        \
    tmux                        \
    zsh
  $cmd apt-file update
}

tweak_filesystem() {
  # Make `fd` available with the correct name.
  if [ -x /usr/bin/fdfind ]; then
    $cmd ln -svf /usr/bin/fdfind /usr/local/bin/fd
  else
    echo "${yellow}SKIPPED:${sgr0} /usr/bin/fdfind does not exist"
  fi

  # Make sure we have directories for all man page sections (for stow).
  $cmd mkdir -vp $(seq -f '/usr/local/man/man%.0f' 9)
}

install_neovim() {
  nvim_url="https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz"
  nvim_tarball="/usr/local/stow/nvim-${NEOVIM_VERSION}.tar.gz"
  nvim_package="nvim-${NEOVIM_VERSION}"
  nvim_install_dir="/usr/local/stow/${nvim_package}"

  if [ ! -d "${nvim_install_dir}" ]; then
    # Download the selected tarball and unpack it.
    [ ! -f "${nvim_tarball}" ] && $cmd curl -L -o "${nvim_tarball}" "${nvim_url}"
    $cmd tar --transform="s/^nvim-linux64/${nvim_package}/" -xvf "${nvim_tarball}"
    $cmd rm -vf "${nvim_tarball}"

    # Remove stuff I don't want and patch the `man` location for Debian.
    $cmd rm -rvf $(printf "${nvim_package}/share/%s " applications icons locale)
    $cmd mv -v "${nvim_package}/man" "${nvim_package}/share/"

    # Stow into `/usr/local`.
    $cmd mv -v "${nvim_package}" "/usr/local/stow/"
    $cmd stow -v -d /usr/local/stow -t /usr/local "${nvim_package}"
  else
    echo "${yellow}SKIPPED:${sgr0} ${nvim_install_dir} exists"
  fi
}

setup_user() {
  # Change shell to `zsh` and get rid of bash files.
  $cmd chsh -s /bin/zsh "$USERNAME"
  $cmd rm -vf $(printf "/home/$USERNAME/%s " .bash_history .bash_logout .bashrc .profile)

  # Add user to the `staff` group.
  $cmd usermod -aG staff "$USERNAME"

  # Allow `sudo` without password for this user.
  $cmd echo "$USERNAME	ALL=(ALL:ALL) NOPASSWD:ALL" | \
    $pipe_cmd dd status=none of="/etc/sudoers.d/${USERNAME}_nopasswd"
}

deploy_dotfiles() {
  dotfiles_dir="/home/$USERNAME/.dotfiles"
  if [ ! -d "${dotfiles_dir}" ]; then
    $cmd su "$USERNAME" -c "git clone $DOTFILES_URL ${dotfiles_dir}"
    (
      $cmd cd "${dotfiles_dir}"
      $cmd su "$USERNAME" -c "./install.sh -y"
    )
  else
    echo "${yellow}SKIPPED:${sgr0} ${dotfiles_dir} exists"
  fi
}

execute() {
  heading "Install packages"
  install_packages

  heading "Filesystem tweaks"
  tweak_filesystem

  heading "Install neovim v$NEOVIM_VERSION"
  install_neovim    # Must come after filesystem tweaks because of man pages.

  heading "Setup user: $USERNAME"
  setup_user

  heading "Deploy dotfiles"
  deploy_dotfiles
}

do_pipe_cmd() { cat; echo "| $@"; }

main() {
  while getopts 'hn' opt; do
    case "$opt" in
    n)  # dry run
      cmd=echo
      pipe_cmd=do_pipe_cmd
      execute
      exit 0
      ;;
    h)  # help
      usage
      exit 0
      ;;
    *)  # invalid argument
      usage
      exit 1
      ;;
    esac
  done

  [ "$(id -u)" -eq 0 ] || error "This script must be run as root!"
  execute
}

main $@

