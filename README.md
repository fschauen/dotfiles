# Prerequisites

[git-crypt][] and [gpg][] are needed to decrypt sensitive information
in the repository.

[git-crypt]: https://github.com/AGWA/git-crypt
[gpg]: https://gnupg.org

# Installation

Steps:
1. Clone the repo.
1. Decrypt key & initialize git-crypt to access sensitive data.
1. Run `install.sh`

Gimme the code:
```bash
git clone https://git.schauenburg.me/fernando/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
gpg -d --output - <(base64 -d .key) | git crypt unlock -
./install.sh
```

