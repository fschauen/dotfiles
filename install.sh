#!/bin/sh
set -e

DOTFILES="$(dirname "$(realpath "$0")")"
TARGET="$HOME"

[ -f "$DOTFILES/config.local" ] && . "$DOTFILES/config.local"
GIT_USER="${GIT_USER:-Fernando Schauenburg}"
GIT_EMAIL="${GIT_EMAIL:-fernando@schauenburg.me}"

main() {
    DRY_RUN=yes
    while getopts 'fht:' opt; do case "$opt" in
        f) DRY_RUN= ;;
        t) TARGET="$OPTARG";;
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
        warn
    }

    info "Deploying dotfiles:"
    info "  Source: $cyan$DOTFILES$rst"
    info "  Taget: $cyan$TARGET$rst"
    info "  Git user: $cyan$GIT_USER <$GIT_EMAIL>$rst"

    [ -t 0 ] && {
        info
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
    for cmd in $TARGET/.local/bin/*; do prune_cmd "$cmd"; done;
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
    git config -f "$temp_git" user.name "${GIT_USER}"
    git config -f "$temp_git" user.email "${GIT_EMAIL}"
    equal_content "$TARGET/.local/etc/git/config.user" "$temp_git"
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
    echo "Usage: $(basename $0) [-h] [-f] [-t <target>]"
    echo ""
    echo "  -h  print this help and exit"
    echo "  -f  modify filesystem rather than dry run"
    echo "  -t  set <target> directory (default: \$HOME)"
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

# Make sure $1 is a (relative) symlink to $2.
link() {
    target="$(python -c "import os; print os.path.relpath('$2','$(dirname $1)')")"
    [ "$(readlink "$1")" = "$target" ] && { ok "$1 -> $target"; return; }
    change "LINK $1 -> $target"
    dry_run || ln -sf "$target" "$1"
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

# Deploy package by creating subdirs and symlinks to dotfiles.
deploy() {
    package="$1"
    find "$package" -type f | while read dotfile; do
        link="$TARGET/${dotfile##"$package"/}"
        ensure_directory "$(dirname "$link")"
        [ "$(basename "$dotfile")" = '.keep' ] || link "$link" "$dotfile"
    done
}

main "$@"
