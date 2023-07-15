#!/bin/sh
set -e

USERNAME=fernando
DOTFILES_URL="https://github.com/fschauen/dotfiles.git"

NEOVIM_VERSION="0.9.1"
GIT_DELTA_VERSION="0.16.5"
LF_VERSION="r30"

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

skipped() {
  echo "${yellow}SKIPPED:${sgr0} ${1}"
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
    fzf                         \
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
    unzip                       \
    zsh
  $cmd apt-file update
}

grub_disable_timeout() {
  $cmd sed -i.original -e 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
  $cmd update-grub
}

tweak_filesystem() {
  # Make `fd` available with the correct name.
  if [ -x /usr/bin/fdfind ]; then
    $cmd ln -svf /usr/bin/fdfind /usr/local/bin/fd
  else
    skipped "/usr/bin/fdfind does not exist"
  fi

  # Make sure we have directories for all man page sections (for stow).
  $cmd mkdir -vp $(seq -f '/usr/local/man/man%.0f' 9)
}

# Download $1 to $2, if $2 not already available.
download() {
  if [ -f "$2" ]; then
    echo "Using locally available $2"
  else
    echo "Downloading $1 -> $2"
    $cmd curl -SL -o "$2" "$1"
  fi
}

install_neovim() {
  nvim_url="https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz"
  nvim_tarball="/usr/local/stow/nvim-${NEOVIM_VERSION}.tar.gz"
  nvim_package="nvim-${NEOVIM_VERSION}"
  nvim_install_dir="/usr/local/stow/${nvim_package}"

  if [ -d "${nvim_install_dir}" ]; then
    skipped "${nvim_install_dir} exists"
  elif ! download "${nvim_url}" "${nvim_tarball}"; then
    skipped "${nvim_tarball} not available and failed to download ${nvim_url}"
  else
    $cmd tar --transform="s/^nvim-linux64/${nvim_package}/" -xvf "${nvim_tarball}"
    $cmd rm -vf "${nvim_tarball}"

    # Remove stuff I don't want and patch the `man` location for Debian.
    $cmd rm -rvf $(printf "${nvim_package}/share/%s " applications icons locale)
    $cmd mv -v "${nvim_package}/man" "${nvim_package}/share/"

    # Stow into `/usr/local`.
    $cmd mv -v "${nvim_package}" "/usr/local/stow/"
    $cmd stow -v -d /usr/local/stow -t /usr/local "${nvim_package}"
  fi
}

install_git_delta() {
  delta_url="https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta-musl_${GIT_DELTA_VERSION}_amd64.deb"
  delta_deb="git-delta-musl_${GIT_DELTA_VERSION}_amd64.deb"
  delta_bin="/usr/bin/delta"

  if [ -f "${delta_bin}" ]; then
    skipped "${delta_bin} exists"
  elif ! download "${delta_url}" "${delta_deb}"; then
    skipped "${delta_deb} not available and failed to download ${delta_url}"
  else
    $cmd dpkg -i "${delta_deb}"
    $cmd rm -vf "${delta_deb}"
  fi
}

install_lf() {
  lf_url="https://github.com/gokcehan/lf/releases/download/${LF_VERSION}/lf-linux-amd64.tar.gz"
  lf_tarball="lf-${LF_VERSION}.tar.gz"
  lf_package="lf-${LF_VERSION}"
  lf_install_dir="/usr/local/stow/${lf_package}"

  if [ -d "${lf_install_dir}" ]; then
    skipped "${lf_install_dir} exists"
  elif ! download "${lf_url}" "${lf_tarball}"; then
    skipped "${lf_tarball} not available and failed to download ${lf_url}"
  else
    $cmd tar -xvf "${lf_tarball}"
    $cmd rm -vf "${lf_tarball}"

    # Stow into `/usr/local`.
    $cmd mkdir -vp "${lf_install_dir}/bin"
    $cmd mv -v lf "${lf_install_dir}/bin/lf"
    $cmd stow -v -d /usr/local/stow -t /usr/local "${lf_package}"
  fi
}

user_setup() {
  if user_exists "$1"; then
    echo "User $1 exists. Updating..."
    user_update "$1"
  else
    echo "Creating user $1..."
    user_new "$1"
  fi

  user_allow_sudo_nopasswd "$1"
}

user_exists() {
	id -u "$1" >/dev/null 2>&1
}

user_new() {
  empty_skel="$(mktemp -d)"

  $cmd useradd \
    -m                ` # Create home directory.` \
    -k "$empty_skel"  ` # Copy files from this directory into the new home.` \
    -U                ` # Create a groups with the same name as the user.` \
    -G staff          ` # Other groups the new user will be a member of.` \
    -s /bin/zsh       ` # The new user's login shell. ` \
    "$1"              ` # The new user's name.` \
    >/dev/null 2>&1   ` # Silently.` \

  rmdir "$empty_skel"
}

# Add user $1 to the `staff` group...
# ...and change shell to `zsh` and get rid of bash files.
user_update() {
  $cmd usermod -aG staff "$1"
  $cmd chsh -s /bin/zsh "$1"
  $cmd rm -vf $(printf "/home/$1/%s " .bash_history .bash_logout .bashrc .profile)
}

# Allow `sudo` without password for user $1.
user_allow_sudo_nopasswd() {
  $cmd echo "$1	ALL=(ALL:ALL) NOPASSWD:ALL" | \
    $pipe_cmd dd status=none of="/etc/sudoers.d/${1}_nopasswd"
}

deploy_dotfiles() {
  dotfiles_dir="/home/$USERNAME/.dotfiles"

  if [ -d "${dotfiles_dir}" ]; then
    skipped "${dotfiles_dir} exists"
  else
    $cmd su "$USERNAME" -c "git clone $DOTFILES_URL ${dotfiles_dir}"
    (
      $cmd cd "${dotfiles_dir}"
      $cmd su "$USERNAME" -c "./install.sh -y"
    )
  fi
}

execute() {
  heading "Install packages"
  install_packages

  heading "Disable GRUB timeout"
  grub_disable_timeout

  heading "Filesystem tweaks"
  tweak_filesystem

  heading "Install neovim v$NEOVIM_VERSION"
  install_neovim    # Must come after filesystem tweaks because of man pages.

  heading "Install git-delta v$GIT_DELTA_VERSION"
  install_git_delta

  heading "Install lf v$LF_VERSION"
  install_lf

  heading "Setup user: $USERNAME"
  user_setup "$USERNAME"

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

