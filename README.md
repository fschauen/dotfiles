# Prerequisites

* [stow][]: for symlinking the dotfiles into the home directory.
* [git-crypt][]: for handling sensitive data in the repo.
* [gpg][]: for decrypting the key used by `git-crypt`.

[stow]: https://www.gnu.org/software/stow/manual/stow.html
[git-crypt]: https://github.com/AGWA/git-crypt
[gpg]: https://gnupg.org

# Installation

Steps:
1. Clone the repo.
2. Stow the files into home dir.
3. Decrypt key & initialize git-crypt to access sensitive data.

Cookbook:
```bash
    cd $HOME
    git clone git@git.schauenburg.me:fernando/dotfiles.git .dotfiles
    cd .dotfiles
    stow -v --no-folding dotfiles
    gpg -d --output - <(base64 -d .key) | git crypt unlock -
```

