# My dotfiles

Always evolving...

## Quick Start

```bash
$ git clone https://github.com/fschauen/dotfiles.git $HOME/.dotfiles
$ cd $HOME/.dotfiles
$ ./install.sh -f   # omit -f for a dry run
$ ./unlock.sh       # decrypt the SSH configuration
```

If you are not me, then you won't have the password to use in the last step.
Just `git rm unlock.sh ssh/config` and add your own.

## Prerequisites

[git-crypt][] and [gpg][] are needed to decrypt sensitive information
in the repository.

[git-crypt]: https://github.com/AGWA/git-crypt
[gpg]: https://gnupg.org

