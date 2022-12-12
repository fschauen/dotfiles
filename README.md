# My dotfiles

Always evolving...

## Quick Start

1. Clone this repository (e.g. into `$HOME/.dotfiles`) and run either:
  - `./install.sh` for a dry run.
  - `./install.sh -f` to actually install.

2. Decrypt the SSH config with `gpg -d --output - <(base64 -d .key) | git crypt
   unlock -` (or just get rid of it and add your own).

## Prerequisites

[git-crypt][] and [gpg][] are needed to decrypt sensitive information
in the repository.

[git-crypt]: https://github.com/AGWA/git-crypt
[gpg]: https://gnupg.org

