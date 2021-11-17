#!/bin/sh
set -e

export DOTFILES="$(dirname "$(realpath "$0")")"
export DEFAULT_GIT_USER="Fernando Schauenburg"
export DEFAULT_GIT_EMAIL="fernando@schauenburg.me"

. "$DOTFILES/zsh/.zshenv"
[ -f "$DOTFILES/config" ] && . "$DOTFILES/config"

main() {
    DRY_RUN=yes
    while getopts 'fh' opt; do case "$opt" in
        f) DRY_RUN= ;;
        h) usage; exit 0;;
        *) usage; exit 1;;
    esac done

    greeting
    deploy_packages
    bin_extras
    git_extras
    nvim_extras
}

greeting() {
    dry_run && {
        warn "Performing dry run (use -f to actually make changes)."
        warn ""
    }

    git_info="${GIT_USER:-$DEFAULT_GIT_USER} <${GIT_EMAIL:-$DEFAULT_GIT_EMAIL}>"
    info "Deploying with git user $cyan$git_info$rst"

    [ -t 0 ] && {
        info "Press ENTER to continue (CTRL-C to cancel)..."
        read k
    }
}

deploy_packages() {
    for f in *; do
        [ -d "$f" ] && {
            heading "$f"
            deploy "$f"
        }
    done
}

bin_extras() {
    heading 'stale ~/.local/bin commands'
    for cmd in $HOME/.local/bin/*; do prune_cmd "$cmd"; done;
}


git_extras() {
    heading 'git user configuration'
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
    git config -f "$temp_git" user.name "${GIT_USER:-$DEFAULT_GIT_USER}"
    git config -f "$temp_git" user.email "${GIT_EMAIL:-$DEFAULT_GIT_EMAIL}"
    equal_content "$HOME/.local/etc/git/config.user" "$temp_git"
}

nvim_extras() {
    heading 'nvim plugins'
    if command -v nvim >/dev/null 2>&1; then
        dry_run || {
            change "installing neovim plugins..."
            nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
        }
    else
        error "neovim is not installed; skipping plugin installation..."
    fi
}

###############################################################################
# Helper Functions
###############################################################################

if [ -t 1 ]; then
    rst=$(tput      sgr0)
    red=$(tput      setaf  1)
    green=$(tput    setaf  2)
    yellow=$(tput   setaf  3)
    blue=$(tput     setaf  4)
    magenta=$(tput  setaf  5)
    cyan=$(tput     setaf  6)
else
    rst=''
    red=''
    green=''
    yellow=''
    blue=''
    magenta=''
    cyan=''
fi

dry_run() { [ -n "$DRY_RUN" ]; }

usage() {
    echo "Usage: $(basename $0) [-h] [-f]"
    echo ""
    echo "  -h  print this help and exit"
    echo "  -f  modify filesystem rather than dry run"
}

heading()   { printf '%s\n' "${blue}=====  $1  ==========${rst}"; }
info()      { printf '%s ' "$@";                            printf '\n'; }
ok()        { printf '%s ' "${green}OK:${rst}" "$@";        printf '\n'; }
change()    { printf '%s ' "${yellow}CHANGE:${rst}" "$@";   printf '\n'; }
warn()      { printf '%s ' "${yellow}$@${rst}";             printf '\n'; }
error()     { printf '%s ' "${red}$@${rst}";                printf '\n'; }

# Make sure directory $1 exists.
ensure_directory() {
    [ -d "$1" ] && return
    change "MKDIR $1/"
    dry_run || mkdir -p "$1/"
}

# Remove $1 if it's a broken link to a dotfile script.
prune_cmd() {
    if [ -h "$1" ]; then  # it's a symbolic link...
        target="$(readlink "$1")"
        case "$target" in
            "$DOTFILES/bin/"*)  # ... pointing into dotfiles bin
                if [ ! -e "$1" ]; then  # target of the link missing
                    change "UNLINK (stale) $1 -> $target"
                    dry_run || rm -f "$1"
                fi
                ;;
        esac
    fi
}

# Make sure $2 is a link to $1.
link() {
    target="$(realpath -s "$1")"
    [ "$(readlink "$2")" = "$target" ] && { ok "$2"; return; }
    change "LINK $2 -> $target"
    dry_run || ln -sf "$target" "$2"
}

# Ensure $1 and $2 contents are equal, updating $1 if needed.
equal_content() {
    diff "$1" "$2" >/dev/null 2>&1 && { ok "$1"; return; }
    change "OVERWRITE $1 with $2:"
    echo "$cyan"
    cat "$2"
    echo "$rst"
    dry_run || cp -f "$2" "$1"
}

relative_path() {
    python -c "import os.path; print os.path.relpath('$1','${2:-$PWD}')"
}

deploy() {
    find "$1" -type f -print0 | while read -d $'\0' src; do
        src_dir="$(dirname "$src")"
        dest_dir="$HOME${src_dir##"$1"}"
        ensure_directory "$dest_dir"

        filename="$(basename "$src")"
        [ "$filename" = '.keep' ] && continue

        link "$src" "$dest_dir/$filename"
    done
}

main "$@"
